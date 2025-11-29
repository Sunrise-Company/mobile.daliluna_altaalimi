import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';

class SearchController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> searchResults = <String, dynamic>{}.obs;
  final RxInt currentTabIndex = 0.obs;

  final List<String> tabs = ['المعاهد', 'المدرسون', 'المواد', 'الوحدات'];
  final TextEditingController textController = TextEditingController();

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void clearSearch() {
    searchQuery.value = '';
    textController.clear();
    search('');
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;
      final results = await ApiService.search(query);
      searchResults.value = results;

      // Automatic tab selection logic
      currentTabIndex.value = getInitialTabIndex(results);
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء البحث');
      print('Search error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int getInitialTabIndex(Map<String, dynamic> results) {
    final institutes = results['institutes']?['data'] ?? [];
    final lessons = results['lessons']?['data'] ?? [];
    final teachers = results['teachers']?['data'] ?? [];
    final lectures = results['lectures']?['data'] ?? [];

    // 1. If institutes not empty -> Tab 0 (Institutes)
    if (institutes.isNotEmpty) {
      return 0;
    }
    // 2. If teachers not empty -> Tab 1 (Teachers)
    if (teachers.isNotEmpty) {
      return 1;
    }

    // 3. If lessons not empty -> Tab 2 (Lessons)
    if (lessons.isNotEmpty) {
      return 2;
    }

    // 4. If lectures not empty -> Tab 3 (Lectures)
    if (lectures.isNotEmpty) {
      return 3;
    }

    // 5. If all empty -> stay on Tab 0
    return 0;
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  List<dynamic> get currentResults {
    switch (currentTabIndex.value) {
      case 0:
        return searchResults['institutes']?['data'] ?? [];
      case 1:
        return searchResults['teachers']?['data'] ?? [];
      case 2:
        return searchResults['lessons']?['data'] ?? [];
      case 3:
        return searchResults['lectures']?['data'] ?? [];
      default:
        return [];
    }
  }

  bool get hasResults => currentResults.isNotEmpty;
}
