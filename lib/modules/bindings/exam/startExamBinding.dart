import 'package:get/get.dart';
import '../../../controller/exam/startExamController.dart';

class StartExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StartExamControllerss());
  }
}
