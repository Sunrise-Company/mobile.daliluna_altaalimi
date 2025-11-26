import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';

class SearchController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> searchResults = <String, dynamic>{}.obs;
  final RxInt currentTabIndex = 0.obs;

  final List<String> tabs = ['المعاهد', 'المدرسون', 'الدروس'];

  Future<void> search(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;
      final results = await ApiService.search(query);
      searchResults.value = results;
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء البحث');
      print('Search error: $e');
    } finally {
      isLoading.value = false;
    }
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
      default:
        return [];
    }
  }

  bool get hasResults => currentResults.isNotEmpty;
}
