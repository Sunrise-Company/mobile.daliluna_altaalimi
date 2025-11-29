import 'package:get/get.dart';
import 'package:daliluna_altaalimi/data/model/breadcrumb_model.dart';

class BreadcrumbService extends GetxService {
  final RxList<BreadcrumbItem> breadcrumbs = <BreadcrumbItem>[].obs;

  void add(BreadcrumbItem item) {
    // Check if the item already exists to prevent duplicates if re-entering the same screen
    // Or if we are navigating back to a previous step, we should truncate.

    // Simple logic: If the route already exists in the list, truncate everything after it.
    int existingIndex = breadcrumbs.indexWhere(
      (element) => element.route == item.route,
    );
    if (existingIndex != -1) {
      breadcrumbs.removeRange(existingIndex + 1, breadcrumbs.length);
      // Update the title/args if they changed (optional, but good for dynamic titles)
      breadcrumbs[existingIndex] = item;
    } else {
      breadcrumbs.add(item);
    }
  }

  void clear() {
    breadcrumbs.clear();
  }

  void removeAfter(int index) {
    if (index < breadcrumbs.length - 1) {
      breadcrumbs.removeRange(index + 1, breadcrumbs.length);
    }
  }

  bool isNavigatingViaBreadcrumb = false;

  void navigateTo(int index) {
    if (index >= 0 && index < breadcrumbs.length) {
      isNavigatingViaBreadcrumb = true;
      final item = breadcrumbs[index];
      // Remove items after the selected one
      removeAfter(index);

      // Navigate back to the specific route
      // We use Get.until to pop routes until we reach the target
      Get.until((route) => route.settings.name == item.route);
      isNavigatingViaBreadcrumb = false;
    }
  }
}
