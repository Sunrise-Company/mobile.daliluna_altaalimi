import Flutter
import UIKit
import AVFoundation
import Photos

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let muxChannel = FlutterMethodChannel(name: "com.example.muxer", binaryMessenger: controller.binaryMessenger)
        
        muxChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "mux" {
                print("🚀 [Native] Muxing Request Received")
                guard let args = call.arguments as? [String: String],
                      let videoPath = args["video"],
                      let audioPath = args["audio"],
                      let outPath = args["out"] else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                    return
                }
                self.muxVideo(videoUrl: URL(fileURLWithPath: videoPath),
                               audioUrl: URL(fileURLWithPath: audioPath),
                               outputUrl: URL(fileURLWithPath: outPath),
                               result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func muxVideo(videoUrl: URL, audioUrl: URL, outputUrl: URL, result: @escaping FlutterResult) {
        let vAsset = AVURLAsset(url: videoUrl, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
        let aAsset = AVURLAsset(url: audioUrl, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
        
        vAsset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
            aAsset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
                DispatchQueue.main.async {
                    self.performMuxingSession(vAsset: vAsset, aAsset: aAsset, outputUrl: outputUrl, result: result)
                }
            }
        }
    }

    private func performMuxingSession(vAsset: AVAsset, aAsset: AVAsset, outputUrl: URL, result: @escaping FlutterResult) {
        guard let vTrack = vAsset.tracks(withMediaType: .video).first,
              let aTrack = aAsset.tracks(withMediaType: .audio).first else {
            print("❌ [Native] Missing Tracks")
            result(FlutterError(code: "TRACKS_MISSING", message: "Missing tracks", details: nil))
            return
        }

        let mixComposition = AVMutableComposition()
        guard let compVideoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
              let compAudioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            result(FlutterError(code: "COMP_FAILED", message: "Composition failed", details: nil))
            return
        }

        do {
            let timeRange = CMTimeRange(start: .zero, duration: vTrack.timeRange.duration)
            try compVideoTrack.insertTimeRange(timeRange, of: vTrack, at: .zero)
            try compAudioTrack.insertTimeRange(timeRange, of: aTrack, at: .zero)
            
            // Re-encoding fallback chain: Passthrough (Fast) -> 1080p -> Highest
            let presets = [AVAssetExportPresetPassthrough, AVAssetExportPreset1920x1080, AVAssetExportPresetHighestQuality]
            self.attemptExport(composition: mixComposition, vTrack: vTrack, outputUrl: outputUrl, presets: presets, result: result)
            
        } catch {
            result(FlutterError(code: "ERR", message: error.localizedDescription, details: nil))
        }
    }

    private func attemptExport(composition: AVMutableComposition, vTrack: AVAssetTrack, outputUrl: URL, presets: [String], result: @escaping FlutterResult) {
        guard let preset = presets.first else {
            result(FlutterError(code: "ALL_FAILED", message: "All presets failed", details: nil))
            return
        }

        print("⏳ [Native] Trying: \(preset)")
        if FileManager.default.fileExists(atPath: outputUrl.path) { try? FileManager.default.removeItem(at: outputUrl) }

        if let mutableTrack = composition.tracks(withMediaType: .video).first as? AVMutableCompositionTrack {
            if preset != AVAssetExportPresetPassthrough {
                mutableTrack.preferredTransform = .identity
            } else {
                mutableTrack.preferredTransform = vTrack.preferredTransform
            }
        }

        guard let exporter = AVAssetExportSession(asset: composition, presetName: preset) else {
            self.attemptExport(composition: composition, vTrack: vTrack, outputUrl: outputUrl, presets: Array(presets.dropFirst()), result: result)
            return
        }

        exporter.outputURL = outputUrl
        exporter.outputFileType = .mp4
        exporter.shouldOptimizeForNetworkUse = true

        if preset != AVAssetExportPresetPassthrough {
            let videoComposition = AVMutableVideoComposition()
            var rawSize = vTrack.naturalSize
            let transform = vTrack.preferredTransform
            if abs(transform.b) == 1.0 && abs(transform.c) == 1.0 {
                rawSize = CGSize(width: vTrack.naturalSize.height, height: vTrack.naturalSize.width)
            }
            videoComposition.renderSize = CGSize(width: CGFloat(Int(rawSize.width) & ~1), height: CGFloat(Int(rawSize.height) & ~1))
            videoComposition.frameDuration = CMTime(value: 1, timescale: Int32(max(vTrack.nominalFrameRate, 30)))
            
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRange(start: .zero, duration: composition.duration)
            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: composition.tracks(withMediaType: .video).first!)
            layerInstruction.setTransform(transform, at: .zero)
            instruction.layerInstructions = [layerInstruction]
            videoComposition.instructions = [instruction]
            exporter.videoComposition = videoComposition
        }

        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            print("🕒 [Native] Progress (\(preset)): \(Int(exporter.progress * 100))%")
        }

        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                timer.invalidate()
                if exporter.status == .completed {
                    let fileSize = (try? FileManager.default.attributesOfItem(atPath: outputUrl.path)[.size] as? Int64) ?? 0
                    print("🏁 [Native] Export Success: \(fileSize) bytes")
                    
                    // USER REQUEST: DO NOT save to Gallery. Just return success to the app.
                    if fileSize > 1_000_000 {
                        result("Success")
                    } else {
                        print("⚠️ [Native] Output too small, retrying...")
                        self.attemptExport(composition: composition, vTrack: vTrack, outputUrl: outputUrl, presets: Array(presets.dropFirst()), result: result)
                    }
                } else {
                    print("❌ [Native] Export Failed (\(preset)): \(exporter.error?.localizedDescription ?? "Unknown")")
                    self.attemptExport(composition: composition, vTrack: vTrack, outputUrl: outputUrl, presets: Array(presets.dropFirst()), result: result)
                }
            }
        }
    }
}
