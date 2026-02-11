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
        
        // Validate input files
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: videoUrl.path) else {
            let error = NSError(domain: "Muxer", code: 100, userInfo: [NSLocalizedDescriptionKey: "ملف الفيديو غير موجود"])
            os_log("❌ ملف الفيديو غير موجود: %{public}@", log: muxerLog, type: .error, videoUrl.path)
            completion(false, error)
            return
        }
        
        guard fileManager.fileExists(atPath: audioUrl.path) else {
            let error = NSError(domain: "Muxer", code: 101, userInfo: [NSLocalizedDescriptionKey: "ملف الصوت غير موجود"])
            os_log("❌ ملف الصوت غير موجود: %{public}@", log: muxerLog, type: .error, audioUrl.path)
            completion(false, error)
            return
        }
        
        // Check file sizes
        do {
            let videoAttrs = try fileManager.attributesOfItem(atPath: videoUrl.path)
            let audioAttrs = try fileManager.attributesOfItem(atPath: audioUrl.path)
            let videoSize = (videoAttrs[.size] as? NSNumber)?.int64Value ?? 0
            let audioSize = (audioAttrs[.size] as? NSNumber)?.int64Value ?? 0
            
            os_log("📹 ملف الفيديو: %.2fMB, 🔊 ملف الصوت: %.2fMB", log: muxerLog, type: .info, Double(videoSize) / 1024 / 1024, Double(audioSize) / 1024 / 1024)
            
            if videoSize < 1000 || audioSize < 1000 {
                let error = NSError(domain: "Muxer", code: 102, userInfo: [NSLocalizedDescriptionKey: "ملف تالف أو صغير جداً"])
                os_log("❌ ملف تالف أو صغير جداً", log: muxerLog, type: .error)
                completion(false, error)
                return
            }
        } catch {
            os_log("❌ خطأ في الوصول إلى الملفات: %{public}@", log: muxerLog, type: .error, error.localizedDescription)
            completion(false, error)
            return
        }
        
        let mixComposition = AVMutableComposition()
        
        let videoAsset = AVURLAsset(url: videoUrl)
        let audioAsset = AVURLAsset(url: audioUrl)
        
        guard let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
              let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            let error = NSError(domain: "Muxer", code: 1, userInfo: [NSLocalizedDescriptionKey: "فشل في إنشاء المسارات"])
            os_log("❌ فشل في إنشاء المسارات", log: muxerLog, type: .error)
            completion(false, error)
            return
        }
        
        do {
            os_log("📝 جاري إدراج مسار الفيديو", log: muxerLog, type: .info)
            if let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first {
                 try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: videoAssetTrack, at: .zero)
                os_log("✅ تم إدراج مسار الفيديو بنجاح", log: muxerLog, type: .info)
            } else {
                throw NSError(domain: "Muxer", code: 3, userInfo: [NSLocalizedDescriptionKey: "لا يوجد مسار فيديو"])
            }
            
            os_log("📝 جاري إدراج مسار الصوت", log: muxerLog, type: .info)
            if let audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first {
                 try audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: audioAssetTrack, at: .zero)
                os_log("✅ تم إدراج مسار الصوت بنجاح", log: muxerLog, type: .info)
            } else {
                throw NSError(domain: "Muxer", code: 4, userInfo: [NSLocalizedDescriptionKey: "لا يوجد مسار صوت"])
            }
        } catch {
            os_log("❌ خطأ في إدراج المسارات: %{public}@", log: muxerLog, type: .error, error.localizedDescription)
            
            // Retry if failed
            if attempt < maxAttempts {
                os_log("🔄 إعادة محاولة بعد 500ms...", log: muxerLog, type: .info)
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(attempt) * 0.5) {
                    self.muxVideoWithRetry(videoUrl: videoUrl, audioUrl: audioUrl, outputUrl: outputUrl, attempt: attempt + 1, maxAttempts: maxAttempts, completion: completion)
                }
                return
            }
            
            completion(false, error)
            return
        }
        
        if fileManager.fileExists(atPath: outputUrl.path) {
            try? fileManager.removeItem(at: outputUrl)
            os_log("🗑️ تم حذف ملف الإخراج السابق", log: muxerLog, type: .info)
        }
        
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetPassthrough) else {
             let error = NSError(domain: "Muxer", code: 2, userInfo: [NSLocalizedDescriptionKey: "فشل في إنشاء المُصدّر"])
             os_log("❌ فشل في إنشاء المُصدّر", log: muxerLog, type: .error)
             completion(false, error)
             return
        }
        
        exporter.outputURL = outputUrl
        exporter.outputFileType = .mp4
        exporter.shouldOptimizeForNetworkUse = true
        
        os_log("⏳ جاري تصدير الفيديو...", log: muxerLog, type: .info)
        
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                if exporter.status == .completed {
                    do {
                        let fileAttrs = try fileManager.attributesOfItem(atPath: outputUrl.path)
                        let fileSize = (fileAttrs[.size] as? NSNumber)?.int64Value ?? 0
                        os_log("✅ تم دمج الفيديو والصوت بنجاح! حجم الملف: %.2fMB", log: self.muxerLog, type: .info, Double(fileSize) / 1024 / 1024)
                    } catch {
                        os_log("⚠️ تحذير: تم التصدير لكن فشل التحقق من الحجم", log: self.muxerLog, type: .info)
                    }
                    completion(true, nil)
                } else if exporter.status == .failed {
                    os_log("❌ فشل التصدير: %{public}@", log: self.muxerLog, type: .error, exporter.error?.localizedDescription ?? "خطأ غير معروف")
                    
                    // Retry if failed
                    if attempt < maxAttempts {
                        os_log("🔄 محاولة %d فشلت، إعادة محاولة...", log: self.muxerLog, type: .info, attempt)
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(attempt) * 0.5) {
                            self.muxVideoWithRetry(videoUrl: videoUrl, audioUrl: audioUrl, outputUrl: outputUrl, attempt: attempt + 1, maxAttempts: maxAttempts, completion: completion)
                        }
                        return
                    }
                    
                    completion(false, exporter.error)
                } else if exporter.status == .cancelled {
                    let error = NSError(domain: "Muxer", code: 5, userInfo: [NSLocalizedDescriptionKey: "تم إلغاء التصدير"])
                    os_log("⚠️ تم إلغاء التصدير", log: self.muxerLog, type: .info)
                    completion(false, error)
                } else {
                    let error = NSError(domain: "Muxer", code: 6, userInfo: [NSLocalizedDescriptionKey: "حالة غير معروفة: \(exporter.status.rawValue)"])
                    os_log("⚠️ حالة غير معروفة: %ld", log: self.muxerLog, type: .info, exporter.status.rawValue)
                    completion(false, error)
                }
            }
        }
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
