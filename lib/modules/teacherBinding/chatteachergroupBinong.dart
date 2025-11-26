import 'package:daliluna_altaalimi/controller/teacherController/chat/groupChatController.dart';
import 'package:get/get.dart';

class ChatTeacherGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatGroupMessageTeacherController());
    // Get.put(ChatGroupMessageTeacherController(), permanent: true);
  }
}
