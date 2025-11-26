import 'package:get/get.dart';

import '../../controller/teacherController/homeTeacherController.dart';

class HomePageTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageTeacherController());
  }
}
