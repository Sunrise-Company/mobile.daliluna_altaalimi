// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daliluna_altaalimi/core/services/upload_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatGroupMessageTeacherController extends GetxController {
  var isloded = false.obs;
  RxMap<String, dynamic> dataList = <String, dynamic>{}.obs;

  final ScrollController scrollController = ScrollController();
  final SocketController socketController = Get.find<SocketController>();

  RxList<dynamic> messageList = <dynamic>[].obs;
  RxInt currentPage = 1.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  int? senderId;
  String? token;
  var name = ''.obs;
  var receiverId = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    groupsname();
    name.value = Get.arguments['name'];
    receiverId.value = Get.arguments['idRoom'].toString();
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
    socketController.socket.on('sendChatToClient', (data) {
      log(
        'teacher ChatGroupMessageTeacherController استلام رسالة جديدة: ${data['msg']}',
      );

      bool isDuplicate = messageList.any(
        (msg) => msg['message_id'] == data['message_id'],
      );
      if (isDuplicate) {
        return;
      }
      log(
        '${receiverId.value.toString()} teacher ${data['receiver_id'].toString()}',
      );

      if (receiverId.value.toString() == data['receiver_id'].toString() &&
          data['receiver_type'] == 'App\\Models\\Room') {
        messageList.insert(0, {
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
        if (Get.isRegistered<ListStudentChatController>()) {
          ListStudentChatController chatStudentListTeacherController =
              Get.find();
          chatStudentListTeacherController.chatStudent();
        }
        // messageList.refresh();
        // cancelNotification();
        update();
      }
    });
  }

  Future<void> markChatAsRead(String chatId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenTeacher');

    try {
      final response = await http.post(
        Uri.parse('${AppLink.server}/ReadGroupMessagesForTeacher'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'receiver_id': chatId}),
      );
      if (response.statusCode == 200) {
        if (Get.isRegistered<ListStudentChatController>()) {
          ListStudentChatController chatStudentListTeacherController =
              Get.find();
          chatStudentListTeacherController.chatStudent();
        }

        update();
      } else {}
    } catch (e) {}
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> cancelNotification() async {
    // إلغاء كل الإشعارات المتعلقة بهذه المحادثة
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void sendMessage({
    String? text,
    File? file,
    required String receiverId,
  }) async {
    if ((text?.trim().isEmpty ?? true) && file == null) return;

    String tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    // insert temporary message immediately for better UX
    messageList.insert(0, {
      'message_id': tempMessageId,
      'msg': text ?? '',
      'sender_id': senderId.toString(),
      'receiver_id': receiverId,
      'created_at': DateTime.now().toIso8601String(),
      'isLoading': file != null,
      'uploadProgress': 0.0,
      'm_file': file != null ? {'path': file.path, 'type': 'file'} : null,
    });
    // update();
    try {
      final uploadService = Get.find<UploadService>();
      final fields = <String, String>{'receiver_id': receiverId};
      if (text != null && text.trim().isNotEmpty) {
        fields['msg'] = text;
      }

      final responseData = await uploadService.uploadFile(
        url: AppLink.server + '/message_groupForTeacher',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        fields: fields,
        file: file,
        onProgress: (progress) {
          if (!isClosed) {
            int index = messageList.indexWhere(
              (msg) => msg['message_id'] == tempMessageId,
            );
            if (index != -1) {
              messageList[index]['uploadProgress'] = progress;
              messageList.refresh();
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

      int index = messageList.indexWhere(
        (msg) => msg['message_id'] == tempMessageId,
      );

      if (index != -1) {
        messageList[index] = {
          'msg': text ?? '',
          'message_id': messageId,
          'sender_id': senderId.toString(),
          'receiver_id': Get.arguments['idRoom'].toString(),
          'created_at':
              responseData['data']['message']['created_at'] ??
              DateTime.now().toIso8601String(),
          'm_file': filePath != null
              ? {'path': filePath, 'type': fileTypeResponse}
              : null,
        };
        update();
      } else {
        messageList.insert(0, {
          'message_id': messageId,
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
      if (Get.isRegistered<ListStudentChatController>()) {
        ListStudentChatController listStudentChatController = Get.find();
        try {
          listStudentChatController.chatStudent();
        } catch (e) {}
      }

      if (socketIds.isNotEmpty && socketController.isSocketConnected.value) {
        socketController.socket.emit('sendChatToServer', {
          'msg': text ?? '',
          'message_id': messageId,
          'created_at':
              responseData['data']['message']['created_at'] ??
              DateTime.now().toIso8601String(),
          'sender_name': responseData['data']['message']['sender']['name'],
          'group_name': name.value.toString(),
          'sender_id': senderId.toString(),
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
        messageList.removeWhere((msg) => msg['message_id'] == tempMessageId);
        update();
      }
    }
  }

  Future<void> groupsname() async {
    // isloded.value = false;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('tokenTeacher');
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse(
          AppLink.server +
              '/get_users_forRoom/' +
              Get.arguments['idRoom'].toString(),
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // isloded.value = true;
        final responseData = jsonDecode(response.body);
        dataList.value = responseData['data'];
        update();
      } else {
        throw Exception(
          'Failed to load user list ChatGroupMessageTeacherController',
        );
      }
    } catch (e) {}
  }

  Future<void> GetMessages({bool isLoadMore = false}) async {
    if (isLoadMore && !hasMoreData.value) return;

    if (!isLoadMore) {
      isloded.value = false;
      currentPage.value = 1;
      hasMoreData.value = true;
      messageList.clear();
    } else {
      isLoadingMore.value = true;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('tokenTeacher');

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse(
          "${AppLink.server}/getMessagesForTeacher/${receiverId.value}?page=${currentPage.value}",
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List newData = responseData['data']['data'];
        int perPage = responseData['data']['per_page'];

        if (newData.isNotEmpty) {
          messageList.addAll(newData);
          currentPage.value++;
          hasMoreData.value = newData.length >= perPage;
        } else {
          hasMoreData.value = false;
        }
      } else {
        throw Exception(
          'Failed to load messages ChatGroupMessageTeacherController',
        );
      }
    } catch (e) {
    } finally {
      isloded.value = true;
      isLoadingMore.value = false;
      update();
    }
  }

  @override
  void onClose() {
    markChatAsRead(receiverId.toString());
    super.onClose();
  }
}
