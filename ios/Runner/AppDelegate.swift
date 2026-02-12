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
        os_log("🎬 [Muxer] Start attempt %d/%d", log: muxerLog, type: .info, attempt, maxAttempts)

        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: videoUrl.path) else {
            os_log("❌ [Muxer] Video file missing: %{public}@", log: muxerLog, type: .error, videoUrl.path)
            completion(false, NSError(domain: "Muxer", code: 404, userInfo: [NSLocalizedDescriptionKey: "Video file missing"]))
            return
        }
        guard fileManager.fileExists(atPath: audioUrl.path) else {
            os_log("❌ [Muxer] Audio file missing: %{public}@", log: muxerLog, type: .error, audioUrl.path)
            completion(false, NSError(domain: "Muxer", code: 404, userInfo: [NSLocalizedDescriptionKey: "Audio file missing"]))
            return
        }

        let mixComposition = AVMutableComposition()
        let videoAsset = AVURLAsset(url: videoUrl, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
        let audioAsset = AVURLAsset(url: audioUrl, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
        
        // Define keys to load
        let requiredKeys = ["tracks", "duration"]

        videoAsset.loadValuesAsynchronously(forKeys: requiredKeys) {
            audioAsset.loadValuesAsynchronously(forKeys: requiredKeys) {
                
                // --- Validation ---
                var error: NSError? = nil
                let vStatus = videoAsset.statusOfValue(forKey: "tracks", error: &error)
                let aStatus = audioAsset.statusOfValue(forKey: "tracks", error: &error)

                guard vStatus == .loaded, aStatus == .loaded else {
                    os_log("❌ [Muxer] Failed to load tracks: vStatus=%d, aStatus=%d, error=%{public}@", log: self.muxerLog, type: .error, vStatus.rawValue, aStatus.rawValue, error?.localizedDescription ?? "nil")
                    self.retryOrDetail(attempt: attempt, maxAttempts: maxAttempts, videoUrl: videoUrl, audioUrl: audioUrl, outputUrl: outputUrl, completion: completion)
                    return
                }
                
                guard let videoTrack = videoAsset.tracks(withMediaType: .video).first else {
                     os_log("❌ [Muxer] No video track found in asset", log: self.muxerLog, type: .error)
                     completion(false, NSError(domain: "Muxer", code: 400, userInfo: [NSLocalizedDescriptionKey: "No video track found"]))
                     return
                }
                guard let audioTrack = audioAsset.tracks(withMediaType: .audio).first else {
                     os_log("❌ [Muxer] No audio track found in asset", log: self.muxerLog, type: .error)
                     completion(false, NSError(domain: "Muxer", code: 400, userInfo: [NSLocalizedDescriptionKey: "No audio track found"]))
                     return
                }
                
                // --- Dimension Check ---
                let naturalSize = videoTrack.naturalSize
                os_log("🔎 [Muxer] Source video dim: %.0fx%.0f", log: self.muxerLog, type: .info, naturalSize.width, naturalSize.height)
                if naturalSize.width <= 0 || naturalSize.height <= 0 {
                    os_log("❌ [Muxer] Invalid video dimensions", log: self.muxerLog, type: .error)
                    completion(false, NSError(domain: "Muxer", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid video dimensions"]))
                    return
                }

                // --- Composition Setup ---
                // Video Track
                guard let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
                     os_log("❌ [Muxer] Failed to create video track", log: self.muxerLog, type: .error)
                     completion(false, NSError(domain: "Muxer", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to create video track"]))
                     return
                }
                // Audio Track
                guard let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
                     os_log("❌ [Muxer] Failed to create audio track", log: self.muxerLog, type: .error)
                     completion(false, NSError(domain: "Muxer", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio track"]))
                     return
                }

                do {
                    // Start at .zero
                    let timeRange = CMTimeRange(start: .zero, duration: videoAsset.duration)
                    try compositionVideoTrack.insertTimeRange(timeRange, of: videoTrack, at: .zero)
                    
                    // IMPORTANT: Correct Orientation
                    compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
                    
                    // Audio may differ in length, but we usually want to match video or use audio length?
                    // Typically for Muxing video+audio, we use the video duration as the master, or minimum of both.
                    // But here we received separate streams for same content, so durations should be very close.
                    // We'll trust the audio asset duration but clamp to video if needed, or just insert full audio.
                    // Using video duration for audio insertion is safer to avoid silence at end or cutoff if slight mismatch.
                    // Let's use audioTrack.timeRange to be safe on source content.
                    
                    let audioDuration = audioAsset.duration
                    // Ensure we don't try to insert more than available
                    let insertDuration = min(videoAsset.duration, audioDuration)
                    let audioTimeRange = CMTimeRange(start: .zero, duration: insertDuration)
                    
                    try compositionAudioTrack.insertTimeRange(audioTimeRange, of: audioTrack, at: .zero)
                    
                    os_log("✅ [Muxer] Tracks inserted. Video Duration: %.2f sec", log: self.muxerLog, type: .info, CMTimeGetSeconds(videoAsset.duration))
                    
                } catch {
                     os_log("❌ [Muxer] Track insertion failed: %{public}@", log: self.muxerLog, type: .error, error.localizedDescription)
                     completion(false, error)
                     return
                }

                // --- Export ---
                // We prefer 1920x1080 (Force H.264 re-encoding usually) or HighestQuality.
                // PassThrough might fail if codec is VP9.
                // We will try a list of presets that FORCE re-encoding.
                
                if FileManager.default.fileExists(atPath: outputUrl.path) {
                    try? FileManager.default.removeItem(at: outputUrl)
                }

                let presets = [AVAssetExportPreset1920x1080, AVAssetExportPresetHighestQuality, AVAssetExportPresetMediumQuality]
                self.exportComposition(mixComposition, to: outputUrl, withPresets: presets, completion: completion)
            }
        }
    }
    
    private func retryOrDetail(attempt: Int, maxAttempts: Int, videoUrl: URL, audioUrl: URL, outputUrl: URL, completion: @escaping (Bool, Error?) -> Void) {
        if attempt < maxAttempts {
            let delay = Double(attempt) * 1.0
            os_log("🔄 [Muxer] Retrying in %.1f sec...", log: self.muxerLog, type: .info, delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.muxVideoWithRetry(videoUrl: videoUrl, audioUrl: audioUrl, outputUrl: outputUrl, attempt: attempt + 1, maxAttempts: maxAttempts, completion: completion)
            }
        } else {
            completion(false, NSError(domain: "Muxer", code: 504, userInfo: [NSLocalizedDescriptionKey: "Max retries exceeded"]))
        }
    }

    private func exportComposition(_ composition: AVComposition, to outputUrl: URL, withPresets presets: [String], completion: @escaping (Bool, Error?) -> Void) {
        guard let preset = presets.first else {
            os_log("❌ [Muxer] All export presets failed", log: self.muxerLog, type: .error)
            completion(false, NSError(domain: "Muxer", code: 505, userInfo: [NSLocalizedDescriptionKey: "All export presets failed"]))
            return
        }
        
        os_log("⏳ [Muxer] Exporting with preset: %{public}@", log: self.muxerLog, type: .info, preset)

        guard let exporter = AVAssetExportSession(asset: composition, presetName: preset) else {
            os_log("⚠️ [Muxer] Preset %{public}@ not supported. Trying next.", log: self.muxerLog, type: .error, preset)
            exportComposition(composition, to: outputUrl, withPresets: Array(presets.dropFirst()), completion: completion)
            return
        }
        
        exporter.outputURL = outputUrl
        exporter.outputFileType = .mp4
        exporter.shouldOptimizeForNetworkUse = true
        
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                switch exporter.status {
                case .completed:
                    os_log("✅ [Muxer] Export Success!", log: self.muxerLog, type: .info)
                    completion(true, nil)
                case .failed:
                    os_log("❌ [Muxer] Export Failed (%{public}@): %{public}@", log: self.muxerLog, type: .error, preset, exporter.error?.localizedDescription ?? "Unknown")
                    // Try next preset
                    // Clean up partial file if any
                    try? FileManager.default.removeItem(at: outputUrl)
                    self.exportComposition(composition, to: outputUrl, withPresets: Array(presets.dropFirst()), completion: completion)
                case .cancelled:
                    os_log("⚠️ [Muxer] Export Cancelled", log: self.muxerLog, type: .info)
                    completion(false, NSError(domain: "Muxer", code: 506, userInfo: [NSLocalizedDescriptionKey: "Export Cancelled"]))
                default:
                    os_log("⚠️ [Muxer] Unknown Status: %d", log: self.muxerLog, type: .error, exporter.status.rawValue)
                    self.exportComposition(composition, to: outputUrl, withPresets: Array(presets.dropFirst()), completion: completion)
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
