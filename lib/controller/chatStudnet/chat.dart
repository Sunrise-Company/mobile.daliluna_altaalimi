import 'dart:developer';

import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatStudentMessageController extends GetxController {
  final recorder = AudioRecorder();
  final audioPlayer = AudioPlayer();
  RxBool isRecording = false.obs;
  RxString recordingPath = ''.obs;
  PlatformFile? pickfile;
  var isloded = false.obs;
  RxString message = ''.obs;
  Duration recordingDuration = Duration.zero;
  DateTime? _startTime;
  RxString currentDuration = '00:00'.obs;
  TextEditingController messageController = TextEditingController();
  RxList<dynamic> dataList = <dynamic>[].obs;
  String? studentId;
  Stream<dynamic>? messageStream;
  final ScrollController scrollController = ScrollController();
  final Sockectcontroller sockectcontroller = Get.find();
  RxInt currentPage = 1.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  var isLoadingFile = false.obs;
  var receiverId = "".obs;
  var studentName = ''.obs;
  String? senderId;
  String? token;
  var chatId = "".obs;
  @override
  void onInit() async {
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderId = prefs.getString('student_id');
    token = prefs.getString('token');
    log('senderid ${senderId}');
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
      log('student استلام رسالة جديدة: ${data.toString()}');
      bool isDuplicate = dataList.any(
        (msg) => msg['message_id'] == data['message_id'],
      );
      if (isDuplicate) {
        return;
      }
      //log('rrrrreceiverId ${receiverId.value}  data[receiver_id] ${data['sender_id']}');
      if (receiverId.value.toString() == data['sender_id'].toString() &&
          data['receiver_type'] == 'App\\Models\\App_student') {
        dataList.insert(0, {
          'msg': data['msg'] ?? " ",
          'message_id': data['message_id'],
          'sender_name': data['sender_name'],
          'sender_id': data['sender_id'],
          'is_read': 0,
          'receiver_id': data['receiver_id'],
          'created_at': data['created_at'] ?? DateTime.now().toIso8601String(),
          'm_file': data['m_file'] != null
              ? {'path': data['m_file']['path'], 'type': data['m_file']['type']}
              : null,
        });
        ChatStudentListTeacherController chatStudentListTeacherController =
            Get.find();
        chatStudentListTeacherController.chatStudent();
        dataList.refresh();
        update();
      }
    });
  }

  Future<void> cancelAllNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
    log('All notifications cancelled');
  }

  Future<void> markChatAsRead(String chatId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.patch(
        Uri.parse('${AppLink.server}/private_student/read/$chatId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print("ChatStudentMessageController تمت قراءة المحادثة بنجاح!");
        ChatStudentListTeacherController chatStudentListTeacherController =
            Get.find();
        chatStudentListTeacherController.chatStudent();

        update();
      } else {
        print(
          "ChatStudentMessageController فشل في تحديث حالة المحادثة: ${response.body}",
        );
      }
    } catch (e) {
      print("ChatStudentMessageController خطأ أثناء تحديث المحادثة: $e");
    }
  }

  @override
  void onReady() {
    // receiverId.value = Get.arguments['id'];
    super.onReady();
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
      senderId = prefs.getString('student_id');
      token = prefs.getString('token');
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      log('${receiverId}');
      final response = await http.get(
        Uri.parse(
          "${AppLink.server}/getMessagesStudent/${receiverId}?page=${currentPage.value}",
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        log('response.body ${response.body}');
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
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      isloded.value = true;
      isLoadingMore.value = false;
      update();
    }
  }

  void sendMessage({
    String? text,
    File? file,
    required String receiverId,
  }) async {
    if ((text?.trim().isEmpty ?? true) && file == null) return;
    log('send ${receiverId}');
    if (!sockectcontroller.isSocketConnected.value) {
      return;
    }

    final url = Uri.parse(AppLink.server + '/message_student_chat');
    String tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    if (file != null)
      dataList.insert(0, {
        'message_id': tempMessageId,
        'msg': text ?? '',
        'sender_id': senderId.toString(),
        'receiver_id': receiverId,
        'created_at': DateTime.now().toIso8601String(),
        // ignore: unnecessary_null_comparison
        'isLoading': file != null,
        'is_read': 0,
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
        int index = dataList.indexWhere(
          (msg) => msg['message_id'] == tempMessageId,
        );
        if (file == null)
          dataList.insert(0, {
            'message_id': tempMessageId,
            'msg': text ?? '',
            'sender_id': senderId.toString(),
            'receiver_id': receiverId,
            'created_at': DateTime.now().toIso8601String(),
            'isLoading': file != null,
            'is_read': 0,
          });
        if (index != -1) {
          dataList[index] = {
            'msg': text ?? '',
            'message_id': messageId,
            'is_read': responseData['data']['message']['is_read'] ?? "",
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
        update();
        if (socketIds.isNotEmpty) {
          sockectcontroller.socket.emit('sendChatToServer', {
            'msg': text ?? '',
            'message_id': messageId,
            'created_at':
                responseData['data']['message']['created_at'] ??
                DateTime.now().toIso8601String(),
            'sender_name':
                responseData['data']['message']['sender']['arabic_name'],
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
      } else {
        log(
          'ChatStudentMessageControllerفشل إرسال الرسالة: ${response.reasonPhrase}',
        );
        dataList.removeWhere((msg) => msg['message_id'] == tempMessageId);
        update();
      }
    } catch (e) {
      log('ChatStudentMessageController خطأ أثناء إرسال الرسالة: $e');
      dataList.removeWhere((msg) => msg['message_id'] == tempMessageId);
      update();
    }
  }

  @override
  void onClose() {
    markChatAsRead(receiverId.value.toString());
    super.onClose();
  }

  Future<void> startRecording() async {
    final permissionGranted = await recorder.hasPermission();
    if (permissionGranted) {
      Directory appDir = await getApplicationDocumentsDirectory();
      recordingPath.value =
          '${appDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      // await recorder.start(path: recordingPath.value);
      isRecording.value = true;
      _startTime = DateTime.now();
      updateDuration();
    } else {
      print('Permission to record audio was denied.');
    }
  }

  void updateDuration() {
    if (_startTime != null) {
      final now = DateTime.now();
      final duration = now.difference(_startTime!);
      final durationInSeconds = duration.inSeconds;
      final minutes = (durationInSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (durationInSeconds % 60).toString().padLeft(2, '0');
      currentDuration.value = '$minutes:$seconds';
      if (isRecording.value) {
        Future.delayed(const Duration(seconds: 1), updateDuration);
      }
    }
  }

  Future<void> stopRecording() async {
    await recorder.stop();
    isRecording.value = false;
    currentDuration.value = '00:00';
    if (recordingPath.value.isNotEmpty) {}
  }
}
