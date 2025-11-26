import 'package:get/get.dart';

class HomePageTeacherController extends GetxController {
  var selectedPage = 1.obs;

  void changePage(int index) {
    selectedPage.value = index;
  }
}
