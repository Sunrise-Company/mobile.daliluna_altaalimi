import 'package:daliluna_altaalimi/controller/teacherController/videosLessonTeacherController.dart';
import 'package:get/get.dart';

class VidoeTeaherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherVideosLessonContrlloer());
  }
}
