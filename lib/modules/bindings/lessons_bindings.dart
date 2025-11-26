import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/lesson_controller.dart';

class LessonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LessonsController());
  }
}
