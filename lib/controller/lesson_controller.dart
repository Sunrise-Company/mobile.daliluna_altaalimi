import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

//الدروس في الوجدات
class LessonsController extends GetxController {
  RxList<dynamic> mylectures = [].obs;
  var checkingSectionId = Rx<int?>(null);
  var isloaded = false;
  var isloadedlesson = false;

  @override
  void onInit() {
    fetchLectures();
    fetchMyLectures();
    super.onInit();
  }

  goToVedios(int selectedItem) {
    Get.toNamed(AppRoute.vedios, arguments: {"lectureid": selectedItem});
  }

  void navigateToSection(Map<String, dynamic> sectionItem) async {
    final bool isPurchased = mylectures.any(
      (s) => s['id'] == sectionItem['id'],
    );

    if (isPurchased) {
      // Get.toNamed(AppRoute.viewLessons, arguments: {
      //   "lessonsectionsid": sectionItem['id'],
      //   "lessonsectionsName": sectionItem['name'],
      //   'isPurchase': true,
      //   'isFreePreview': false,
      // });
      Get.toNamed(
        AppRoute.vedios,
        arguments: {
          "lectureid": sectionItem['id'],
          'isPurchase': true,
          'isFreePreview': false,
        },
      );
    } else {
      if (checkingSectionId.value != null) return;
      try {
        checkingSectionId.value = sectionItem['id'];
        log("checkingSectionId.value" + checkingSectionId.value.toString());
        final videos = await ApiService.fetchVideos(sectionItem['id']);
        final bool hasFreeVideos = videos.any(
          (video) => video['free_status'] == "1",
        );

        if (hasFreeVideos) {
          // Get.toNamed(AppRoute.viewLessons, arguments: {
          //   "lessonsectionsid": sectionItem['id'],
          //   "lessonsectionsName": sectionItem['name'],
          //   'isPurchase': false,
          //   'isFreePreview': true,
          // });
          Get.toNamed(
            AppRoute.vedios,
            arguments: {
              "lectureid": sectionItem['id'],
              'isPurchase': false,
              'isFreePreview': true,
            },
          );
        } else {
          Get.snackbar(
            "لا يوجد محتوى مجاني",
            "هذا القسم لا يحتوي على فيديوهات مجانية للمعاينة.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.shade800,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        log("Error in navigateToSection: $e");
        Get.snackbar("خطأ", "حدث خطأ أثناء التحقق من المحتوى.");
      } finally {
        checkingSectionId.value = null;
      }
    }
  }

  List<dynamic> dataList = [];
  void fetchLectures() async {
    try {
      dataList = await ApiService.fetchLectures();
      print("===========");
      print(dataList);
      isloadedlesson = true;
      log('lecture ' + dataList.toString());
      update();
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }

  void fetchMyLectures() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? student_id = prefs.getString('student_id');
      mylectures.value = await ApiService.fetchMyLectures(student_id);
      print("===========");
      print(mylectures);
      isloaded = true;

      log('my lecture ' + mylectures.toString());
      update();
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }
}
