import 'dart:convert';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherListStudentContrlloer extends GetxController {
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
      int? teacher_id = prefs.getInt('teacher_id');

      final response = await http.get(
        Uri.parse(
          AppLink.server +
              '/app_students_purchased_from_teacher/${teacher_id.toString()}/${Get.arguments['id'].toString()}',
        ),
      );
      print(
        AppLink.server +
            '/app_students_purchased_from_teacher/${teacher_id.toString()}/${Get.arguments['id'].toString()}',
      );
      if (response.statusCode == 200) {
        isloded.value = true;

        final responseData = jsonDecode(response.body);
        print(responseData);
        dataList.value = responseData['students'];

        print(dataList);
        update();
      } else {
        throw Exception('Failed to load studentLesson');
      }
    } catch (error) {
      print('Error fetching studentLesson: $error');
      // Handle errors appropriately, e.g., show a message to the user
    }
  }

  goToItem(int lessonId) {
    print("sss");
    Get.toNamed(
      '/conatine_lesson',
      arguments: {
        // "lesson_id": subjectId,
        "id": lessonId,
      },
    );
    print("klklklkklkl");
    // dataList.clear();
  }
}
