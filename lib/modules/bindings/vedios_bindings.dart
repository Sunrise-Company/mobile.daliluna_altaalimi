import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/vedios_controller.dart';

class VediosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VediosController());
  }
}
