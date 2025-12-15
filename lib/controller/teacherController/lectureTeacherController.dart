import 'dart:convert';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherLectureDespsContrlloer extends GetxController {
  RxBool isloded = false.obs;
  // RxMap<String, dynamic> dataList = <String, dynamic>{}.obs;
  //
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
      // ignore: unused_local_variable
      int? teacher_id = prefs.getInt('teacher_id');

      final response = await http.get(
        Uri.parse(
          AppLink.server +
              '/app_teacher_lectures_deps/${Get.arguments['id'].toString()}',
        ),
      );

      print(
        AppLink.server +
            '/app_teacher_lectures_deps/${Get.arguments['id'].toString()}',
      );
      if (response.statusCode == 200) {
        isloded.value = true;

        final responseData = jsonDecode(response.body);

        dataList.value = responseData;

        update();
      } else {
        throw Exception('Failed to load studentLesson');
      }
    } catch (error) {
      // Handle errors appropriately, e.g., show a message to the user
    }
  }

  @override
  // ignore: override_on_non_overriding_member
  goToItem(int lessonId) {
    Get.toNamed(
      '/conatine_lesson',
      arguments: {
        // "lesson_id": subjectId,
        "id": lessonId,
      },
    );

    // dataList.clear();
  }
}
