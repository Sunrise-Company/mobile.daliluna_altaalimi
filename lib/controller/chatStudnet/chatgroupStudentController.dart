import 'dart:developer';
import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daliluna_altaalimi/core/services/upload_service.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class ChatGroupMessageStudentController extends GetxController {
  var isloded = false.obs;
  TextEditingController messageController = TextEditingController();
  RxMap<String, dynamic> dataList = <String, dynamic>{}.obs;
  final messages = <Map<String, dynamic>>[].obs;
  var receiverId = ''.obs;
  Stream<dynamic>? messageStream;
  RxList<dynamic> messageList = <dynamic>[].obs;
  var name = ''.obs;
  final ScrollController scrollController = ScrollController();
  late SocketController socketController;
  RxInt currentPage = 1.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  String? senderId;
  String? token;
  @override
  void onInit() async {
    super.onInit();
    groupsname();
    name.value = Get.arguments['name'];
    receiverId.value = Get.arguments['idRoom'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderId = prefs.getString('student_id');
    token = prefs.getString('token');
    socketController = Get.find<SocketController>();
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
      bool isDuplicate = messageList.any(
        (msg) => msg['message_id'] == data['message_id'],
      );
      if (isDuplicate) return;
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

        if (Get.isRegistered<ChatStudentListTeacherController>()) {
          ChatStudentListTeacherController chatStudentListTeacherController =
              Get.find();
          chatStudentListTeacherController.chatStudent();
        }
        messageList.refresh();
        update();
      }
    });
  }

  @override
  void onClose() {
    markChatAsRead(receiverId.toString());
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderId = prefs.getString('student_id');
    token = prefs.getString('token');
  }

  Future<void> markChatAsRead(String chatId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('${AppLink.server}/ReadGroupMessagesForStudent'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'receiver_id': chatId}),
      );

      if (response.statusCode == 200) {
        if (Get.isRegistered<ChatStudentListTeacherController>()) {
          ChatStudentListTeacherController chatStudentListTeacherController =
              Get.find();
          chatStudentListTeacherController.chatStudent();
        }
        // GetMessages();
        update();
      } else {
        log(
          " ChatGroupMessageStudentController فشل في تحديث حالة المحادثة: ${response.reasonPhrase}",
        );
        log(
          " ChatGroupMessageStudentController فشل في تحديث حالة المحادثة: ${response.body}",
        );
      }
    } catch (e) {}
  }

  void sendMessage({
    String? text,
    File? file,
    required String receiverId,
  }) async {
    if ((text?.trim().isEmpty ?? true) && file == null) return;

    final url = Uri.parse(AppLink.server + '/message_group');
    String tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    

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
    update();
    try {
      final uploadService = Get.find<UploadService>();
      final fields = <String, String>{'receiver_id': receiverId};
      if (text != null && text.trim().isNotEmpty) {
        fields['msg'] = text;
      }

      final responseData = await uploadService.uploadFile(
        url: AppLink.server + '/message_group',
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
          'receiver_id': receiverId,
          'created_at':
              responseData['data']['message']['created_at'] ??
              DateTime.now().toIso8601String(),
          'm_file': filePath != null
              ? {'path': filePath, 'type': fileTypeResponse}
              : null,
        };
        update();
      } else {
        // Fallback: Insert if message wasn't found in list
        messageList.insert(0, {
          'message_id': messageId,
          'msg': text ?? '',
          'sender_id': senderId.toString(),
          'receiver_id': receiverId,
          'created_at': DateTime.now().toIso8601String(),
          'm_file': filePath != null
              ? {'path': filePath, 'type': fileTypeResponse}
              : null,
          'isLoading': file != null,
        });
      }

      if (Get.isRegistered<ChatStudentListTeacherController>()) {
        try {
          ChatStudentListTeacherController chatStudentListTeacherController =
              Get.find();
          chatStudentListTeacherController.chatStudent();
        } catch (e) {}
      }

      if (socketIds.isNotEmpty && socketController.isSocketConnected.value) {
        log(
          "Group Chat: Emitting sendChatToServer to ${socketIds.length} sockets",
        );
        socketController.socket.emit('sendChatToServer', {
          'msg': text ?? '',
          'message_id': messageId,
          'created_at':
              responseData['data']['message']['created_at'] ??
              DateTime.now().toIso8601String(),
          'sender_name':
              responseData['data']['message']['sender']['arabic_name'],
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
      } else {
        log(
          "Group Chat: assert failed - socketIds: ${socketIds.length}, connected: ${socketController.isSocketConnected.value}",
        );
      }
    } catch (e) {
      log("Error in Group sendMessage: $e");
      if (!isClosed) {
        messageList.removeWhere((msg) => msg['message_id'] == tempMessageId);
        update();
      }
    }
  }

  Future<void> groupsname() async {
    isloded.value = false;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse(AppLink.server + '/get_users_forRoom/' + receiverId.value),
        headers: headers,
      );

      if (response.statusCode == 200) {
        isloded.value = true;
        final responseData = jsonDecode(response.body);

        dataList.value = responseData['data'];

        update();
      } else {
        throw Exception(
          'Failed to load groupsname for ChatGroupMessageStudentController ',
        );
      }
    } catch (e) {
      print(
        'Error fetching groupsname for ChatGroupMessageStudentController : $e',
      );
    }
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
      senderId = prefs.getString('student_id');
      token = prefs.getString('token');
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse(
          "${AppLink.server}/getMessagesForStudent/${receiverId.value}?page=${currentPage.value}",
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
          'Failed to get messages ChatGroupMessageStudentController',
        );
      }
    } catch (e) {
    } finally {
      isloded.value = true;
      isLoadingMore.value = false;
      update();
    }
  }
}
