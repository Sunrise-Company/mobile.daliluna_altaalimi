import 'dart:convert';
import 'dart:developer';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

class checkPolicyController extends GetxController {
  var check = false.obs;
  var oldnum = 0.toString().obs;
  var newnum = 0.toString().obs;
  var isAuth = false.obs;
  var isConnection = true.obs;
  var isPolicy = 0.obs;
  @override
  void onInit() {
    Get.closeCurrentSnackbar();
    getNewVersionnum();
    getOldVersionnum();
    super.onInit();
  }

  checkVersionnum() {
    print("--------------------jjj------------------");
    print(oldnum == newnum);
    print(oldnum);
    print(newnum);
    if (oldnum == newnum) {
      print('yyyyyyyyyy');
      Get.toNamed('/checkPolicy');
    } else {
      print('xxxxxxxxxxxx');
      Get.toNamed('/updateApp');
    }
  }

  getOldVersionnum() async {
    try {
      var response;
      response = await http.get(Uri.parse('${AppLink.server}/app_version_num'));
      var body = json.decode(response.body);
      log('==============');
      print(body['version_num']);
      oldnum(body['version_num']);
      checkVersionnum();
    } catch (e) {
      isConnection(false);
      Get.snackbar(
        'تنبيه',
        "لا يوجد اتصال بالانترنت",
        dismissDirection: DismissDirection.startToEnd,
        duration: Duration(minutes: 10),
        mainButton: TextButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
            getOldVersionnum();
            checkVersionnum();
          },
          child: Text('إعادة', style: TextStyle(color: Colors.red)),
        ),
      );
    }
  }

  late double currentVersion = 0;
  getNewVersionnum() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
    print('--------------');
    print(currentVersion);
    newnum(currentVersion.toString());
  }
}
