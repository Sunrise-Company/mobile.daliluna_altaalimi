import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/ourcoursesselected_controller.dart';

class OurCoursesSelectedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OurCoursesSelectedController());
  }
}
