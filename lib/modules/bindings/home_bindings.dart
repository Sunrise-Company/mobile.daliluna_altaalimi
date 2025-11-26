import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
