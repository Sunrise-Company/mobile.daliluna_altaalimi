import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/subjects_controller.dart';

class SubjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubjectsController());
  }
}
