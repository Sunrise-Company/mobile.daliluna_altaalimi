import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/ourcourseexams_controller.dart';

class OurCoursesExamsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OurCoursesExamsController());
  }
}
