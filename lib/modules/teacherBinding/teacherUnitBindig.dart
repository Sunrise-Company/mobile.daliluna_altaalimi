import 'package:get/get.dart';
import '../../controller/teacherController/lessonUnitTeacherController.dart';

class UnitTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherLessonDepsUnitContrlloer());
  }
}
