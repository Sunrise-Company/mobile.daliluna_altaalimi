import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/institutes_controller.dart';

class InstitutesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InstitutesController());
  }
}

