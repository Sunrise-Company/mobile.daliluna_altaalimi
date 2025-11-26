import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/viewvedio_controller.dart';

class ViewVedioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewVedioController());
  }
}
