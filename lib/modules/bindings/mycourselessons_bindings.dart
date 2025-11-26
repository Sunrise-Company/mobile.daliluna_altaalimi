import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/mycourselessons_controller.dart';

class MyCourseLessonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCourseLessonsController());
  }
}
