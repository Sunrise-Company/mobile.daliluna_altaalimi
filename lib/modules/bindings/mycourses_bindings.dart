import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/mycourses_controller.dart';

class MyCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCoursesController());
  }
}
