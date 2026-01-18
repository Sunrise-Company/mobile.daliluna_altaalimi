import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/ourcourses_controller.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:daliluna_altaalimi/core/services/breadcrumb_service.dart';
import 'package:daliluna_altaalimi/data/model/breadcrumb_model.dart';

import 'basket_controller.dart';

class InstitutesController extends GetxController {
  late final int cityId;
  late final String cityName;
  String? cityImage;

  List<dynamic> institutes = [];
  bool isLoading = true;
  String? errorMessage;
  //////////////
  final BasketController basketController = Get.find<BasketController>();
  late final OurCoursesController coursesController;

  @override
  void onInit() {
    super.onInit();
    coursesController = Get.find<OurCoursesController>();
    cityId = Get.arguments['cityId'];
    cityName = Get.arguments['cityName'] ?? '';
    cityImage = Get.arguments['cityImage'];
    fetchInstitutes();
  }

  Future<void> fetchInstitutes() async {
    try {
      isLoading = true;
      update();
      institutes = await ApiService.fetchInstitutes(cityId);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'تعذر تحميل المعاهد، حاول مجدداً';
    } finally {
      isLoading = false;
      update();
    }
  }

  void selectInstitute(Map<String, dynamic> institute) {
    if (institute['id'] == null) return;
    coursesController.loadClassesForInstitute(
      institute['id'],
      instituteName: institute['name'],
    );
    ///////////
    final String id = institute['id'].toString();

    // تحديث id المعهد في السلة
    basketController.updateInstituteId(id);
    print("raghad ${basketController.instituteId}");
    ///////////////////
    // Add Breadcrumb
    Get.find<BreadcrumbService>().add(
      BreadcrumbItem(title: institute['name'], route: AppRoute.ourCourses),
    );

    Get.toNamed(AppRoute.ourCourses);
  }
}
