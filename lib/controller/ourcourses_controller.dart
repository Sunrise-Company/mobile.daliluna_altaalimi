import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daliluna_altaalimi/core/services/breadcrumb_service.dart';
import 'package:daliluna_altaalimi/data/model/breadcrumb_model.dart';

class OurCoursesController extends GetxController {
  RxString appVersion = ''.obs;
  RxInt isUpdate = 0.obs;
  bool isLoading = false;
  bool isLoadingcourses = false;
  int? selectedInstituteId;
  String? selectedInstituteName;

  deviceInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion(packageInfo.version).obs;
    print(appVersion);
    print(deviceinfo['version_num']);
    if (appVersion == deviceinfo['version_num']) {
      print('---------------------------------');
      isUpdate(0).obs;
    } else {
      print('0999999999999999999');
      isUpdate(1).obs;
    }
  }

  var isConnection = true.obs;

  Map<String, dynamic> deviceinfo = {'version_num': '', 'required_update': ''};
  fetchDeviceInfo() async {
    try {
      deviceinfo = await ApiService.fetchdeviceinfo();
      print("ooooooooooooooooooooooooo1;");
      print(deviceinfo);
      print("+++++++++++++++++++");
      print(appVersion);
      print(deviceinfo['version_num'].toString());
      print(appVersion == deviceinfo['version_num']);
      print(isUpdate);
      print(appVersion == deviceinfo['version_num']);
      update();
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }

  void onInit() async {
    await fetchDeviceInfo();

    await deviceInfo();
    await fetchMainslider();
    await restoreSavedInstitute();
    fetchmyClassess();

    super.onInit();
  }

  goToSubjects(int selectedItem) {
    // Find the name of the selected item
    final selectedClass = dataList.firstWhere((element) => element['id'] == selectedItem, orElse: () => {});
    final String className = selectedClass['name'] ?? 'الصف';

    // Add Breadcrumb
    Get.find<BreadcrumbService>().add(BreadcrumbItem(
      title: className,
      route: AppRoute.subjects,
      arguments: {"lessonid": selectedItem},
    ));

    Get.toNamed(AppRoute.subjects, arguments: {"lessonid": selectedItem});
  }

  goToMySubjects(int selectedItem) async {
    log(selectedItem.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? student_id = prefs.getString('student_id');
    Get.toNamed(
      AppRoute.mysubjects,
      arguments: {"lessonid": selectedItem, 'student_id': student_id},
    );
  }

  List<dynamic> sliders = [];
  final slider = <String>[].obs;
  fetchMainslider() async {
    try {
      sliders = await ApiService.fetchMainslider();
      sliders.forEach((element) {
        print("elementttttttttttttttttttttttttttttttt$element");
        slider.add(AppLink.image + '/' + element);
      });
      update();
    } catch (error) {
      isConnection(false);

      Get.snackbar(
        borderRadius: 20,
        margin: EdgeInsets.all(10),
        titleText: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "تنبيه",
            style: TextStyle(
              color: AppColor.DeepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        messageText: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "لا يوجد اتصال بالانترنت",
            style: TextStyle(color: AppColor.PrimaryColor, fontSize: 15),
          ),
        ),
        backgroundColor: AppColor.BackGround,
        padding: EdgeInsets.all(20),
        'تنبيه',
        "لا يوجد اتصال بالانترنت",
        dismissDirection: DismissDirection.startToEnd,
        duration: Duration(minutes: 10),
        icon: Directionality(
          textDirection: TextDirection.rtl,
          child: InkWell(
            onTap: () {
              Get.closeCurrentSnackbar();

              fetchMainslider();
            },
            child: Text(
              "إعادة المحاولة",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
        ),
      );

      print('Error fetching classes: $error');
    }
  }

  List<dynamic> dataList = [];

  Future<void> restoreSavedInstitute() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? savedId = prefs.getInt('selected_institute_id');
    selectedInstituteName = prefs.getString('selected_institute_name');
    if (savedId != null) {
      await loadClassesForInstitute(
        savedId,
        instituteName: selectedInstituteName,
        persistSelection: false,
      );
    } else {
      dataList = [];
      isLoading = false;
      update();
    }
  }

  Future<void> loadClassesForInstitute(
    int instituteId, {
    String? instituteName,
    bool persistSelection = true,
  }) async {
    try {
      isLoading = false;
      selectedInstituteId = instituteId;
      if (instituteName != null) {
        selectedInstituteName = instituteName;
      }
      update();
      dataList = await ApiService.fetchClasses(instituteId);
      isLoading = true;
      if (persistSelection) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('selected_institute_id', instituteId);
        if (selectedInstituteName != null) {
          await prefs.setString(
            'selected_institute_name',
            selectedInstituteName!,
          );
        }
      }
      update();
    } catch (error) {
      isConnection(false);
      Get.snackbar(
        'تنبيه',
        "تعذر تحميل البرامج الدراسية، تحقق من اتصالك بالانترنت",
        dismissDirection: DismissDirection.startToEnd,
      );
      print('Error fetching classes: $error');
    }
  }

  List<dynamic> myClassess = [];
  void fetchmyClassess() async {
    try {
      print('myyyyyyyy');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('isLogin') == true) {
        String? student_id = prefs.getString('student_id');

        myClassess = await ApiService.fetchmyClassess(student_id);

        print('555555iiiiiiiiiiii');
        print(myClassess);
        isLoadingcourses = true;
        update();
      }
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }

  bool get hasSelectedInstitute => selectedInstituteId != null;
}
