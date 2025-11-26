import 'package:daliluna_altaalimi/controller/vidoeLesson.dart';
import 'package:get/get.dart';

class ViideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoLessonsController());
  }
}
