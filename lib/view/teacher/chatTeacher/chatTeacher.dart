import 'dart:developer';
import 'dart:io';

import 'package:daliluna_altaalimi/controller/chatStudnet/RecoringController.dart';
import 'package:daliluna_altaalimi/controller/chatStudnet/chat.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/InlineVideoPlayer.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/homeTeacherController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/teacher/homepageTeacher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../controller/teacherController/chat/chatTeacherController.dart';
import '../../../core/constant/color.dart';
import '../../widget/GetValueForScreen.dart';

class ChatPage extends GetView<ChatTeacherController> {
  final RecorderController recorderController = Get.put(RecorderController());
  final TextEditingController messageController = TextEditingController();
  File? _file;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Get.lazyPut(() => HomePageTeacherController());
        HomePageTeacherController controller = Get.find();
        controller.changePage(0);
        Get.offNamed('/homepageTeacher');
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,

        child: Scaffold(
          // عدلت هاد مبارح دون تجريب
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              getValueForScreenType<double>(
                context: context,
                mobile: 55,
                tablet: 100,
              ),
            ),
            child: AppBar(
              elevation: 0,
              backgroundColor: AppColor.PrimaryColor,
              title: Text(
                controller.name.toString(),
                style: TextStyle(
                  fontSize: responsiveValue(
                    context: context,
                    mobile: 20,
                    tablet: 35,
                  ),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // appBar: AppBar(
          //   title: Text(
          //     // Get.arguments['name'],
          //     controller.name.toString(),
          //     style: TextStyle(color: AppColor.White),
          //   ),
          //   backgroundColor: AppColor.PrimaryColor,
          // ),
          // body: Column(
          //   children: [
          //     Expanded(
          //       child: Obx(
          //         () {
          //           return controller.isloded.value
          //               ? controller.dataList.isNotEmpty
          //                   ? ListView.builder(
          //                       controller: controller.scrollController,
          //                       reverse: true,
          //                       itemCount: controller.dataList.length +
          //                           (controller.hasMoreData.value ? 1 : 0),
          //                       itemBuilder: (context, index) {
          //                         if (index == controller.dataList.length) {
          //                           return Center(
          //                               child: CircularProgressIndicator());
          //                         }
          //                         final message = controller.dataList[index];
          //                         final bool isMe =
          //                             message['sender_id'].toString() ==
          //                                 controller.senderId.toString();
          //                         return Padding(
          //                           padding: const EdgeInsets.all(3.0),
          //                           child: Align(
          //                             alignment: isMe
          //                                 ? Alignment.centerRight
          //                                 : Alignment.centerLeft,
          //                             child: Container(
          //                               padding: EdgeInsets.all(10.0),
          //                               decoration: BoxDecoration(
          //                                 color: isMe
          //                                     ? AppColor.DeepPurple2
          //                                     : AppColor.SecondaryColor,
          //                                 borderRadius:
          //                                     BorderRadius.circular(10.0),
          //                               ),
          //                               child: Column(
          //                                 crossAxisAlignment:
          //                                     CrossAxisAlignment.start,
          //                                 children: [
          //                                   if (message
          //                                           .containsKey('isLoading') &&
          //                                       message['isLoading'] == true)
          //                                     CircularProgressIndicator(),
          //                                   if (!message
          //                                           .containsKey('isLoading') ||
          //                                       message['isLoading'] ==
          //                                           false) ...[
          //                                     if (message['msg'] != null &&
          //                                         message['msg'].isNotEmpty)
          //                                       Text('${message['msg']}',
          //                                           style: TextStyle(
          //                                               fontSize: 16.0)),
          //                                     if (message['m_file'] != null)
          //                                       _buildFileWidget(
          //                                           message['m_file']),
          //                                     SizedBox(height: 5.0),
          //                                     Text(
          //                                       '${(DateTime.parse(message['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(message['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(message['created_at']).hour >= 12 ? 'م' : 'ص'}',
          //                                       style: const TextStyle(
          //                                           fontSize: 10,
          //                                           color: Colors.black54),
          //                                     ),
          //                                     SizedBox(width: 5.0),
          //
          //                                   ],
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //                         );
          //                       },
          //                     )
          //                   : Center(
          //                       child: Text("لا يوجد"),
          //                     )
          //               : Center(
          //                   child: CircularProgressIndicator(),
          //                 );
          //         },
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: TextField(
          //               controller: messageController,
          //               decoration: InputDecoration(
          //                 hintText: 'اكتب رسالة...',
          //                 border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(30.0),
          //                 ),
          //                 suffixIcon: Row(
          //                   mainAxisSize: MainAxisSize.min,
          //                   children: [
          //                     IconButton(
          //                       icon: Icon(Icons.photo_library,
          //                           color: AppColor.DeepPurple),
          //                       onPressed: () async {
          //                         await pickAndConfirmImage(context);
          //                       },
          //                     ),
          //                     IconButton(
          //                       icon: Icon(Icons.attach_file,
          //                           color: AppColor.DeepPurple),
          //                       onPressed: () async {
          //                         await pickAndShowFileDialog(context);
          //                       },
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Obx(() {
          //             if (recorderController.isRecording.value) {
          //               return Text(
          //                 'التسجيل: ${recorderController.currentDuration.value} ',
          //                 style: TextStyle(color: Colors.red),
          //               );
          //             } else {
          //               return SizedBox.shrink();
          //             }
          //           }),
          //           IconButton(
          //             icon: Icon(
          //               recorderController.isRecording.value
          //                   ? Icons.stop
          //                   : Icons.mic,
          //               color: recorderController.isRecording.value
          //                   ? Colors.red
          //                   : AppColor.DeepPurple,
          //             ),
          //             onPressed: () async {
          //               if (!recorderController.isRecording.value) {
          //                 await recorderController.startRecording();
          //                 recorderController.isRecording.value = true;
          //               } else {
          //                 await recorderController.stopRecording();
          //                 recorderController.isRecording.value = false;
          //                 Get.bottomSheet(
          //                   Container(
          //                     padding: EdgeInsets.all(16.0),
          //                     child: Column(
          //                       mainAxisSize: MainAxisSize.min,
          //                       children: [
          //                         ListTile(
          //                           leading: Icon(Icons.send,
          //                               color: AppColor.DeepPurple),
          //                           title: Text('إرسال التسجيل'),
          //                           onTap: () {
          //                             if (recorderController
          //                                 .recordingPath.value.isNotEmpty) {
          //                               controller.sendMessage(
          //                                   receiverId:
          //                                       controller.receiverId.value,
          //                                   file: File(recorderController
          //                                       .recordingPath.value));
          //                               recorderController.deleteRecording();
          //                               Get.back();
          //                             }
          //                           },
          //                         ),
          //                         ListTile(
          //                           leading:
          //                               Icon(Icons.delete, color: Colors.red),
          //                           title: Text('حذف التسجيل'),
          //                           onTap: () {
          //                             recorderController.deleteRecording();
          //                             Get.back();
          //                           },
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   backgroundColor: Colors.white,
          //                 );
          //               }
          //             },
          //           ),
          //           Obx(() {
          //             return recorderController.isRecording.value
          //                 ? SizedBox.shrink()
          //                 : IconButton(
          //                     icon:
          //                         Icon(Icons.send, color: AppColor.DeepPurple),
          //                     onPressed: () {
          //                       if (messageController.text.isNotEmpty) {
          //                         controller.sendMessage(
          //                           text: messageController.text,
          //                           receiverId: controller.receiverId.value,
          //                         );
          //                         messageController.clear();
          //                       }
          //                     },
          //                   );
          //           }),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.DeepPurple,
                  AppColor.DeepPurple2,
                  AppColor.PrimaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return controller.isloded.value
                        ? controller.dataList.isNotEmpty
                              ? ListView.builder(
                                  controller: controller.scrollController,
                                  reverse: true,
                                  itemCount:
                                      controller.dataList.length +
                                      (controller.hasMoreData.value ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == controller.dataList.length) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final message = controller.dataList[index];
                                    final bool isMe =
                                        message['sender_id'].toString() ==
                                        controller.senderId.toString();

                                    return Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Align(
                                        alignment: isMe
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.75,
                                          ),
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: AppColor.BackGround,
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (message.containsKey(
                                                    'isLoading',
                                                  ) &&
                                                  message['isLoading'] == true)
                                                const CircularProgressIndicator(),
                                              if (!message.containsKey(
                                                    'isLoading',
                                                  ) ||
                                                  message['isLoading'] ==
                                                      false) ...[
                                                if (message['msg'] != null &&
                                                    message['msg'].isNotEmpty)
                                                  Text(
                                                    '${message['msg']}',
                                                    style: TextStyle(
                                                      fontSize: responsiveValue(
                                                        context: context,
                                                        mobile: 15,
                                                        tablet: 25,
                                                      ),
                                                    ),
                                                  ),
                                                if (message['m_file'] != null)
                                                  _buildFileWidget(
                                                    message['m_file'],
                                                  ),
                                                const SizedBox(height: 5.0),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      '${(DateTime.parse(message['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(message['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(message['created_at']).hour >= 12 ? 'م' : 'ص'}',
                                                      style: TextStyle(
                                                        fontSize:
                                                            responsiveValue(
                                                              context: context,
                                                              mobile: 10,
                                                              tablet: 15,
                                                            ),
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Center(child: Text("لا يوجد"))
                        : const Center(child: CircularProgressIndicator());
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'اكتب رسالة...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.photo_library,
                                    color: AppColor.DeepPurple,
                                    size: responsiveValue(
                                      context: context,
                                      mobile: 25,
                                      tablet: 40,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await pickAndConfirmImage(context);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.attach_file,
                                    color: AppColor.DeepPurple,
                                    size: responsiveValue(
                                      context: context,
                                      mobile: 25,
                                      tablet: 40,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await pickAndShowFileDialog(context);
                                  },
                                ),
                                Obx(() {
                                  if (recorderController.isRecording.value) {
                                    return Text(
                                      'التسجيل: ${recorderController.currentDuration.value}',
                                      style: const TextStyle(color: Colors.red),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }),
                                IconButton(
                                  icon: Icon(
                                    recorderController.isRecording.value
                                        ? Icons.stop
                                        : Icons.mic,
                                    color: recorderController.isRecording.value
                                        ? Colors.red
                                        : AppColor.DeepPurple,
                                    size: responsiveValue(
                                      context: context,
                                      mobile: 25,
                                      tablet: 40,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (!recorderController.isRecording.value) {
                                      await recorderController.startRecording();
                                      recorderController.isRecording.value =
                                          true;
                                    } else {
                                      await recorderController.stopRecording();
                                      recorderController.isRecording.value =
                                          false;

                                      Get.bottomSheet(
                                        Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: Icon(
                                                  Icons.send,
                                                  color: AppColor.DeepPurple,
                                                ),
                                                title: const Text(
                                                  'إرسال التسجيل',
                                                ),
                                                onTap: () {
                                                  if (recorderController
                                                      .recordingPath
                                                      .value
                                                      .isNotEmpty) {
                                                    controller.sendMessage(
                                                      receiverId: controller
                                                          .receiverId
                                                          .value,
                                                      file: File(
                                                        recorderController
                                                            .recordingPath
                                                            .value,
                                                      ),
                                                    );
                                                    recorderController
                                                        .deleteRecording();
                                                    Get.back();
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                title: const Text(
                                                  'حذف التسجيل',
                                                ),
                                                onTap: () {
                                                  recorderController
                                                      .deleteRecording();
                                                  Get.back();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        return recorderController.isRecording.value
                            ? const SizedBox.shrink()
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 27,
                                  ),
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.send,
                                          color: AppColor.DeepPurple,
                                          size: responsiveValue(
                                            context: context,
                                            mobile: 30,
                                            tablet: 40,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (messageController
                                              .text
                                              .isNotEmpty) {
                                            controller.sendMessage(
                                              text: messageController.text,
                                              receiverId:
                                                  controller.receiverId.value,
                                            );
                                            messageController.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> downloadAndOpenFile(String fileUrl, String name) async {
    try {
      String fileName = path.basename(fileUrl); // استخراج اسم الملف من الـ URL
      Directory tempDir = await getTemporaryDirectory();
      String savePath = '${tempDir.path}/$fileName';

      Dio dio = Dio();
      await dio.download(fileUrl, savePath);

      OpenFilex.open(savePath);
    } catch (e) {
      print("⚠️ خطأ في تحميل أو فتح الملف: $e");
    }
  }

  Future<void> pickAndShowFileDialog(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // Allow any file type
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      _file = file;

      String fileName = file.path.split('/').last;
      String fileExtension = fileName.split('.').last.toLowerCase();

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                "تأكيد إرسال الملف ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (fileExtension == "pdf")
                  const Icon(Icons.picture_as_pdf, size: 55, color: Colors.red)
                else if (["jpg", "png", "jpeg"].contains(fileExtension))
                  Image.file(file, height: 100)
                else
                  const Icon(
                    Icons.insert_drive_file,
                    size: 55,
                    color: Colors.blue,
                  ),
                Text("File: $fileName", style: const TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  "إلغاء",
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _file = null;
                },
              ),
              TextButton(
                child: const Text(
                  "إرسال",
                  style: TextStyle(fontSize: 13, color: Colors.green),
                ),
                onPressed: () {
                  controller.sendMessage(
                    file: _file,
                    receiverId: controller.receiverId.value,
                  );
                  // sendMessage(messageController.text, file);
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildFileWidget(Map<String, dynamic> fileData) {
    String rawPath = fileData['path'].toString();

    if (rawPath.startsWith('/')) {
      rawPath = rawPath.substring(1);
    }
    String filePath = '${AppLink.baseUrl}/$rawPath';
    String fileType = fileData['type'];
    String fileName = path.basename(filePath);

    if (fileType == 'jpg' || fileType == 'png' || fileType == 'jpeg') {
      // عرض الصور
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
                    maxScale: 2.5,
                    child: Image.network(filePath, fit: BoxFit.contain),
                  ),
                ],
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            filePath,
            height: 200,
            width: 250,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (fileType == 'm4a' || fileType == 'mp3') {
      // عرض ملفات الصوت
      return AudioPlayerWidget(audioUrl: filePath);
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
                    color: Colors.grey,
                    child: Icon(Icons.videocam, size: 50),
                  );
                }
              },
            ),
            Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
          ],
        ),
      );
    } else if (fileType == 'pdf' ||
        fileType == 'doc' ||
        fileType == 'docx' ||
        fileType == 'xlsx') {
      // عرض ملفات PDF، Word، Excel
      return GestureDetector(
        onTap: () {
          // تنزيل وفتح الملف
          downloadAndOpenFile(filePath, fileName);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                fileType == 'pdf'
                    ? Icons.picture_as_pdf
                    : fileType == 'doc' || fileType == 'docx'
                    ? Icons.article
                    : Icons.table_chart,
                color: fileType == 'pdf'
                    ? Colors.red
                    : fileType == 'doc' || fileType == 'docx'
                    ? Colors.blue
                    : Colors.green,
                size: 40,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    fileType.toUpperCase(),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // أنواع الملفات الأخرى
      return GestureDetector(
        onTap: () {
          // تنزيل وفتح الملف
          downloadAndOpenFile(filePath, fileName);
        },
        child: Text(
          "اضغط لفتح الملف",
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
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
      print("⚠️ خطأ في إنشاء الصورة المصغرة: $e");
      return null;
    }
  }

  Future<void> pickAndConfirmImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    // اختيار صورة من المعرض
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      final File imageFile = File(image.path);
      String fileName = image.name;
      String fileExtension = fileName.split('.').last.toLowerCase();

      // عرض ديالوج التأكيد
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: const Text(
                "تأكيد إرسال الصورة",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  imageFile,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  fileName,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("إلغاء", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
              TextButton(
                child: const Text(
                  "إرسال",
                  style: TextStyle(color: Colors.green),
                ),
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
}
