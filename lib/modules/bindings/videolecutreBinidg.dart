import 'package:daliluna_altaalimi/controller/videoLectureControllers.dart';
import 'package:get/get.dart';

class VideoLecutresBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoLecturesController());
    Get.find<VideoLecturesController>().onInit();
  }
}
