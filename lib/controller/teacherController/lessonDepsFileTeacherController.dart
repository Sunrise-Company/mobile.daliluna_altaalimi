import 'dart:convert';
import 'package:daliluna_altaalimi/linkapi.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherLessonDepsFileContrlloer extends GetxController {
  RxBool isloded = false.obs;
  RxList<dynamic> dataListfile = <dynamic>[].obs;

  RxList<dynamic> dataListvidoe = <dynamic>[].obs;
  var selectedTabIndex = 0.obs;
  String? name;
  void changeTabIndex(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    name = Get.arguments?['name'];
    getSudenteLesson();
  }

  Future<void> getSudenteLesson() async {
    isloded.value = true; // بدء التحميل
    update();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? teacher_id = prefs.getInt('teacher_id');

      if (teacher_id == null) {
        throw Exception('Teacher ID not found');
      }

      final response = await http.get(
        Uri.parse(
          AppLink.server +
              '/app_teacher_lesson_deps_files/${Get.arguments['leesonID']}',
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response Data: $responseData');
        dataListfile.value = responseData['files'];

        dataListvidoe.value = responseData['videos'];
        isloded.value = false; // انتهاء التحميل
        update();
      } else {
        throw Exception('Failed to load studentLesson: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching studentLesson: $error');
      isloded.value = false; // في حالة الخطأ، توقف التحميل
      update();
      // Handle errors appropriately, e.g., show a message to the user
    }
  }
}
