import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  late TextEditingController username;

  late TextEditingController password;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  String? id;
  getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    id = androidInfo.id; // Corrected line
    update();
    log('Device ID: ${id}');
  }

  bool isshowpassword = true;

  checkIfLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogin') == true) {
      isLoginsuccess = true.obs;
      isLoginsuccess(true);
    } else {
      isLoginsuccess = false.obs;
      isLoginsuccess(false);
    }
    return isLoginsuccess;
  }

  showPassword() {
    isshowpassword = isshowpassword == true ? false : true;
    update();
  }

  Map<String, String> data = Map();
  getdata() {
    data = {
      "username": username.text,
      "password": password.text,
      "device_id": id.toString(),
    };
    print(id.toString());
  }

  bool load = false;
  RxBool isLoginsuccess = false.obs;
  RxString message = ''.obs;
  login() async {
    load = true;
    await getDeviceDetails();
    await getdata();
    String responseData = await ApiService.loginStudent(data);
    print('------------------');
    print(responseData);

    print('------------------');
    load = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isLogin') == true) {
      Get.offAllNamed('/homepage');
    }
    update();
    prefs.getBool('isLogin') == 'false'
        ? isLoginsuccess(false)
        : isLoginsuccess(true);

    checkIfLogin();
    print("${responseData}xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    message(responseData.toString());

    update();
    print(responseData);
    print(isLoginsuccess);
  }

  updateisLoginsuccess() {
    print('3333333333333333333');
    isLoginsuccess(true);
    update();
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isLogin', false);
    isLoginsuccess(false);
    isLoginsuccess = false.obs;

    isLoginsuccess(false);
    checkIfLogin();
    prefs.remove('token');
    prefs.remove('student_id');

    prefs.remove('arabic_name');
    update();

    Get.offAllNamed(AppRoute.homePage);
  }

  @override
  void onInit() {
    username = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }
}
