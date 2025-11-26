import 'dart:developer';

import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SectionSelectedController extends GetxController {
  @override
  void onInit() {
    fetchSections();
    fetchMySections();
    super.onInit();
  }

  bool isLoading = false;
  bool isLoadingtow = false;

  goToMySections(
    int selectedItem,
    int subjetcsid,
    int teacher_id,
    int class_id,
  ) {
    print('-----------mysection------------');
    print(selectedItem);
    Get.toNamed(
      selectedItem == 5
          ? AppRoute.lessonDetails
          : selectedItem == 6
          ? AppRoute.myunitsSubject
          : AppRoute.mysectionsSubject,
      arguments: {
        "sectionid": selectedItem,
        'subjetcsid': subjetcsid,
        'teacher_id': teacher_id,
        'classid': class_id,
      },
    );
  }

  goToSections(
    String selectedItem,
    String subjetcsid,
    String teacher_id,
    String type,
  ) {
    log('-----------0------------');
    log(selectedItem);
    log('type $type');
    log(subjetcsid);
    log(teacher_id);
    log('-----------1------------');
    if (type.toString() != '4') {
      if (selectedItem == '5') {
        Get.toNamed(
          AppRoute.lessonDetails,
          arguments: {
            "sectionid": selectedItem.toString(),
            'subjetcsid': subjetcsid,
            'teacher_id': teacher_id,
          },
        );
      } else if (selectedItem == '6') {
        print('unittt');
        Get.toNamed(
          AppRoute.unitsSubject,
          arguments: {
            "sectionid": selectedItem.toString(),
            'subjetcsid': subjetcsid,
            'teacher_id': teacher_id,
          },
        );
      } else {
        Get.toNamed(
          AppRoute.sectionsSubject,
          arguments: {
            "sectionid": selectedItem,
            'subjetcsid': subjetcsid,
            'teacher_id': teacher_id,
          },
        );
      }
    } else {
      Get.toNamed(
        AppRoute.sectionsSubject,
        arguments: {
          "sectionid": selectedItem,
          'subjetcsid': subjetcsid,
          'teacher_id': teacher_id,
        },
      );
    }
  }

  List<dynamic> dataList = [];
  void fetchSections() async {
    try {
      dataList = await ApiService.fetchSections(
        Get.arguments['classid'].toString(),
        Get.arguments['subjetcsid'].toString(),
        Get.arguments['teacher_id'].toString(),
      );
      isLoadingtow = true;
      log("sectons " + dataList.toString());
      log(
        "sectons app_main_deps2 ${Get.arguments['classid'].toString()} ${Get.arguments['subjetcsid'].toString()}  ${Get.arguments['teacher_id'].toString()}",
      );
      update();
    } catch (error) {
      print('Error fetchSections: $error');
    }
  }

  List<dynamic> mysection = [];
  void fetchMySections() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? student_id = prefs.getString('student_id');
      mysection = await ApiService.fetchMySections(
        student_id,
        Get.arguments['classid'],
        Get.arguments['teacher_id'],
      );
      log('mysection ' + mysection.toString());
      log(
        "mysection app_my_main_deps ${Get.arguments['subjetcsid']}   ${student_id} ${Get.arguments['classid'].toString()}  ${Get.arguments['teacher_id']}",
      );
      // log("mysection app_my_main_deps ${Get.arguments['subjetcsid']}   ${student_id}");
      isLoading = true;
      update();
    } catch (error) {
      print('Error fetchMySections: $error');
    }
  }
}
