import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/mycoursesections_controller.dart';

class MyCourseSectionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCourseSectionsController());
  }
}
