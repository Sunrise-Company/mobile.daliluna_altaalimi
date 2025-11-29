import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'breadcrumb_service.dart';

class BreadcrumbObserver extends NavigatorObserver {
  final BreadcrumbService _breadcrumbService = Get.find<BreadcrumbService>();

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    // Only handle if not navigating via breadcrumb widget (which handles state manually)
    if (!_breadcrumbService.isNavigatingViaBreadcrumb) {
      if (_breadcrumbService.breadcrumbs.isNotEmpty) {
        final lastItem = _breadcrumbService.breadcrumbs.last;

        // If the popped route matches the last breadcrumb, remove it
        if (route.settings.name == lastItem.route) {
          _breadcrumbService.breadcrumbs.removeLast();
        }
      }
    }
  }
}
