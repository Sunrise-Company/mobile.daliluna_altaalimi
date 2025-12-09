import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';

class SearchController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> searchResults = <String, dynamic>{}.obs;
  final RxInt currentTabIndex = 0.obs;

  final RxString selectedSearchType = 'منهاج'.obs;
  final List<String> searchTypes = [
    'منهاج',
    'مكثفة',
    'تأسيس',
    'أوراق عمل',
    'جلسات امتحانية',
  ];

  final RxList<String> tabs = <String>[
    'المعاهد',
    'المدرسون',
    'المواد',
    'الوحدات',
  ].obs;

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

  Future<void> search(String query, {bool maintainTab = false}) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;
      // Pass the selected type to the API only if on the Units/Sections tab (index 3)
      String? type;
      if (currentTabIndex.value == 3) {
        // Transform the type based on selection
        if (selectedSearchType.value == 'منهاج') {
          type = 'units';
        } else {
          type = 'lesson_deps';
        }
      }

      final results = await ApiService.search(query, type: type);
      searchResults.value = results;

      // Update tabs based on selection
      updateTabs();

      // Automatic tab selection logic only if not maintaining tab
      if (!maintainTab) {
        currentTabIndex.value = getInitialTabIndex(results);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء البحث');
      print('Search error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateTabs() {
    if (selectedSearchType.value == 'منهاج') {
      tabs.assignAll(['المعاهد', 'المدرسون', 'المواد', 'الوحدات']);
    } else {
      // For other types, show 'Sections' instead of 'Units' (or as appropriate)
      // Assuming 'Sections' (الأقسام) is the desired tab for other types
      tabs.assignAll(['المعاهد', 'المدرسون', 'المواد', 'الأقسام']);
    }
  }

  int getInitialTabIndex(Map<String, dynamic> results) {
    final institutes = results['institutes']?['data'] ?? [];
    final lessons = results['lessons']?['data'] ?? [];
    final teachers = results['teachers']?['data'] ?? [];
    final units = results['units']?['data'] ?? [];
    final lessonDeps = results['lesson_deps']?['data'] ?? [];

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

    // 4. If units/lesson_deps not empty -> Tab 3
    if (selectedSearchType.value == 'منهاج') {
      if (units.isNotEmpty) return 3;
    } else {
      if (lessonDeps.isNotEmpty) return 3;
    }

    // 5. If all empty -> stay on Tab 0
    return 0;
  }

  void changeTab(int index) {
    final oldIndex = currentTabIndex.value;
    currentTabIndex.value = index;

    // If switching TO index 3, or FROM index 3, we might need to re-fetch to apply/remove type.
    // Only if there is a search query.
    if (searchQuery.value.isNotEmpty) {
      if (index == 3 || oldIndex == 3) {
        search(searchQuery.value, maintainTab: true);
      }
    }
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
        if (selectedSearchType.value == 'منهاج') {
          // For 'منهاج' type, show units
          return searchResults['units']?['data'] ?? [];
        } else {
          // For other types (مكثفة, تأسيس, أوراق عمل, جلسات امتحانية), show lesson_deps
          return searchResults['lesson_deps']?['data'] ?? [];
        }

      default:
        return [];
    }
  }

  bool get hasResults => currentResults.isNotEmpty;
}
