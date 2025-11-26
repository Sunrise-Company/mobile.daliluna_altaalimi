import 'dart:convert';
import 'dart:developer';
import 'package:daliluna_altaalimi/controller/chatStudnet/chat.dart';
import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/chatTeacherController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/screen/chatstudent/chatStudent.dart';
import 'package:daliluna_altaalimi/view/teacher/chatTeacher/chatTeacher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Sockectcontroller extends GetxController {
  late IO.Socket socket;

  String? socketId;
  RxBool isSocketConnected = false.obs;

  @override
  void onInit() {
    connectToWebSocket();
    super.onInit();
  }

  Future<void> connectToWebSocket() async {
    log('Connecting to WebSocket...');
    socket = IO.io('https://arabicacademic.com', <String, dynamic>{
      'transports': ['websocket'],
      'reconnectionAttempts': 10,
      'reconnectionDelay': 500,
      'reconnectionDelayMax': 5000,
      'autoConnect': true,
    });
    if (socket.connected) {
      saveStudentSocketIdToDatabase(socketId!);
      saveTeacherSocketIdToDatabase(socketId!);
      log('Already connected to WebSocket.');
      return;
    }

    log('Connecting to WebSocket...');
    socket.connect();

    socket.onConnect((_) {
      socketId = socket.id;
      isSocketConnected.value = true;
      log('Connected to WebSocket as user with socket ID: ${socketId}');
      saveStudentSocketIdToDatabase(socketId!);
      saveTeacherSocketIdToDatabase(socketId!);
    });

    Set<int> activeNotifications = {};

    socket.on('sendChatToClient', (data) async {
      log('Socket on  ${data.toString()}');

      int notificationId =
          int.tryParse(data['message_id']) ??
          DateTime.now().millisecondsSinceEpoch ~/ 1000;
      activeNotifications.add(notificationId);
      _showNotification(
        data['sender_name'] ?? "رسالة جديدة",
        data['msg'] == " "
            ? _getFileTypeDescription(data['m_file']['type'])
            : data['msg'],
        data['group_name'] == null ? false : true,
        data['group_name'],
        data['receiver_id'],
        data['receiver_type'],
        data['sender_type'],
        data['message_id'],
        data['sender_id'],
      );

      if (Get.isRegistered<ChatStudentListTeacherController>()) {
        ChatStudentListTeacherController chatStudentListTeacherController =
            Get.find();
        chatStudentListTeacherController.chatStudent();
      }

      if (Get.isRegistered<ListStudentChatController>()) {
        ListStudentChatController listStudentChatController = Get.find();
        listStudentChatController.chatStudent();
      }

      update();
    });
    socket.onDisconnect((_) {
      isSocketConnected.value = false;
      log('Disconnected from WebSocket');
    });
    socket.onConnectError((err) {
      isSocketConnected.value = false;
      log('WebSocket connection error: $err');
    });
    socket.onError((err) {
      isSocketConnected.value = false;
      log('WebSocket error: $err');
    });
  }

  Future<void> saveStudentSocketIdToDatabase(String socketId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      log("tokennnnnnnnn ${token}");
      final response = await http.post(
        Uri.parse(AppLink.server + '/add_to_student'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'socket_id': socketId},
      );
      if (response.statusCode == 200) {
        log('student Socket ID saved successfully');
      } else {
        log('Failed to save student socket ID: ${response.reasonPhrase}');
      }
    } catch (e) {
      log('Error saving  student socket ID: $e');
    }
  }

  Future<void> saveTeacherSocketIdToDatabase(String socketId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('tokenTeacher');
      final response = await http.post(
        Uri.parse(AppLink.server + '/add_to_teacher'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'socket_id': socketId},
      );

      if (response.statusCode == 200) {
        log('teacher Socket ID saved successfully');
      } else {
        log('Failed to save teacher socket ID: ${response.reasonPhrase}');
      }
    } catch (e) {
      log('Error saving teacher socket ID: $e');
    }
  }

  Future<void> _showNotification(
    String senderName,
    String message,
    bool isGroup,
    String? groupName,
    String receiverId,
    String receiverType,
    String senderType,
    String messageId,
    String senderID,
  ) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'chat_channel_id',
          'Chat Notifications',
          channelDescription: 'إشعارات الرسائل الجديدة',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    int notificationId =
        int.tryParse(messageId) ??
        DateTime.now().millisecondsSinceEpoch ~/ 1000;

    String title = isGroup && groupName != null
        ? '$groupName - $senderName'
        : senderName;

    String payload = jsonEncode({
      'receiver_id': receiverId,
      'receiver_type': receiverType,
      'group_name': groupName ?? "",
      'sender_name': senderName,
      'sender_id': senderID,
      'sender_type': senderType,
      'notification_id': notificationId.toString(),
    });

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      message,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void navigateToChatScreen(String payload) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? teacherToken = prefs.getString('tokenTeacher');
    log('token  ${token}');
    log('teacherToken  ${teacherToken}');
    final Map<String, dynamic> data = jsonDecode(payload);
    log('payload ${data.toString()}');
    int? notificationId = int.tryParse(data['notification_id'] ?? '');

    if (notificationId != null) {
      // ignore: unused_local_variable
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      // await flutterLocalNotificationsPlugin.cancel(notificationId);
      log('Notification with ID $notificationId cancelled');
    }

    //notification from Group to student
    if (data['receiver_type'].toString() == "App\\Models\\Room" &&
        token != null) {
      // Get.lazyPut(() => HomePageController());
      Get.put(() => ChatStudentListTeacherController());
      Get.toNamed(
        '/gorupchatStudent',
        arguments: {'idRoom': data['receiver_id'], 'name': data['group_name']},
      );

      // notification from teacher to student
    } else if (data['receiver_type'].toString() == "App\\Models\\App_student" &&
        data['sender_type'] == 'App\\Models\\App_teacher' &&
        token != null) {
      log('notification from teacher to student ${data}');
      Get.to(() {
        final chatController = Get.put(ChatStudentMessageController());
        chatController.receiverId.value = data['sender_id'].toString();
        chatController.studentName.value = data['sender_name'];
        chatController.markChatAsRead(data['sender_id'].toString());
        return ChatStudent();
      });
      //notification from group to teacher
    } else if (data['receiver_type'].toString() == "App\\Models\\Room" &&
        teacherToken != null) {
      // Get.lazyPut(() => HomePageTeacherController());
      log('notification from group to teacher ${data}');
      Get.toNamed(
        '/groupChatTeacher',
        arguments: {
          'name': data['group_name'],
          'idRoom': data['receiver_id'].toString(),
        },
      );

      //notification from student to teacher
    } else if (teacherToken != null &&
        data['receiver_type'].toString() == "App\\Models\\App_teacher" &&
        data['sender_type'] == 'App\\Models\\App_student') {
      log('notification from student to teacher ${data}');

      // final HomeController = Get.put(HomePageTeacherController());
      Get.to(() {
        final chatController = Get.put(ChatTeacherController());
        chatController.receiverId.value = data['sender_id'].toString();
        chatController.name.value = data['sender_name'];
        chatController.markChatAsRead(data['sender_id'].toString());
        return ChatPage();
      });
    }
  }

  String _getFileTypeDescription(String fileType) {
    switch (fileType) {
      case 'jpg':
      case 'png':
      case 'jpeg':
        return "صورة";
      case 'm4a':
        return "تسجيل صوتي";
      case 'mp4':
        return "مقطع فيديو";
      default:
        return "ملف";
    }
  }
}
