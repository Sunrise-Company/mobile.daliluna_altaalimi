import 'dart:developer';

import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnitsSubjectController extends GetxController {
  goToLesson(int selectedItem, int app_subject_id) {
    log('eeeeeeeeeeeeeeeeeeeeeeeeeee ${selectedItem}');

    Get.toNamed(
      AppRoute.lessons,
      arguments: {"unitsid": selectedItem, 'subject_id': app_subject_id},
    );
  }

  goToMyLesson(int selectedItem, int app_subject_id) {
    print('eeeeeeeeeeeeeeeeeeeeeeeeeee');
    log(app_subject_id.toString());
    Get.toNamed(
      AppRoute.mylessons,
      arguments: {"unitsid": selectedItem, 'subject_id': app_subject_id},
    );
  }

  @override
  void onInit() {
    fetchMyUnits();
    fetchUnits();

    super.onInit();
  }

  List<dynamic> dataList = [];

  bool isLoading = false;

  void fetchUnits() async {
    try {
      print(Get.arguments['sectionid'].toString());
      print(Get.arguments['teacher_id'].toString());
      print('***********8');
      dataList = await ApiService.fetchUnits();

      isLoading = true;
      log('units' + dataList.toString());
      update();
    } catch (error) {
      print('units Error fetching classes: $error');
    }
  }

  RxList<dynamic> myunits = [].obs;
  bool isLoadingtow = false;

  void fetchMyUnits() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? student_id = prefs.getString('student_id');

      myunits.value = await ApiService.fetchMyUnits(student_id.toString());
      print("===========");

      isLoadingtow = true;

      log('myunits' + myunits.toString());
      update();
    } catch (error) {
      print('my units Error fetching classes: $error');
    }
  }
}
