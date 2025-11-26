import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/auth/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
