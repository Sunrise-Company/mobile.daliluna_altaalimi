import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class TeacherProfileController extends GetxController {
  var arabicName = ''.obs;
  var image = ''.obs;
  var education = ''.obs;
  var description = ''.obs;

  var institutes = [].obs;
  var classes = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTeacherData();
    getTeacherInfo();
  }

  Future<void> getTeacherInfo() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('tokenTeacher');
      int? teacherId = prefs.getInt('teacher_id');

      if (token == null || teacherId == null) return;

      var response = await http.get(
        Uri.parse("${AppLink.teacherInfo}/$teacherId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      log("Teacher Info: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if teacher_info exists (based on user provided JSON structure)
        var teacherInfo = responseData['teacher_info'];

        if (teacherInfo != null) {
          // Update basic info from fresh API data
          arabicName.value = teacherInfo['name'] ?? arabicName.value;
          image.value = teacherInfo['image'] ?? image.value;
          education.value = teacherInfo['education'] ?? "";
          description.value = teacherInfo['description'] ?? description.value;

          // Handle institute_name (single string in JSON, wrap in list for UI)
          if (teacherInfo['institute_name'] != null) {
            institutes.value = [teacherInfo['institute_name']];
          } else {
            institutes.clear();
          }

          // Handle subjects
          if (teacherInfo['subjects'] != null) {
            classes.value = teacherInfo['subjects'];
          } else {
            classes.clear();
          }
        }
      }
    } catch (e) {
      log("Error fetching teacher info: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTeacherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arabicName.value = prefs.getString('arabic_name') ?? 'اسم غير متوفر';
    image.value =
        prefs.getString('image') ??
        'assets/images/default_teacher.jpg'; // Default image if not found
    education.value = prefs.getString('education') ?? 'تعليم غير متوفر';
    description.value = prefs.getString('description') ?? 'وصف غير متوفر';
  }
}
