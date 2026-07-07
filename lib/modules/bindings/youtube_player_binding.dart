import 'package:daliluna_altaalimi/controller/youtube_player_controller.dart';
import 'package:get/get.dart';

class YoutubePlayerBinding extends Bindings {
  @override
  void dependencies() {
    final videoId = Get.arguments['videoId'];
    if (Get.isRegistered<YoutubePlayerController>(tag: videoId)) {
      Get.delete<YoutubePlayerController>(tag: videoId);
    }

    Get.put(
      YoutubePlayerController(
        videoId: videoId,
        lessonId: Get.arguments['lessonId'],
        type: Get.arguments['type'],
      ),
      tag: videoId,
    );
  }
}
