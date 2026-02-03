import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daliluna_altaalimi/core/services/upload_service.dart';
import 'package:http/http.dart' as http;

class ChatTeacherController extends GetxController {
  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final Sockectcontroller sockectcontroller = Get.find();
  RxList<dynamic> dataList = <dynamic>[].obs;
  RxList<dynamic> roomlist = <dynamic>[].obs;
  var isloded = false.obs;
  int? senderId;
  String? token;
  var receiverId = ''.obs;
  var name = ''.obs;
  void onInit() async {
    super.onInit();
    // receiverId.value = Get.arguments?['id']?.toString() ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderId = prefs.getInt('teacher_id');
    token = prefs.getString('tokenTeacher');
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore.value &&
          hasMoreData.value) {
        GetMessages(isLoadMore: true);
      }
    });
    GetMessages();
    sockectcontroller.socket.on('sendChatToClient', (data) {
      bool isDuplicate = dataList.any(
        (msg) => msg['message_id'] == data['message_id'],
      );
      if (isDuplicate) {
        return;
      }
      log(
        '${senderId.toString()} chatteacher controller  ${data['receiver_id'].toString()}',
      );
      if (receiverId.value.toString() == data['sender_id'].toString() &&
          // if (senderId.toString() == data['receiver_id'].toString() &&
          data['receiver_type'] == 'App\\Models\\App_teacher') {
        dataList.insert(0, {
          'msg': data['msg'] ?? "",
          'message_id': data['message_id'],
          'sender_name': data['sender_name'],
          'sender_id': data['sender_id'],
          'receiver_id': data['receiver_id'],
          'created_at': data['created_at'] ?? DateTime.now().toIso8601String(),
          'm_file': data['m_file'] != null
              ? {'path': data['m_file']['path'], 'type': data['m_file']['type']}
              : null,
        });

        ListStudentChatController chatStudentListTeacherController = Get.find();
        chatStudentListTeacherController.chatStudent();
        // GetMessages();
        dataList.refresh();
        update();
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderId = prefs.getInt('teacher_id');
    token = prefs.getString('tokenTeacher');
    // GetMessages();
  }

  RxInt currentPage = 1.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;

  Future<void> markChatAsRead(String chatId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenTeacher');

    try {
      final response = await http.patch(
        Uri.parse('${AppLink.server}/private_teacher/read/$chatId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ListStudentChatController listStudentChatController = Get.find();
        listStudentChatController.chatStudent();
        // GetMessages();
        update();
      } else {}
    } catch (e) {}
  }

  @override
  void onClose() {
    markChatAsRead(receiverId.value.toString());
    super.onClose();
  }

  Future<void> GetMessages({bool isLoadMore = false}) async {
    if (isLoadMore && !hasMoreData.value) return;
    if (!isLoadMore) {
      isloded.value = false;
      currentPage.value = 1;
      hasMoreData.value = true;
      dataList.clear();
    } else {
      isLoadingMore.value = true;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      senderId = prefs.getInt('teacher_id');
      token = prefs.getString('tokenTeacher');
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse(
          "${AppLink.server}/getMessagesTeacher/${receiverId}?page=${currentPage.value}",
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List newData = responseData['data']['data'];
        int perPage = responseData['data']['per_page'];

        if (newData.isNotEmpty) {
          dataList.addAll(newData);
          currentPage.value++;
          hasMoreData.value = newData.length >= perPage;
        } else {
          hasMoreData.value = false;
        }
      } else {
        throw Exception('Failed to load messages chatteacherController');
      }
    } catch (e) {
    } finally {
      isloded.value = true;
      isLoadingMore.value = false;
      update();
    }
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> cancelAllNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void sendMessage({
    String? text,
    File? file,
    required String receiverId,
  }) async {
    if ((text?.trim().isEmpty ?? true) && file == null) return;

    String tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    // insert temporary message immediately for better UX
    dataList.insert(0, {
      'message_id': tempMessageId,
      'is_read': 0,
      'msg': text ?? '',
      'sender_id': senderId.toString(),
      'receiver_id': receiverId,
      'created_at': DateTime.now().toIso8601String(),
      'isLoading': file != null,
      'uploadProgress': 0.0,
      'm_file': file != null ? {'path': file.path, 'type': 'file'} : null,
    });
    update();

    try {
      final uploadService = Get.find<UploadService>();
      final fields = <String, String>{'receiver_id': receiverId};
      if (text != null && text.trim().isNotEmpty) {
        fields['msg'] = text;
      }

      final responseData = await uploadService.uploadFile(
        url: AppLink.server + '/message_teacher_chat',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        fields: fields,
        file: file,
        onProgress: (progress) {
          if (!isClosed) {
            int index = dataList.indexWhere(
              (msg) => msg['message_id'] == tempMessageId,
            );
            if (index != -1) {
              dataList[index]['uploadProgress'] = progress;
              dataList.refresh();
              update();
            }
          }
        },
      );

      if (isClosed) return;

      String? messageId = responseData['data']['message']['id'].toString();
      List<dynamic> socketIds = responseData['data']['socket_ids'];
      Map<String, dynamic>? fileData =
          responseData['data']['message']['m_file'];
      String? filePath = fileData?['path'];
      String? fileTypeResponse = fileData?['type'];

      int index = dataList.indexWhere(
        (msg) => msg['message_id'] == tempMessageId,
      );

      if (index != -1) {
        dataList[index] = {
          'msg': text ?? '',
          'message_id': messageId,
          'sender_id': senderId.toString(),
          'receiver_id': receiverId,
          'is_read': 0,
          'created_at':
              responseData['data']['message']['created_at'] ??
              DateTime.now().toIso8601String(),
          'm_file': filePath != null
              ? {'path': filePath, 'type': fileTypeResponse}
              : null,
        };
        update();
      } else {
        dataList.insert(0, {
          'message_id': messageId,
          'is_read': 0,
          'msg': text ?? '',
          'sender_id': senderId.toString(),
          'receiver_id': receiverId,
          'created_at': DateTime.now().toIso8601String(),
          'isLoading': file != null,
          'm_file': filePath != null
              ? {'path': filePath, 'type': fileTypeResponse}
              : null,
        });
      }

      ListStudentChatController listStudentChatController = Get.find();
      try {
        listStudentChatController.chatStudent();
      } catch (e) {}

      update();
      if (socketIds.isNotEmpty && sockectcontroller.isSocketConnected.value) {
        sockectcontroller.socket.emit('sendChatToServer', {
          'msg': text ?? '',
          'message_id': messageId,
          'created_at':
              responseData['data']['message']['created_at'] ??
              DateTime.now().toIso8601String(),
          'sender_name': responseData['data']['message']['sender']['name'],
          'sender_id': senderId.toString(),
          'is_read': responseData['data']['message']['is_read'] ?? "",
          'sender_type': responseData['data']['message']['sender_type'],
          'receiver_id': receiverId,
          'receiver_type': responseData['data']['message']['receiver_type'],
          'receiver_socket_id': socketIds,
          'm_file': filePath != null
              ? {'path': filePath, 'type': fileTypeResponse}
              : null,
        });
      }
    } catch (e) {
      if (!isClosed) {
        dataList.removeWhere((msg) => msg['message_id'] == tempMessageId);
        update();
      }
    }
  }
}
