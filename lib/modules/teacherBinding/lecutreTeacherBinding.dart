import 'package:get/get.dart';
import '../../controller/teacherController/lectureTeacherController.dart';

class LectureTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherLectureDespsContrlloer());
  }
}
