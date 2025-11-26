import 'dart:developer';

import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';

class VediosController extends GetxController {
  String? lessonsectionsName;
  bool isFreePreviewMode = false;
  bool isSectionPurchased = false;
  bool forceFreePreview = false;
  List<dynamic> dataVideos = [];
  bool isLoadingvideo = true;

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
      final int sectionId = Get.arguments['lectureid'];

      final results = await Future.wait([ApiService.fetchVideos(sectionId)]);

      var fetchedVideos = List<dynamic>.from(results[0]);
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
      log('Error fetching section content: $error');
    } finally {
      isLoadingvideo = false;

      update();
    }
  }
}
