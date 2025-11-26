import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/lessondetails_controller.dart';

class LessonDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LessonDetailsController());
  }
}
