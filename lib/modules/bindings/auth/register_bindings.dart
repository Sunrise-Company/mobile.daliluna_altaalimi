import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/auth/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}
