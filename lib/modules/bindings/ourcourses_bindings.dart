import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/ourcourses_controller.dart';

class OurCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OurCoursesController());
  }
}
