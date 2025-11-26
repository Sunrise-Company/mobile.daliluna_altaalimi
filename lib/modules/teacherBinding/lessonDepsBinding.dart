import 'package:get/get.dart';
import '../../controller/teacherController/leesondespController.dart';

class LessonDespsTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherLessonDespsContrlloer());
  }
}
