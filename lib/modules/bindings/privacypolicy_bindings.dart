import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/privacypolicy_controller.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyPolicyController());
  }
}
