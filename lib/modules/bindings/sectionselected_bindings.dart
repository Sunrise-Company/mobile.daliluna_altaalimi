import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/sectionselected_controller.dart';

class SectionSelectedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SectionSelectedController());
  }
}
