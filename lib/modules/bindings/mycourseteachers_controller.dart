import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/mycourseteachers_controller.dart';

class MyCourseTeachersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCourseTeachersController());
  }
}
