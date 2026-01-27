// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appteahcerlessonController.dart';

class LoginControllerss extends GetxController {
  TextEditingController emailcontrooelr = TextEditingController();
  TextEditingController passwordcontroler = TextEditingController();
  RxBool isLoggedIn = false.obs;
  RxBool isLoggedInTeacher = false.obs;

  var isSendingdata = false.obs;
  RxString studentname = "".obs;
  RxString groubname = "".obs;
  RxInt studentId = RxInt(0);
  RxInt teacherId = RxInt(0);
  RxBool isPasswordVisible = false.obs;

  bool isshowpassword = true;
  GlobalKey<FormState> formstateteacher = GlobalKey<FormState>();
  RxBool load = false.obs;

  showPassword() {
    isshowpassword = isshowpassword == true ? false : true;
    update();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  final email = ''.obs;
  final password = ''.obs;
  final rememberMe = false.obs;
  void setEmail(String value) {
    email.value = value;
  }

  @override
  void onInit() {
    super.onInit();

    checkLoginStatusTeacher();
  }

  // void login() async {
  //   load.value = true;

  //   final response = await http.post(
  //     Uri.parse(AppLink.server + '/app_teacher_login'),
  //     body: {
  //       'username': emailcontrooelr.text,
  //       'password': passwordcontroler.text,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final responseData = response.body;
  //     final data = jsonDecode(responseData);
  //     print(data['status']);

  //     isLoggedInTeacher.value = true;

  //     print("teachher");
  //     final teacherId = data['teacer_id'];
  //     final arabic_name = data['arabic_name'];

  //     final image = data['app_teacher']['image'] ?? '';

  //     final education = data['app_teacher']['education'] ?? "";
  //     final phone = data['app_teacher']['phone'] ?? "";
  //     final description = data['app_teacher']['description'] ?? '';
  //     final token = data['token'];
  //     print(teacherId);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setInt('teacher_id', teacherId);
  //     prefs.setString('arabic_name', arabic_name);

  //     prefs.setString('education', education);
  //     prefs.setString('image', image);
  //     prefs.setString('description', description);
  //     this.teacherId.value = teacherId;
  //     prefs.setString('tokenTeacher', token);
  //     print(token);
  //     TeacherLessonContrlloer lessonContrlloer =
  //         Get.put(TeacherLessonContrlloer());

  //     lessonContrlloer.dataList.value = [];
  //     lessonContrlloer.isloded.value = false;
  //     lessonContrlloer.onInit();
  //     lessonContrlloer.getSudenteLesson();
  //     load.value = false;
  //     Sockectcontroller socket = Get.find();
  //     socket.connectToWebSocket();
  //     Get.toNamed('/homepageTeacher');
  //     update();
  //   } else {}
  // }
  void login() async {
    load.value = true;
    update();

    try {
      final response = await http.post(
        Uri.parse(AppLink.server + '/app_teacher_login'),
        body: {
          'username': emailcontrooelr.text,
          'password': passwordcontroler.text,
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        isLoggedInTeacher.value = true;
        final teacherId = data['teacer_id'];
        final arabic_name = data['arabic_name'];
        final image = data['app_teacher']['image'] ?? '';
        final education = data['app_teacher']['education'] ?? "";
        // ignore: unused_local_variable
        final phone = data['app_teacher']['phone'] ?? "";
        final description = data['app_teacher']['description'] ?? '';
        final token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('teacher_id', teacherId);
        prefs.setString('arabic_name', arabic_name);
        prefs.setString('education', education);
        prefs.setString('image', image);
        prefs.setString('description', description);
        prefs.setString('tokenTeacher', token);

        this.teacherId.value = teacherId;
        TeacherLessonContrlloer lessonContrlloer = Get.put(
          TeacherLessonContrlloer(),
        );
        lessonContrlloer.dataList.value = [];
        lessonContrlloer.isloded.value = false;
        lessonContrlloer.getSudenteLesson();
        Get.offAllNamed('/homepageTeacher');
      } else {
        Get.snackbar(
          "خطأ في تسجيل الدخول",
          data['message'] ?? "تحقق من اسم المستخدم وكلمة المرور.",
          // backgroundColor: Colors.red,
          // colorText: Colors.white,
          dismissDirection: DismissDirection.startToEnd,
          // duration: Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ في تسجيل الدخول",
        "تحقق من اسم المستخدم وكلمة المرور.",
        // backgroundColor: Colors.red,
        // colorText: Colors.white,
        dismissDirection: DismissDirection.startToEnd,
        // duration: Duration(minutes: 10),
      );
    } finally {
      load.value = false;
      update();
    }
  }

  void checkLoginStatusTeacher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    teacherId.value = prefs.getInt('teacher_id')??0;
    isLoggedInTeacher.value = teacherId != null;
  }

  void logoutTeacher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('teacher_id');
    prefs.remove('tokenTeacher');
    isLoggedIn.value = false;

    Get.toNamed("/homepage");
  }
}
