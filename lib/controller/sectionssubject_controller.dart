import 'dart:developer';

import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

//كونترولر الاقسام
class SectionsSubjectController extends GetxController {
  var checkingSectionId = Rx<int?>(null);
  @override
  void onInit() {
    fetchSections();
    fetchMySections();
    super.onInit();
  }

  var isPurchase = false.obs;

  void navigateToSection(Map<String, dynamic> sectionItem) async {
    final bool isPurchased = mysection.any((s) => s['id'] == sectionItem['id']);

    if (isPurchased) {
      Get.toNamed(
        AppRoute.viewLessons,
        arguments: {
          "lessonsectionsid": sectionItem['id'],
          "lessonsectionsName": sectionItem['name'],
          'isPurchase': true,
          'isFreePreview': false,
        },
      );
    } else {
      if (checkingSectionId.value != null) return;
      try {
        checkingSectionId.value = sectionItem['id'];
        final videos = await ApiService.fetchSectionVideos(sectionItem['id']);
        final bool hasFreeVideos = videos.any(
          (video) => video['free_status'] == "1",
        );
        if (sectionItem['main_dep']['type'].toString() == '4') {
          Get.toNamed(
            AppRoute.viewLessons,
            arguments: {
              "lessonsectionsid": sectionItem['id'],
              "lessonsectionsName": sectionItem['name'],
              'isPurchase': true,
              'isFreePreview': false,
            },
          );
        } else if (hasFreeVideos) {
          Get.toNamed(
            AppRoute.viewLessons,
            arguments: {
              "lessonsectionsid": sectionItem['id'],
              "lessonsectionsName": sectionItem['name'],
              'isPurchase': false,
              'isFreePreview': true,
            },
          );
        } else {
          // Allow access even without free videos, all will be locked
          Get.toNamed(
            AppRoute.viewLessons,
            arguments: {
              "lessonsectionsid": sectionItem['id'],
              "lessonsectionsName": sectionItem['name'],
              'isPurchase': false,
              'isFreePreview': false,
            },
          );
        }
      } catch (e) {
        Get.snackbar("خطأ", "حدث خطأ أثناء التحقق من المحتوى.");
      } finally {
        checkingSectionId.value = null;
      }
    }
  }

  bool isLoading = false;
  bool isLoadingtow = false;

  List<dynamic> dataList = [];
  void fetchSections() async {
    try {
      dataList = await ApiService.fetchLessonSections();

      isLoadingtow = true;

      update();
    } catch (error) {}
  }

  RxList<dynamic> mysection = <dynamic>[].obs;

  void fetchMySections() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? student_id = prefs.getString('student_id');
      mysection.value = await ApiService.fetchMyLessonSections(student_id);
      isLoading = true;

      update();
    } catch (error) {}
  }
}
