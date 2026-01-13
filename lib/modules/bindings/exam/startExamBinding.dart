import 'package:get/get.dart';
import '../../../controller/exam/startExamController.dart';

class StartExamBinding extends Bindings {
  @override
  void dependencies() {
    // Delete any existing instance first, then create a new one
    // This ensures fresh state for each exam
    if (Get.isRegistered<StartExamControllerss>()) {
      Get.delete<StartExamControllerss>(force: true);
    }
    Get.put<StartExamControllerss>(StartExamControllerss());
  }
}
