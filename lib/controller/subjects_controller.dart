import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daliluna_altaalimi/core/services/breadcrumb_service.dart';
import 'package:daliluna_altaalimi/data/model/breadcrumb_model.dart';

class SubjectsController extends GetxController {
  goToTeachers(int classid, int selectedItem) {
    // Find the name of the selected subject
    final selectedSubject = dataList.firstWhere(
      (element) => element['id'] == selectedItem,
      orElse: () => {},
    );
    final String subjectName = selectedSubject['name'] ?? 'المادة';

    // Add Breadcrumb
    Get.find<BreadcrumbService>().add(
      BreadcrumbItem(
        title: subjectName,
        route: AppRoute.teacher,
        arguments: {"subjetcsid": selectedItem, 'classid': classid},
      ),
    );

    Get.toNamed(
      AppRoute.teacher,
      arguments: {"subjetcsid": selectedItem, 'classid': classid},
    );
  }

  goToMyTeachers(int selectedItem, classid) {
    Get.toNamed(
      AppRoute.myteacher,
      arguments: {"subjetcsid": selectedItem, 'classid': classid},
    );
  }

  @override
  void onInit() {
    fetchSubjects();
    fetchMySubjects();
    super.onInit();
  }

  List<dynamic> dataList = [];
  bool isLoading = false;
  bool isLoadingtow = false;

  void fetchSubjects() async {
    try {
      dataList = await ApiService.fetchSubjects();
      print("===========");
      print(dataList);
      isLoadingtow = true;
      update();
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }

  List<dynamic> mySubjects = [];
  void fetchMySubjects() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? student_id = prefs.getString('student_id');

      mySubjects = await ApiService.fetchMySubjects(student_id);

      print(mySubjects);
      isLoading = true;

      update();
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }
}
