import 'dart:convert';
import 'dart:developer';

import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatStudentListTeacherController extends GetxController {
  RxList<dynamic> dataList = <dynamic>[].obs;
  RxList<dynamic> roomlist = <dynamic>[].obs;
  late SocketController socketController;
  // ChatGroupMessageStudentController chatGroupMessageStudentController =
  // ChatGroupMessageStudentController();
  var isloded = false.obs;
  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    socketController = Get.find<SocketController>();
    // chatGroupMessageStudentController =
    // Get.lazyPut(() => ChatGroupMessageStudentController());
    if (prefs.getBool('isLogin') == false) {
      isloded.value = true;
      roomlist.value = [];
      dataList.value = [];
      return;
    }
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
    update();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (token != null) {
        log("token: $token");
      } else {
        log("token is null");
      }
      log("${AppLink.server + '/getListUsersStudent'}");

      final response = await http.get(
        Uri.parse(AppLink.server + '/getListUsersStudent'),
        headers: headers,
      );
      log("getListUsersStudent ${jsonDecode(response.body)}");

      if (token == null) {
        isloded.value = true;
        dataList.value = [];
      }

      if (response.statusCode == 200) {
        isloded.value = true;
        final responseData = jsonDecode(response.body);

        dataList.value = responseData['data']['users'];
        roomlist.value = responseData['data']['rooms'];

        update();
      } else {
        throw Exception('Failed to load getListUsersStudent List ');
      }
    } catch (e) {}
  }
}
