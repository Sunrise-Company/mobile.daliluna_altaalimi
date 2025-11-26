import 'package:daliluna_altaalimi/controller/teacherController/chat/chatTeacherController.dart';
import 'package:get/get.dart';

class ChatTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatTeacherController());
    // Get.put(ChatTeacherController(), permanent: true);
  }
}
