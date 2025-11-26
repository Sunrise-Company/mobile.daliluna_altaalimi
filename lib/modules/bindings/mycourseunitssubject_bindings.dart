import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/mycourseunitssubject_cotroller.dart';

class MyCourseUnitsSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCourseUnitsSubjectController());
  }
}
