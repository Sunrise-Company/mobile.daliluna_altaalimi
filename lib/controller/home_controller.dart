import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:daliluna_altaalimi/core/services/breadcrumb_service.dart';
import 'package:daliluna_altaalimi/data/model/breadcrumb_model.dart';

class HomeController extends GetxController {
  List<dynamic> cities = [];
  bool isLoadingCities = false;
  String? citiesError;

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
      citiesError = null;
    } catch (error) {
      citiesError = 'تعذر تحميل المحافظات، حاول مجدداً';
      print('Error fetching cities: $error');
    } finally {
      isLoadingCities = false;
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
    breadcrumbService.add(BreadcrumbItem(
      title: city['name'],
      route: AppRoute.institutes,
      arguments: {
        'cityId': city['id'],
        'cityName': city['name'],
        'cityImage': city['image'],
      },
    ));

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
