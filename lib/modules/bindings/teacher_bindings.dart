import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/teacher_controller.dart';

class TeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherController());
  }
}
