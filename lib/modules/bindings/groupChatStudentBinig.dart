import 'package:daliluna_altaalimi/controller/chatStudnet/chatgroupStudentController.dart';
import 'package:get/get.dart';

class GroupChatStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatGroupMessageStudentController());
  }
}
