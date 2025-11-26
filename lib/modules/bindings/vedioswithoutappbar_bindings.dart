import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/vedioswithoutappbar_controller.dart';

class VediosWithoutAppBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VediosWithoutAppBarController());
  }
}
