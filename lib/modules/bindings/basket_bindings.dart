import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:daliluna_altaalimi/core/services/download_service.dart';

import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/ourcourses_controller.dart';

class BasketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BasketController>(() => BasketController());
    Get.put(DownloadController());
    Get.put(() => OurCoursesController());
    Get.put(Sockectcontroller(), permanent: true);
    // Get.put(() => ChatGroupMessageStudentController());
    // Get.lazyPut<ChatGroupMessageStudentController>(
    //     () => ChatGroupMessageStudentController());
    // Get.put(() => HomePageTeacherController());
    // Get.put(() => HomePageController());

    // Get.put(HomePageController());

    // Get.put(ChatGroupMessageTeacherController(), permanent: true);
    // Get.put(ChatTeacherController(), permanent: true);
    // Get.put(ListStudentChatController(), permanent: true);
  }
}
