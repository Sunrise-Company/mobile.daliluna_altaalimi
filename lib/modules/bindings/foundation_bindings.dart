import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/foundation_controller.dart';

class FoundationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FoundationController());
  }
}
