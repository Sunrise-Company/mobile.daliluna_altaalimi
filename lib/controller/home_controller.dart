import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:daliluna_altaalimi/core/services/breadcrumb_service.dart';
import 'package:daliluna_altaalimi/data/model/breadcrumb_model.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class HomeController extends GetxController {
  final GlobalKey cartKey = GlobalKey();
  List<dynamic> cities = [];
  bool isLoadingCities = false;
  String? citiesError;
  int isDeployed = 0; // Default to Review Mode

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  void goToNotifications() {
    Get.toNamed(AppRoute.notifications);
    update();
  }

  Future<void> fetchCities() async {
    try {
      isLoadingCities = true;
      update();
      cities = await ApiService.fetchCities();
      print("isssssss${cities.length}");
      try {
        isDeployed = await ApiService.fetchIsDeployed();
      } catch (e) {
        print("Error fetching isDeployed: $e");
        isDeployed = 0; // Default to 0 (Review) to hide payment
      }
      print("eeeeeeeeeeeeee$isDeployed");
      citiesError = null;
    } catch (error) {
      print("Error fetching cities: $error");
      citiesError = 'تعذر تحميل المحافظات، حاول مجدداً';
      isDeployed = 0; // Safe mode on error
    } finally {
      isLoadingCities = false;

      // Update Screenshot Protection dynamically
      try {
        if (Platform.isAndroid) {
          const securityChannel = MethodChannel(
            'com.sunrise.daliluna/security',
          );
          await securityChannel.invokeMethod('setSecure', isDeployed == 1);
        }
      } catch (e) {
        print("Error updating security flags in HomeController: $e");
      }

      update();
    }
  }

  void goToInstitutes(Map<String, dynamic> city) {
    if (city['id'] == null) {
      return;
    }

    // Add Breadcrumb
    final breadcrumbService = Get.find<BreadcrumbService>();
    breadcrumbService.clear(); // Start fresh from Home
    breadcrumbService.add(
      BreadcrumbItem(
        title: city['name'],
        route: AppRoute.institutes,
        arguments: {
          'cityId': city['id'],
          'cityName': city['name'],
          'cityImage': city['image'],
        },
      ),
    );

    Get.toNamed(
      AppRoute.institutes,
      arguments: {
        'cityId': city['id'],
        'cityName': city['name'],
        'cityImage': city['image'],
      },
    );
  }
}
