import 'dart:convert';
import 'package:daliluna_altaalimi/linkapi.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherLessonContrlloer extends GetxController {
  RxBool isloded = false.obs;
  RxList<dynamic> dataList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    getSudenteLesson();
  }

  Future<void> getSudenteLesson() async {
    isloded.value = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? teacher_id = prefs.getInt('teacher_id');

      if (teacher_id == null) {
        throw Exception('Teacher ID not found');
      }

      final response = await http.get(
        Uri.parse(
          AppLink.server + '/app_teacher_lesson/${teacher_id.toString()}',
        ),
      );
      print(
        'https://app.aasvs.com/api/app_teacher_lesson/${teacher_id.toString()}',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['app_teacher_lesson'] != null) {
          // The app_teacher_lesson is already a list, so we can directly assign it
          dataList.value = responseData['app_teacher_lesson']
              .map((lesson) => lesson['app_lesson'])
              .toList();
        } else {
          dataList.value = [];
        }

        isloded.value = true;
        update();
      } else {
        throw Exception('Failed to load studentLesson: ${response.statusCode}');
      }
    } catch (error) {
      isloded.value = true;
      update();
      // Handle errors appropriately, e.g., show a message to the user
    }
  }
}
