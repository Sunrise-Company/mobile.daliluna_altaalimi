import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/intensivelessons_controller.dart';

class IntensiveLessonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntensiveLessonsController());
  }
}
