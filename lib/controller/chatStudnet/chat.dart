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
import 'package:daliluna_altaalimi/core/services/upload_service.dart';
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
        if (Get.isRegistered<ChatStudentListTeacherController>()) {
          ChatStudentListTeacherController chatStudentListTeacherController =
              Get.find();
          chatStudentListTeacherController.chatStudent();
        }
        dataList.refresh();
        update();
      }
    });
  }

  Future<void> cancelAllNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
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
        if (Get.isRegistered<ChatStudentListTeacherController>()) {
          ChatStudentListTeacherController chatStudentListTeacherController =
              Get.find();
          chatStudentListTeacherController.chatStudent();
        }

        update();
      } else {
        print(
          "ChatStudentMessageController فشل في تحديث حالة المحادثة: ${response.body}",
        );
      }
    } catch (e) {}
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

      final response = await http.get(
        Uri.parse(
          "${AppLink.server}/getMessagesStudent/${receiverId}?page=${currentPage.value}",
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
        throw Exception('Failed to load messages');
      }
    } catch (e) {
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

    String tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    // insert temporary message immediately for better UX
    dataList.insert(0, {
      'message_id': tempMessageId,
      'msg': text ?? '',
      'sender_id': senderId.toString(),
      'receiver_id': receiverId,
      'created_at': DateTime.now().toIso8601String(),
      'isLoading': file != null,
      'uploadProgress': 0.0,
      'is_read': 0,
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
        url: AppLink.server + '/message_student_chat',
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

      // If controller is closed, just return (background task finished)
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
        // Update existing temporary message
        dataList[index] = {
          'msg': text ?? '',
          'message_id': messageId,
          'is_read': responseData['data']['message']['is_read'] ?? 0,
          'sender_id': senderId.toString(),
          'receiver_id': receiverId,
          'created_at':
              responseData['data']['message']['created_at'] ??
              DateTime.now().toIso8601String(),
          'm_file': filePath != null
              ? {'path': filePath, 'type': fileTypeResponse}
              : null,
        };
      } else {
        // Fallback: Insert if message wasn't found in list (e.g. cleared or text message)
        dataList.insert(0, {
          'message_id': messageId,
          'msg': text ?? '',
          'sender_id': senderId.toString(),
          'receiver_id': receiverId,
          'is_read': responseData['data']['message']['is_read'] ?? 0,
          'created_at':
              responseData['data']['message']['created_at'] ??
              DateTime.now().toIso8601String(),
          'm_file': filePath != null
              ? {'path': filePath, 'type': fileTypeResponse}
              : null,
        });
      }
      update();
      if (Get.isRegistered<ChatStudentListTeacherController>()) {
        try {
          ChatStudentListTeacherController chatStudentListTeacherController =
              Get.find();
          chatStudentListTeacherController.chatStudent();
        } catch (e) {
          log("Error updating chat list: $e");
        }
      }

      update();
      for (int i = 0; i < socketIds.length; i++) {
        log("socketId: ${socketIds[i]}");
      }

      if (socketIds.isNotEmpty) {
        log("Emitting sendChatToServer with ${socketIds.length} recipients");
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
      } else {
        log("Warning: socketIds is empty, skipping emit");
      }
    } catch (e) {
      log("Error in sendMessage: $e");
      dataList.removeWhere((msg) => msg['message_id'] == tempMessageId);
      update();
    }
  }

  @override
  void onClose() {
    markChatAsRead(receiverId.value.toString());
    recorder.dispose();
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
    } else {}
  }

  void updateDuration() {
    if (isClosed) return;
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
