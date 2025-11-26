import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/homepage_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
  }
}
