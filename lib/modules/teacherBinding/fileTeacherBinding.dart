import 'package:get/get.dart';

import '../../controller/teacherController/lessonDepsFileTeacherController.dart';

class FileTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherLessonDepsFileContrlloer());
  }
}
