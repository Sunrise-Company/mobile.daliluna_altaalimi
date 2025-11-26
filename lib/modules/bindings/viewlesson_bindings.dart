import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/viewlesson_controller.dart';

class ViewLessonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewLessonController());
  }
}
