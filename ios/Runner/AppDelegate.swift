import Flutter
import UIKit
import UserNotifications
import AVFoundation
import CoreMedia
import os.log

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var blurView: UIVisualEffectView?
  private let muxerLog = OSLog(subsystem: "com.sunrise.daliluna_altaalimi", category: "Muxer")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    // Register Muxer Channel
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let muxChannel = FlutterMethodChannel(name: "com.example.muxer",
                                          binaryMessenger: controller.binaryMessenger)
    muxChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "mux" {
            guard let args = call.arguments as? [String: String],
                  let videoPath = args["video"],
                  let audioPath = args["audio"],
                  let outPath = args["out"] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            self.muxVideo(videoUrl: URL(fileURLWithPath: videoPath),
                          audioUrl: URL(fileURLWithPath: audioPath),
                          outputUrl: URL(fileURLWithPath: outPath)) { success, error in
                if success {
                    result(nil)
                } else {
                    result(FlutterError(code: "MUX_ERR", message: error?.localizedDescription, details: nil))
                }
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    })
    
    // Initialize blur view
    let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    blurView = UIVisualEffectView(effect: blurEffect)
    blurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func muxVideo(videoUrl: URL, audioUrl: URL, outputUrl: URL, completion: @escaping (Bool, Error?) -> Void) {
        // Try muxing with retry logic
        muxVideoWithRetry(videoUrl: videoUrl, audioUrl: audioUrl, outputUrl: outputUrl, attempt: 1, maxAttempts: 3, completion: completion)
    }
    
    private func muxVideoWithRetry(videoUrl: URL, audioUrl: URL, outputUrl: URL, attempt: Int, maxAttempts: Int, completion: @escaping (Bool, Error?) -> Void) {
        os_log("🎬 محاولة دمج الفيديو والصوت (محاولة %d/%d)", log: muxerLog, type: .info, attempt, maxAttempts)

        // Validate input files quickly
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: videoUrl.path), fileManager.fileExists(atPath: audioUrl.path) else {
            let error = NSError(domain: "Muxer", code: 100, userInfo: [NSLocalizedDescriptionKey: "ملفات الإدخال غير موجودة"])
            os_log("❌ ملف/ملفات الإدخال غير موجودة", log: muxerLog, type: .error)
            completion(false, error)
            return
        }

        // Build composition but load tracks asynchronously to avoid transient "no track" errors
        let mixComposition = AVMutableComposition()
        let videoAsset = AVURLAsset(url: videoUrl)
        let audioAsset = AVURLAsset(url: audioUrl)
        let requiredKeys = ["tracks"]

        func attemptToPrepareAndMux(_ attemptLocal: Int) {
            videoAsset.loadValuesAsynchronously(forKeys: requiredKeys) {
                audioAsset.loadValuesAsynchronously(forKeys: requiredKeys) {
                    var vError: NSError? = nil
                    var aError: NSError? = nil
                    let vStatus = videoAsset.statusOfValue(forKey: "tracks", error: &vError)
                    let aStatus = audioAsset.statusOfValue(forKey: "tracks", error: &aError)

                    let hasVideo = (vStatus == .loaded) && !videoAsset.tracks(withMediaType: .video).isEmpty
                    let hasAudio = (aStatus == .loaded) && !audioAsset.tracks(withMediaType: .audio).isEmpty

                    if !hasVideo || !hasAudio {
                        os_log("❌ أحد المسارات غير متاح بعد تحميل القيم: video=%{public}@ audio=%{public}@", log: self.muxerLog, type: .error, String(hasVideo), String(hasAudio))
                        if attemptLocal < maxAttempts {
                            let delay = Double(attemptLocal) * 0.5
                            os_log("🔄 انتظار ثم إعادة المحاولة بعد %{public}.2f ثانية (محاولة %d)", log: self.muxerLog, type: .info, delay, attemptLocal + 1)
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                attemptToPrepareAndMux(attemptLocal + 1)
                            }
                            return
                        } else {
                            let missing = !hasVideo ? "لا يوجد مسار فيديو" : "لا يوجد مسار صوت"
                            let error = NSError(domain: "Muxer", code: 3, userInfo: [NSLocalizedDescriptionKey: missing])
                            completion(false, error)
                            return
                        }
                    }

                    // Now safe to add tracks
                    guard let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
                          let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
                        let error = NSError(domain: "Muxer", code: 1, userInfo: [NSLocalizedDescriptionKey: "فشل في إنشاء المسارات"])
                        os_log("❌ فشل في إنشاء المسارات", log: self.muxerLog, type: .error)
                        completion(false, error)
                        return
                    }

                    do {
                        os_log("📝 جاري إدراج مسار الفيديو", log: self.muxerLog, type: .info)
                        if let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first {
                            try videoTrack.insertTimeRange(videoAssetTrack.timeRange, of: videoAssetTrack, at: .zero)
                            os_log("✅ تم إدراج مسار الفيديو بنجاح (Duration: %.2f)", log: self.muxerLog, type: .info, CMTimeGetSeconds(videoAssetTrack.timeRange.duration))
                        } else {
                            throw NSError(domain: "Muxer", code: 3, userInfo: [NSLocalizedDescriptionKey: "لا يوجد مسار فيديو"])
                        }

                        os_log("📝 جاري إدراج مسار الصوت", log: self.muxerLog, type: .info)
                        if let audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first {
                            try audioTrack.insertTimeRange(audioAssetTrack.timeRange, of: audioAssetTrack, at: .zero)
                            os_log("✅ تم إدراج مسار الصوت بنجاح", log: self.muxerLog, type: .info)
                        } else {
                            throw NSError(domain: "Muxer", code: 4, userInfo: [NSLocalizedDescriptionKey: "لا يوجد مسار صوت"])
                        }
                    } catch {
                        os_log("❌ خطأ في إدراج المسارات بعد تحميل القيم: %{public}@", log: self.muxerLog, type: .error, String(describing: error.localizedDescription))
                        if attemptLocal < maxAttempts {
                            let delay = Double(attemptLocal) * 0.5
                            os_log("🔄 إعادة محاولة بعد %{public}.2f ثانية...", log: self.muxerLog, type: .info, delay)
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                attemptToPrepareAndMux(attemptLocal + 1)
                            }
                            return
                        }
                        completion(false, error)
                        return
                    }

                    // Proceed with export
                    if FileManager.default.fileExists(atPath: outputUrl.path) {
                        try? FileManager.default.removeItem(at: outputUrl)
                        os_log("🗑️ تم حذف ملف الإخراج السابق", log: self.muxerLog, type: .info)
                    }

                    // Define presets to try: High -> Medium -> Low
                    let presets = [AVAssetExportPresetHighestQuality, AVAssetExportPresetMediumQuality, AVAssetExportPresetLowQuality]
                    
                    // Recursive function to try presets
                    func tryExport(with presets: [String]) {
                        guard let currentPreset = presets.first else {
                            // All presets failed
                            let error = NSError(domain: "Muxer", code: 7, userInfo: [NSLocalizedDescriptionKey: "فشل التصدير بجميع الجودات المتاحة"])
                            completion(false, error)
                            return
                        }

                        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: currentPreset) else {
                            os_log("⚠️ فشل إنشاء المُصدّر للجودة: %{public}@", log: self.muxerLog, type: .error, currentPreset)
                            tryExport(with: Array(presets.dropFirst()))
                            return
                        }

                        exporter.outputURL = outputUrl
                        exporter.outputFileType = .mp4
                        exporter.shouldOptimizeForNetworkUse = true

                        os_log("⏳ جاري تصدير الفيديو بجودة: %{public}@", log: self.muxerLog, type: .info, currentPreset)

                        exporter.exportAsynchronously {
                            DispatchQueue.main.async {
                                if exporter.status == .completed {
                                    do {
                                        let fileAttrs = try FileManager.default.attributesOfItem(atPath: outputUrl.path)
                                        let fileSize = (fileAttrs[.size] as? NSNumber)?.int64Value ?? 0
                                        os_log("✅ تم دمج الفيديو والصوت بنجاح! حجم الملف: %.2fMB (Preset: %{public}@)", log: self.muxerLog, type: .info, Double(fileSize) / 1024 / 1024, currentPreset)
                                    } catch {
                                        os_log("⚠️ تحذير: تم التصدير لكن فشل التحقق من الحجم", log: self.muxerLog, type: .info)
                                    }
                                    completion(true, nil)
                                } else if exporter.status == .failed {
                                    os_log("❌ فشل التصدير بجودة %{public}@: %{public}@", log: self.muxerLog, type: .error, currentPreset, exporter.error?.localizedDescription ?? "خطأ غير معروف")
                                    // Try next preset
                                    tryExport(with: Array(presets.dropFirst()))
                                } else if exporter.status == .cancelled {
                                    let error = NSError(domain: "Muxer", code: 5, userInfo: [NSLocalizedDescriptionKey: "تم إلغاء التصدير"])
                                    os_log("⚠️ تم إلغاء التصدير", log: self.muxerLog, type: .info)
                                    completion(false, error)
                                } else {
                                    // Unknown state, likely transient, try next preset to be safe? Or fail?
                                    // Let's treat as fail for this preset
                                     os_log("⚠️ حالة غير معروفة: %ld", log: self.muxerLog, type: .info, exporter.status.rawValue)
                                     tryExport(with: Array(presets.dropFirst()))
                                }
                            }
                        }
                    }

                    // Start exporting with the list of presets
                    tryExport(with: presets)
                }
            }
        }

        // Start attempts
        attemptToPrepareAndMux(attempt)
    }
  
  override func applicationWillResignActive(_ application: UIApplication) {
      if let window = self.window, let view = blurView {
          view.frame = window.bounds
          window.addSubview(view)
      }
      super.applicationWillResignActive(application)
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
      blurView?.removeFromSuperview()
      super.applicationDidBecomeActive(application)
  }
}
