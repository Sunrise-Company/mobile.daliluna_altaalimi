import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../linkapi.dart';

class FetchSoltoinsExamControllerss extends GetxController {
  var isLoaded = false.obs;
  RxList<dynamic> dataListExam = <dynamic>[].obs;
  RxBool isloded = false.obs;
  RxString student_result = ''.obs;
  RxString lesson_name = ''.obs;
  RxString class_name = ''.obs;
  RxString examname = ''.obs;

  var content_mark = 0.obs;
  var exam_period = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTest();
  }

  Future<void> fetchTest() async {
    try {
      isLoaded(true); // Set loading state
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      var studentId = localStorage.getString("student_id"); // Fetch student ID
      var quizId = Get.arguments['id']; // Get quiz ID from arguments

      var response = await http.get(Uri.parse(
          AppLink.server + '/dashboard/student/view_quize/$quizId/$studentId'));

      print(
          'Fetching URL:${AppLink.server}/dashboard/student/view_quize/$quizId/$studentId');
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        isloded.value = true;
        student_result.value = body['exam_result']['result'].toString();
        content_mark.value = body['content_mark'];
        lesson_name.value = body['lesson_name'];
        examname.value = body['exam']['name'];
        class_name.value = body['class_name'];
        exam_period.value = body['exam_period'];
        dataListExam.value = body['questions']; // Parse JSON into model
      }
    } catch (e) {
      print(e);
      // Get.snackbar(
      //     "Connection Error", "Please check your internet connection.");
    } finally {
      isLoaded(false); // Reset loading state
    }
  }
}
