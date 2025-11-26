import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherController extends GetxController {
  @override
  void onInit() {
    fetchTachers();
    fetchMyTachers();
    super.onInit();
  }

  goToSections(subjetcsid, teacher_id, classid) {
    Get.toNamed(
      AppRoute.sectionSelected,
      arguments: {
        'subjetcsid': subjetcsid,
        'teacher_id': teacher_id,
        'classid': classid,
      },
    );
  }

  goToMySections(subjetcsid, teacher_id, classid) {
    Get.toNamed(
      AppRoute.mysectionSelected,
      arguments: {
        'subjetcsid': subjetcsid,
        'teacher_id': teacher_id,
        'classid': classid,
      },
    );
  }

  bool isLoading = false;
  bool isLoadingtow = false;

  List<dynamic> dataList = [];
  void fetchTachers() async {
    try {
      dataList = await ApiService.fetchTachers();
      print(dataList);
      isLoadingtow = true;
      update();
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }

  List<dynamic> myTeachers = [];
  void fetchMyTachers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? student_id = prefs.getString('student_id');
      myTeachers = await ApiService.fetchMyTachers(student_id);
      print(myTeachers);
      isLoading = true;
      update();
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }
}
