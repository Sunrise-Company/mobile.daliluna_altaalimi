import 'dart:math';

import 'package:get/get.dart';

class HomePageController extends GetxController {
  var selectedPage = 2.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void changePage(int index) {
    log(index);
    selectedPage.value = index;
  }
}
