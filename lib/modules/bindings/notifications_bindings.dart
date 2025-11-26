import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => NotificationsController());
  }
}
