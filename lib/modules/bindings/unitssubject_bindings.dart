import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/unitssubject_controller.dart';

class UnitsSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UnitsSubjectController());
  }
}
