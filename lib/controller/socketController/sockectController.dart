import 'dart:convert';
import 'dart:developer';
import 'package:daliluna_altaalimi/controller/chatStudnet/chat.dart';
import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/chatTeacherController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/screen/chatstudent/chatStudent.dart';
import 'package:daliluna_altaalimi/view/teacher/chatTeacher/chatTeacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:daliluna_altaalimi/core/services/notification_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:daliluna_altaalimi/core/constant/color.dart';

class SocketController extends GetxController {
  late IO.Socket socket;

  String? socketId;
  RxBool isSocketConnected = false.obs;

  @override
  void onInit() {
    connectToWebSocket();
    super.onInit();
  }

  Future<void> connectToWebSocket() async {
    log("Socket: Initializing connection to ${AppLink.baseUrl}");
    
    socket = IO.io('${AppLink.baseUrl}', <String, dynamic>{
      'transports': ['websocket', 'polling'], // Added polling as a fallback
      'reconnectionAttempts': 20, // Increased attempts
      'reconnectionDelay': 1000,
      'reconnectionDelayMax': 10000,
      'autoConnect': true,
      'forceNew': false,
    });

    socket.onConnect((_) {
      socketId = socket.id;
      isSocketConnected.value = true;
      log("Socket Connected Successfully. ID: $socketId");
      
      if (socketId != null) {
        saveStudentSocketIdToDatabase(socketId!);
        saveTeacherSocketIdToDatabase(socketId!);
      }
    });

    socket.onReconnect((_) {
      log("Socket Reconnected");
      isSocketConnected.value = true;
      socketId = socket.id;
      if (socketId != null) {
        saveStudentSocketIdToDatabase(socketId!);
        saveTeacherSocketIdToDatabase(socketId!);
      }
    });

    socket.onReconnectAttempt((attempt) {
      log("Socket Reconnecting... Attempt: $attempt");
    });

    Set<int> activeNotifications = {};

    socket.on('sendChatToClient', (data) async {
      log("Socket: Received 'sendChatToClient': $data");

      int notificationId =
          int.tryParse(data['message_id']) ??
          DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Prevent duplicate notifications for same message
      if (activeNotifications.contains(notificationId)) {
        log("Socket: Skipping duplicate notification $notificationId");
        return;
      }

      activeNotifications.add(notificationId);

      // Check if app is in foreground
      final isInForeground =
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

      try {
        if (isInForeground) {
          // App is active - show in-app notification with navigation
          log("Socket: App in foreground, showing in-app notification");
          _showInAppChatNotification(
            data['sender_name'] ?? "رسالة جديدة",
            data['msg'] == " "
                ? _getFileTypeDescription(data['m_file']['type'])
                : data['msg'],
            data['receiver_id'],
            data['receiver_type'],
            data['group_name'],
            data['sender_id'],
            data['sender_type'],
            data['message_id'],
          );
        } else {
          // App is in background - show system notification
          log(
            "Socket: App in background, showing system notification for $notificationId",
          );
          await _showNotification(
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
        }
      } catch (e) {
        log("Socket: Error showing notification: $e");
      }

      if (Get.isRegistered<ChatStudentListTeacherController>()) {
        try {
          ChatStudentListTeacherController chatStudentListTeacherController =
              Get.find();
          chatStudentListTeacherController.chatStudent();
        } catch (e) {
          log("Socket: Error updating ChatStudentListTeacherController: $e");
        }
      }

      if (Get.isRegistered<ListStudentChatController>()) {
        try {
          ListStudentChatController listStudentChatController = Get.find();
          listStudentChatController.chatStudent();
        } catch (e) {
          log("Socket: Error updating ListStudentChatController: $e");
        }
      }

      update();
    });
    socket.onDisconnect((_) {
      isSocketConnected.value = false;
      log("Socket Disconnected");
    });
    socket.onConnectError((err) {
      isSocketConnected.value = false;
      log("Socket Connect Error: $err");
    });
    socket.onError((err) {
      isSocketConnected.value = false;
      log("Socket Error: $err");
    });
  }

  Future<void> saveStudentSocketIdToDatabase(String socketId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(AppLink.server + '/add_to_student'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'socket_id': socketId},
      );
      if (response.statusCode == 200) {
        log("Socket: Saved Teacher Socket ID");
      } else {
        log(
          "Socket: Failed to save Teacher Socket ID: ${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      log("Socket: Error saving Teacher Socket ID: $e");
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
        log("Socket: Saved Teacher Socket ID");
      } else {
        log(
          "Socket: Failed to save Teacher Socket ID: ${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      log("Socket: Error saving Teacher Socket ID: $e");
    }
  }

  // Show in-app notification when app is in foreground
  void _showInAppChatNotification(
    String senderName,
    String message,
    String receiverId,
    String receiverType,
    String? groupName,
    String senderId,
    String senderType,
    String messageId,
  ) {
    log("Socket: Showing in-app notification dialog");

    Get.snackbar(
      senderName,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColor.PrimaryColor,
      colorText: AppColor.White,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(15),
      borderRadius: 15,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(0, 3),
        ),
      ],
      icon: const Icon(
        Icons.notifications_active,
        color: AppColor.SecondryColor,
        size: 30,
      ),
      shouldIconPulse: true,
      onTap: (_) {
        // Navigate to chat when tapped
        String payload = jsonEncode({
          'receiver_id': receiverId,
          'receiver_type': receiverType,
          'group_name': groupName ?? "",
          'sender_name': senderName,
          'sender_id': senderId,
          'sender_type': senderType,
          'notification_id': messageId,
        });
        navigateToChatScreen(payload);
      },
      mainButton: TextButton(
        onPressed: () {
          String payload = jsonEncode({
            'receiver_id': receiverId,
            'receiver_type': receiverType,
            'group_name': groupName ?? "",
            'sender_name': senderName,
            'sender_id': senderId,
            'sender_type': senderType,
            'notification_id': messageId,
          });
          navigateToChatScreen(payload);
          Get.closeCurrentSnackbar();
        },
        child: const Text(
          'فتح',
          style: TextStyle(
            color: AppColor.SecondryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
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
    // Global flutterLocalNotificationsPlugin used
    // Use NotificationHelper's static instance
    final flutterLocalNotificationsPlugin =
        NotificationHelper.flutterLocalNotificationsPlugin;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'chat_channel_id',
          'Chat Notifications',
          channelDescription: 'إشعارات الرسائل الجديدة',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          autoCancel: true,
          ongoing: false,
          // These settings ensure the notification is interactive
          category: AndroidNotificationCategory.message,
          visibility: NotificationVisibility.public,
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

    log("Socket: About to show notification with ID: $notificationId");
    log("Socket: Notification payload: $payload");

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      message,
      platformChannelSpecifics,
      payload: payload,
    );

    log("Socket: Notification shown successfully with ID: $notificationId");
  }

  void navigateToChatScreen(String payload) async {
    log("Socket: Navigating with payload: $payload");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? teacherToken = prefs.getString('tokenTeacher');

    final Map<String, dynamic> data = jsonDecode(payload);

    int? notificationId = int.tryParse(data['notification_id'] ?? '');

    if (notificationId != null) {
      try {
        await NotificationHelper.flutterLocalNotificationsPlugin.cancel(
          notificationId,
        );
      } catch (e) {
        log("Socket: Error canceling notification: $e");
      }
    }

    //notification from Group to student
    if (data['receiver_type'].toString() == "App\\Models\\Room" &&
        token != null) {
      log("Socket: Navigating to Group Chat Student");
      Get.put(ChatStudentListTeacherController());
      Get.toNamed(
        '/gorupchatStudent',
        arguments: {
          'idRoom': data['receiver_id'].toString(),
          'name': data['group_name'],
        },
      );

      // notification from teacher to student
    } else if (data['receiver_type'].toString() == "App\\Models\\App_student" &&
        data['sender_type'] == 'App\\Models\\App_teacher' &&
        token != null) {
      log("Socket: Navigating to Chat Student (Teacher -> Student)");
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
      log("Socket: Navigating to Group Chat Teacher");

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
      log("Socket: Navigating to Chat Teacher (Student -> Teacher)");
      Get.to(() {
        final chatController = Get.put(ChatTeacherController());
        chatController.receiverId.value = data['sender_id'].toString();
        chatController.name.value = data['sender_name'];
        chatController.markChatAsRead(data['sender_id'].toString());
        return ChatPage();
      });
    } else {
      log("Socket: No matching navigation path found for payload.");
    }
  }

  Future<void> disconnectSocket() async {
    try {
      log("Socket: Disconnecting socket on logout...");
      
      // Attempt to clear socket ID on server before disconnecting
      if (socket.connected && socket.id != null) {
        // Send empty string to clear the socket id in the database
        await saveStudentSocketIdToDatabase("");
        await saveTeacherSocketIdToDatabase("");
      }
      
      socket.disconnect();
      isSocketConnected.value = false;
      socketId = null;
      log("Socket: Disconnected and cleared.");
    } catch (e) {
      log("Socket: Error during disconnect: $e");
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
