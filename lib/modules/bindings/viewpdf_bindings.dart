import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/viewpdf_controller.dart';

class ViewPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewPdfController());
  }
}
