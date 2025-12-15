import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'dart:developer';

class ViewLessonController extends GetxController {
  String? lessonsectionsName;
  bool isFreePreviewMode = false;
  bool isSectionPurchased = false;
  bool forceFreePreview = false;
  List<dynamic> dataVideos = [];
  bool isLoadingvideo = true;
  List<dynamic> dataFiles = [];
  bool isLoadingfile = true;
  @override
  void onInit() {
    forceFreePreview = Get.arguments['isFreePreview'] ?? false;
    isSectionPurchased = Get.arguments['isPurchase'] ?? false;
    lessonsectionsName = Get.arguments?['lessonsectionsName'];
    fetchSectionContent();
    super.onInit();
  }

  Future<void> fetchSectionContent() async {
    try {
      final int sectionId = Get.arguments['lessonsectionsid'];

      final results = await Future.wait([
        ApiService.fetchSectionVideos(sectionId),
        ApiService.fetchSectionFiles(sectionId),
      ]);

      var fetchedVideos = List<dynamic>.from(results[0]);
      dataFiles = results[1];

      final freeVideos = fetchedVideos
          .where((video) => video['free_status'] == "1")
          .toList();
      final paidVideos = fetchedVideos
          .where((video) => video['free_status'] != "1")
          .toList();

      dataVideos = isSectionPurchased
          ? fetchedVideos
          : [...freeVideos, ...paidVideos];

      if (forceFreePreview) {
        isFreePreviewMode = true;
      } else {
        isFreePreviewMode = false;
      }
    } catch (error) {
    } finally {
      isLoadingvideo = false;
      isLoadingfile = false;
      update();
    }
  }
}
