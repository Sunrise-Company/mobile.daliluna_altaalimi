import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/sectionssubject_controller.dart';

class SectionSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SectionsSubjectController());
  }
}
