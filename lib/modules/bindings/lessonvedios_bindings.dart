import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/lessonvedio_controller.dart';

class LessonVediosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LessonVediosController());
  }
}
