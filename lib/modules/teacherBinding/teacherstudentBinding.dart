import 'package:get/get.dart';
import '../../controller/teacherController/teacherStudentController.dart/teacherstudent.dart';

class TeacherListStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherListStudentContrlloer());
  }
}
