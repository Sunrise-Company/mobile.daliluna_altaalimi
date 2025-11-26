import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class VideoPlayerControllerX extends GetxController {
  late VideoPlayerController videoController;
  ChewieController? chewieController;
  final String videoUrl;
  var isInitialized = false.obs;
  VideoPlayerControllerX(this.videoUrl);

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    videoController = VideoPlayerController.network(videoUrl);
    await videoController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      aspectRatio: videoController.value.aspectRatio,
    );
    isInitialized.value = true;
  }

  @override
  void onClose() {
    videoController.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
