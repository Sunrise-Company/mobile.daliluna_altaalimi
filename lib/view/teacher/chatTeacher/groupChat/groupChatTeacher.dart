import 'dart:io';

import 'package:daliluna_altaalimi/controller/chatStudnet/RecoringController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/InlineVideoPlayer.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/teacher/chatTeacher/groupChat/groupdetailes.dart';
import 'package:daliluna_altaalimi/view/widget/GetValueForScreen.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as path;
import '../../../../controller/teacherController/chat/groupChatController.dart';
import '../../../../core/constant/color.dart';

class GroupChatPageTeacher extends GetView<ChatGroupMessageTeacherController> {
  final TextEditingController messageController = TextEditingController();
  // ignore: unused_field
  File? _file;

  final RecorderController recorderController = Get.put(RecorderController());

  @override
  Widget build(BuildContext context) {
    controller.markChatAsRead(controller.receiverId.toString());

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color(0xFFF5F7FA),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              getValueForScreenType<double>(
                context: context,
                mobile: 70,
                tablet: 100,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.DeepPurple, AppColor.PrimaryColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.DeepPurple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: responsiveValue(
                      context: context,
                      mobile: 20,
                      tablet: 30,
                    ),
                  ),
                  onPressed: () => Get.back(),
                ),
                centerTitle: true,
                title: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => GroupDetailsScreen(groupData: controller.dataList),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.groups,
                              color: AppColor.DeepPurple,
                              size: responsiveValue(
                                context: context,
                                mobile: 18,
                                tablet: 28,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            controller.name.value,
                            style: TextStyle(
                              fontSize: responsiveValue(
                                context: context,
                                mobile: 18,
                                tablet: 32,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Obx(() {
                        if (controller.dataList.isEmpty ||
                            controller.dataList['students'] == null) {
                          return SizedBox.shrink();
                        }
                        final students =
                            (controller.dataList['students'] as List?) ?? [];
                        final count = students.length + 1; // +1 for teacher
                        return Text(
                          '$count أعضاء',
                          style: TextStyle(
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 11,
                              tablet: 18,
                            ),
                            color: Colors.white70,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF5F7FA), Color(0xFFE8EBF0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return controller.isloded.value
                        ? controller.messageList.isNotEmpty
                              ? ListView.builder(
                                  controller: controller.scrollController,
                                  reverse: true,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  itemCount:
                                      controller.messageList.length +
                                      (controller.hasMoreData.value ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        controller.messageList.length) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Loading(),
                                        ),
                                      );
                                    }
                                    final message =
                                        controller.messageList[index];
                                    final bool isMe =
                                        message['sender_id'].toString() ==
                                        controller.senderId.toString();

                                    return _buildMessageBubble(
                                      context: context,
                                      message: message,
                                      isMe: isMe,
                                    );
                                  },
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        size: 80,
                                        color: Colors.grey[300],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "لا توجد رسائل في المجموعة",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "ابدأ المحادثة الآن!",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                        : Center(child: Loading());
                  }),
                ),
                _buildInputArea(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble({
    required BuildContext context,
    required Map<String, dynamic> message,
    required bool isMe,
  }) {
    final isLoading =
        message.containsKey('isLoading') && message['isLoading'] == true;
    final senderName =
        message['sender_name']?.toString() ??
        (message['sender'] != null
            ? (message['sender']['name']?.toString() ??
                  message['sender']['arabic_name']?.toString() ??
                  "مستخدم")
            : "مستخدم");

    return AnimatedOpacity(
      opacity: isLoading ? 0.6 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Padding(
        padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isMe ? 60 : 8,
          right: isMe ? 8 : 60,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (!isMe)
              Padding(
                padding: EdgeInsets.only(right: 12, left: 12, bottom: 4),
                child: Text(
                  senderName,
                  style: TextStyle(
                    fontSize: responsiveValue(
                      context: context,
                      mobile: 11,
                      tablet: 16,
                    ),
                    color: AppColor.DeepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                          colors: [AppColor.DeepPurple, AppColor.PrimaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isMe ? null : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isMe ? 18 : 4),
                    topRight: Radius.circular(isMe ? 4 : 18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isMe
                          ? AppColor.DeepPurple.withOpacity(0.3)
                          : Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                value: message['uploadProgress'] is double
                                    ? message['uploadProgress']
                                    : null,
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isMe ? Colors.white : AppColor.DeepPurple,
                                ),
                                backgroundColor:
                                    isMe ? Colors.white24 : Colors.grey[200],
                              ),
                            ),
                            if (message['uploadProgress'] is double)
                              Text(
                                "${((message['uploadProgress'] as double) * 100).toInt()}%",
                                style: TextStyle(
                                  color:
                                      isMe ? Colors.white : AppColor.DeepPurple,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          ],
                        ),
                      ),
                    if (!isLoading) ...[
                      if (message['msg'] != null && message['msg'].isNotEmpty)
                        Text(
                          '${message['msg']}',
                          style: TextStyle(
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 15,
                              tablet: 25,
                            ),
                            color: isMe ? Colors.white : Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      if (message['m_file'] != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top:
                                message['msg'] != null &&
                                    message['msg'].isNotEmpty
                                ? 8
                                : 0,
                          ),
                          child: _buildFileWidget(message['m_file']),
                        ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(DateTime.parse(message['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(message['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(message['created_at']).hour >= 12 ? 'م' : 'ص'}',
                            style: TextStyle(
                              fontSize: responsiveValue(
                                context: context,
                                mobile: 10,
                                tablet: 15,
                              ),
                              color: isMe ? Colors.white70 : Colors.black45,
                            ),
                          ),
                          if (isMe) ...[
                            SizedBox(width: 4),
                            Icon(
                              // In group chat, simple check for sent (or read if supported by backend)
                              // For now, we show double check if it's not loading, assuming sent to server
                              Icons.done_all,
                              size: responsiveValue(
                                context: context,
                                mobile: 14,
                                tablet: 20,
                              ),
                              color: isMe ? Color(0xFF4FFFB0) : Colors.black54,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: responsiveValue(
                            context: context,
                            mobile: 15,
                            tablet: 22,
                          ),
                        ),
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالتك...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 14,
                              tablet: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(
                          icon: Icons.photo_library,
                          color: AppColor.DeepPurple,
                          onPressed: () async {
                            await pickAndConfirmImage(context);
                          },
                          context: context,
                        ),
                        _buildActionButton(
                          icon: Icons.attach_file,
                          color: AppColor.DeepPurple,
                          onPressed: () async {
                            await pickAndShowFileDialog(context);
                          },
                          context: context,
                        ),
                        Obx(() {
                          return _buildActionButton(
                            icon: recorderController.isRecording.value
                                ? Icons.stop_circle
                                : Icons.mic,
                            color: recorderController.isRecording.value
                                ? Colors.red
                                : AppColor.DeepPurple,
                            onPressed: () async {
                              if (!recorderController.isRecording.value) {
                                await recorderController.startRecording();
                              } else {
                                await recorderController.stopRecording();
                                _showRecordingDialog(context);
                              }
                            },
                            context: context,
                          );
                        }),
                        SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            Obx(() {
              return recorderController.isRecording.value
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            recorderController.currentDuration.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: responsiveValue(
                                context: context,
                                mobile: 12,
                                tablet: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildSendButton(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Icon(
            icon,
            color: color,
            size: responsiveValue(context: context, mobile: 22, tablet: 35),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.DeepPurple, AppColor.PrimaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.DeepPurple.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (messageController.text.isNotEmpty) {
              controller.sendMessage(
                text: messageController.text,
                receiverId: controller.receiverId.value,
              );
              messageController.clear();
            }
          },
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: responsiveValue(context: context, mobile: 48, tablet: 65),
            height: responsiveValue(context: context, mobile: 48, tablet: 65),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: responsiveValue(context: context, mobile: 22, tablet: 32),
            ),
          ),
        ),
      ),
    );
  }

  void _showRecordingDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.PrimaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: AppColor.DeepPurple),
              ),
              title: Text(
                'إرسال التسجيل الصوتي',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('سيتم إرسال التسجيل إلى المحادثة'),
              onTap: () {
                if (recorderController.recordingPath.value.isNotEmpty) {
                  controller.sendMessage(
                    receiverId: controller.receiverId.value,
                    file: File(recorderController.recordingPath.value),
                  );
                  recorderController.deleteRecording();
                  Get.back();
                }
              },
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete, color: Colors.red),
              ),
              title: Text(
                'حذف التسجيل',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                recorderController.deleteRecording();
                Get.back();
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> pickAndConfirmImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      final File imageFile = File(image.path);
      String fileName = image.name;

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.image, color: AppColor.DeepPurple),
                SizedBox(width: 10),
                Text(
                  "تأكيد إرسال الصورة",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    imageFile,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  fileName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("إلغاء", style: TextStyle(color: Colors.grey[600])),
                onPressed: () => Navigator.pop(ctx),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.DeepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("إرسال", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  controller.sendMessage(
                    file: imageFile,
                    receiverId: controller.receiverId.value,
                  );
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> pickAndShowFileDialog(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      _file = file;

      String fileName = file.path.split('/').last;
      String fileExtension = fileName.split('.').last.toLowerCase();

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.attach_file, color: AppColor.DeepPurple),
                SizedBox(width: 10),
                Text(
                  "تأكيد إرسال الملف",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    fileExtension == "pdf"
                        ? Icons.picture_as_pdf
                        : ["jpg", "png", "jpeg"].contains(fileExtension)
                        ? Icons.image
                        : Icons.insert_drive_file,
                    size: 50,
                    color: fileExtension == "pdf"
                        ? Colors.red
                        : ["jpg", "png", "jpeg"].contains(fileExtension)
                        ? Colors.purple
                        : Colors.blue,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  fileName,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  fileExtension.toUpperCase(),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("إلغاء", style: TextStyle(color: Colors.grey[600])),
                onPressed: () {
                  Navigator.pop(ctx);
                  _file = null;
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.DeepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("إرسال", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  controller.sendMessage(
                    file: _file,
                    receiverId: controller.receiverId.value,
                  );
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildFileWidget(Map<String, dynamic> fileData, [bool isMe = false]) {
    String rawPath = fileData['path'].toString();

    if (rawPath.startsWith('/')) {
      rawPath = rawPath.substring(1);
    }
    String filePath = '${AppLink.baseUrl}/$rawPath';
    String fileType = fileData['type'];
    String fileName = path.basename(filePath);

    if (fileType == 'jpg' || fileType == 'png' || fileType == 'jpeg') {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: Get.context!,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  InteractiveViewer(
                    panEnabled: true,
                    boundaryMargin: EdgeInsets.all(20),
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(filePath, fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Hero(
          tag: filePath,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                filePath,
                height: 200,
                width: 250,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    width: 250,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: isMe ? Colors.white : AppColor.DeepPurple,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: 250,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else if (fileType == 'm4a' || fileType == 'mp3') {
      return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isMe ? Colors.white.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: AudioPlayerWidget(audioUrl: filePath),
      );
    } else if (fileType == 'mp4') {
      return GestureDetector(
        onTap: () {
          Get.dialog(
            Dialog(
              backgroundColor: Colors.black,
              insetPadding: EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                height: 300,
                child: InlineVideoPlayer(videoUrl: filePath),
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder<String?>(
                future: generateThumbnail(filePath),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.file(
                      File(snapshot.data!),
                      height: 200,
                      width: 250,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Container(
                      height: 200,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow, size: 40, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } else {
      IconData fileIcon;
      Color iconColor;
      Color iconBgColor;

      if (fileType == 'pdf') {
        fileIcon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        iconBgColor = Colors.red.shade50;
      } else if (['doc', 'docx'].contains(fileType)) {
        fileIcon = Icons.description;
        iconColor = Colors.blue;
        iconBgColor = Colors.blue.shade50;
      } else if (['xls', 'xlsx'].contains(fileType)) {
        fileIcon = Icons.table_chart;
        iconColor = Colors.green;
        iconBgColor = Colors.green.shade50;
      } else {
        fileIcon = Icons.insert_drive_file;
        iconColor = AppColor.DeepPurple;
        iconBgColor = AppColor.DeepPurple.withOpacity(0.1);
      }

      return GestureDetector(
        onTap: () {
          downloadAndOpenFile(filePath, fileName);
        },
        child: Container(
          width: 250,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe ? Colors.white.withOpacity(0.15) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isMe
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(fileIcon, color: iconColor, size: 28),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      fileType.toUpperCase(),
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.download_rounded,
                color: isMe ? Colors.white70 : Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> downloadAndOpenFile(String fileUrl, String name) async {
    try {
      String fileName = path.basename(fileUrl);
      Directory tempDir = await getTemporaryDirectory();
      String savePath = '${tempDir.path}/$fileName';

      // Show loading indicator
      Get.dialog(Center(child: Loading()), barrierDismissible: false);

      Dio dio = Dio();
      await dio.download(fileUrl, savePath);

      // Hide loading
      Get.back();

      await OpenFilex.open(savePath);
    } catch (e) {
      Get.back(); // Hide loading if error
      Get.snackbar(
        "خطأ",
        "فشل فتح الملف",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String?> generateThumbnail(String videoPath) async {
    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 200,
        quality: 75,
      );
      return thumbnailPath;
    } catch (e) {
      return null;
    }
  }
}
