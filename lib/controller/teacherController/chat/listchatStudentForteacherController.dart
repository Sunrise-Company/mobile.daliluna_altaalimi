import 'dart:convert';
import 'dart:developer';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListStudentChatController extends GetxController {
  RxList<dynamic> dataList = <dynamic>[].obs;
  RxList<dynamic> roomlist = <dynamic>[].obs;

  var isloded = false.obs;
  @override
  void onInit() async {
    chatStudent();
    super.onInit();
  }

  Future<void> cancelAllNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> chatStudent() async {
    isloded.value = false;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('tokenTeacher');

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse(AppLink.server + '/getListUsersTeacher'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        isloded.value = true;
        final responseData = jsonDecode(response.body);

        dataList.value = responseData['data']['users'];
        roomlist.value = responseData['data']['rooms'];

        update();
      } else {
        throw Exception('Failed to load getListUsersTeacher List ');
      }
    } catch (e) {}
  }
}
