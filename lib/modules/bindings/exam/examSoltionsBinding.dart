import 'package:get/get.dart';

import '../../../controller/exam/examSlotiounsController.dart';

class ExamSolutionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FetchSoltoinsExamControllerss());
  }
}
