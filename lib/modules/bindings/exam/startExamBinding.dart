import 'package:get/get.dart';
import '../../../controller/exam/startExamController.dart';

class StartExamBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<StartExamControllerss>()) {
      Get.delete<StartExamControllerss>(force: true);
    }
    Get.put<StartExamControllerss>(StartExamControllerss());
  }
}
