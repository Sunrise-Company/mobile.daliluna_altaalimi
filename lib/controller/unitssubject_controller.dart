import 'dart:developer';

import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daliluna_altaalimi/core/services/breadcrumb_service.dart';
import 'package:daliluna_altaalimi/data/model/breadcrumb_model.dart';

class UnitsSubjectController extends GetxController {
  goToLesson(int selectedItem, int app_subject_id) {
    // Find the name of the selected unit
    final selectedUnit = dataList.firstWhere(
      (element) => element['id'] == selectedItem,
      orElse: () => {},
    );
    final String unitName = selectedUnit['name'] ?? 'الوحدة';

    // Add Breadcrumb
    Get.find<BreadcrumbService>().add(
      BreadcrumbItem(
        title: unitName,
        route: AppRoute.lessons,
        arguments: {"unitsid": selectedItem, 'subject_id': app_subject_id},
      ),
    );

    Get.toNamed(
      AppRoute.lessons,
      arguments: {"unitsid": selectedItem, 'subject_id': app_subject_id},
    );
  }

  goToMyLesson(int selectedItem, int app_subject_id) {
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
      dataList = await ApiService.fetchUnits();

      isLoading = true;

      update();
    } catch (error) {}
  }

  RxList<dynamic> myunits = [].obs;
  bool isLoadingtow = false;

  void fetchMyUnits() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? student_id = prefs.getString('student_id');

      myunits.value = await ApiService.fetchMyUnits(student_id.toString());

      isLoadingtow = true;

      update();
    } catch (error) {}
  }
}
