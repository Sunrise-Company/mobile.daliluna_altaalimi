import Cocoa
import FlutterMacOS
import AVFoundation
import CoreMedia

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
      
    let muxChannel = FlutterMethodChannel(name: "com.example.muxer",
                                          binaryMessenger: flutterViewController.engine.binaryMessenger)
    muxChannel.setMethodCallHandler { [weak self] (call, result) in
        if call.method == "mux" {
            guard let args = call.arguments as? [String: String],
                  let videoPath = args["video"],
                  let audioPath = args["audio"],
                  let outPath = args["out"] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            self?.muxVideo(videoUrl: URL(fileURLWithPath: videoPath),
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
    }

    super.awakeFromNib()
  }

  func muxVideo(videoUrl: URL, audioUrl: URL, outputUrl: URL, completion: @escaping (Bool, Error?) -> Void) {
      let mixComposition = AVMutableComposition()
      
      let videoAsset = AVURLAsset(url: videoUrl)
      let audioAsset = AVURLAsset(url: audioUrl)
      
      guard let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
            let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
          completion(false, NSError(domain: "Muxer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create tracks"]))
          return
      }
      
      do {
          if let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first {
               try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: videoAssetTrack, at: .zero)
          }
          if let audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first {
               try audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: audioAssetTrack, at: .zero)
          }
      } catch {
          completion(false, error)
          return
      }
      
      if FileManager.default.fileExists(atPath: outputUrl.path) {
          try? FileManager.default.removeItem(at: outputUrl)
      }
      
      guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetPassthrough) else {
           completion(false, NSError(domain: "Muxer", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to create exporter"]))
           return
      }
      
      exporter.outputURL = outputUrl
      exporter.outputFileType = .mp4
      exporter.shouldOptimizeForNetworkUse = true
      
      exporter.exportAsynchronously {
          DispatchQueue.main.async {
              if exporter.status == .completed {
                  completion(true, nil)
              } else {
                  completion(false, exporter.error)
              }
          }
      }
  }
}
