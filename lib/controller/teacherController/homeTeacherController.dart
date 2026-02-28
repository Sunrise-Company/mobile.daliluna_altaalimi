import 'package:get/get.dart';

import '../../core/services/apiservices.dart';

class HomePageTeacherController extends GetxController {
  var isDeployed = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchIsDeployed();
  }
  var selectedPage = 1.obs;

  void changePage(int index) {
    selectedPage.value = index;
  }
  Future<void> fetchIsDeployed() async {
    try {
      isDeployed.value = await ApiService.fetchIsDeployed();
      print("dddddddddddddd${isDeployed.value}");
    } catch (e) {
      isDeployed.value = 0;
    }
  }
}
