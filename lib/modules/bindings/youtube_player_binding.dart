import 'package:daliluna_altaalimi/controller/youtube_player_controller.dart';
import 'package:get/get.dart';

class YoutubePlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      YoutubePlayerController(
        videoId: Get.arguments['videoId'],
        lessonId: Get.arguments['lessonId'],
        type: Get.arguments['type'],
      ),
      tag: Get.arguments['videoId'],
    );
  }
}
