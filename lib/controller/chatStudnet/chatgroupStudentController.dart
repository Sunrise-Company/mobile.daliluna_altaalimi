import 'dart:developer';
import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
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
  late Sockectcontroller sockectcontroller;
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
    sockectcontroller = Get.find();
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
      log('studenttttttttttttttttttt استلام رسالة جديدة: ${data['msg']}');
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
        // ChatStudentListTeacherController chatStudentListTeacherController =
        //     Get.find();
        // chatStudentListTeacherController.chatStudent();
        messageList.refresh();
        update();
      }
    });
  }

  @override
  void onClose() {
    log('receiverId ${receiverId.value}');
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
    log('chatId.toString()${chatId}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    log(token.toString());
    try {
      final response = await http.post(
        Uri.parse('${AppLink.server}/ReadGroupMessagesForStudent'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'receiver_id': chatId}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        log("تمت قراءة المحادثة بنجاح!");
        ChatStudentListTeacherController chatStudentListTeacherController =
            Get.find();
        chatStudentListTeacherController.chatStudent();
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
    } catch (e) {
      log("ChatGroupMessageStudentController خطأ أثناء تحديث المحادثة: $e");
    }
  }

  void sendMessage({
    String? text,
    File? file,
    required String receiverId,
  }) async {
    if ((text?.trim().isEmpty ?? true) && file == null) return;

    if (!sockectcontroller.isSocketConnected.value) {
      return;
    }
    final url = Uri.parse(AppLink.server + '/message_group');
    String tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    if (file != null)
      messageList.insert(0, {
        'message_id': tempMessageId,
        'msg': text ?? '',
        'sender_id': senderId.toString(),
        'receiver_id': receiverId,
        'created_at': DateTime.now().toIso8601String(),
        // ignore: unnecessary_null_comparison
        'isLoading': file != null,
      });
    update();
    try {
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

      if (text != null && text.trim().isNotEmpty) {
        request.fields['msg'] = text;
      }

      request.fields['receiver_id'] = receiverId;

      if (file != null) {
        String fileType = file.path.split('.').last.toLowerCase();
        request.fields['type'] = fileType;
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String? messageId = responseData['data']['message']['id'].toString();
        List<dynamic> socketIds = responseData['data']['socket_ids'];
        Map<String, dynamic>? fileData =
            responseData['data']['message']['m_file'];
        String? filePath = fileData?['path'];
        String? fileTypeResponse = fileData?['type'];
        if (file == null)
          messageList.insert(0, {
            'message_id': tempMessageId,
            'msg': text ?? '',
            'sender_id': senderId.toString(),
            'receiver_id': receiverId,
            'created_at': DateTime.now().toIso8601String(),
            'isLoading': file != null,
          });

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
        }
        ChatStudentListTeacherController chatStudentListTeacherController =
            Get.find();
        chatStudentListTeacherController.chatStudent();
        if (socketIds.isNotEmpty) {
          sockectcontroller.socket.emit('sendChatToServer', {
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
        }
      } else {
        log(
          'ChatGroupMessageStudentController فشل إرسال الرسالة: ${response.body}',
        );
        messageList.removeWhere((msg) => msg['message_id'] == tempMessageId);
        update();
      }
    } catch (e) {
      log('ChatGroupMessageStudentController خطأ أثناء إرسال الرسالة: $e');

      messageList.removeWhere((msg) => msg['message_id'] == tempMessageId);
      update();
    }
  }

  Future<void> groupsname() async {
    isloded.value = false;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print(token);
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
        print(responseData);
        dataList.value = responseData['data'];

        print(dataList);
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
      print('Error get messages ChatGroupMessageStudentController: $e');
    } finally {
      isloded.value = true;
      isLoadingMore.value = false;
      update();
    }
  }
}
