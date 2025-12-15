import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InialController extends GetxController {
  var selectedPage = 1.obs;
  var isLoading = true.obs; // Loading state

  @override
  void onInit() {
    // TODO: implement onInit
    isteacher();
    super.onInit();
  }

  void changePage(int index) {
    selectedPage.value = index;
  }

  isteacher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? teacher_id = prefs.getInt('teacher_id');

    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false; // Set loading to false after checking

    if (teacher_id != null) {
      Get.toNamed('/homepageTeacher');
    } else {
      Get.toNamed('/homepage');
    }
  }
}
