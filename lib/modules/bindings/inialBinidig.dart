import 'package:get/get.dart';

import '../../controller/inialController.dart';

class InialHomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InialController());
  }
}
