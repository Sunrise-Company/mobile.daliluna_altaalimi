import 'package:daliluna_altaalimi/controller/videoLectureControllers.dart';
import 'package:daliluna_altaalimi/view/screen/ytPlayer.dart';

import 'package:flutter/material.dart';
// import 'package:gradients/gradients.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Error")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class VideoLecture extends GetView<VideoLecturesController> {
  bool _isYoutubeLink(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  @override
  Widget build(BuildContext context) {
    final String url = Get.arguments['url'] as String;
    final List<dynamic>? videoFiles = Get.arguments['videoFiles'];
    final int lessonId = Get.arguments['lesson_dep_file_id'];

    if (_isYoutubeLink(url)) {
      String? videoId;
      try {
        videoId = VideoId(url).value;
      } catch (e) {}

      if (videoId != null) {
        return YoutubePlayer(
          videoId: videoId,
          lessonId: lessonId,
          type: 'lesson_lecture_file',
        );
      } else {
        return Scaffold(
          appBar: AppBar(title: const Text("Error")),
          body: const Center(child: Text("Invalid or unsupported video link.")),
        );
      }
    }

    if (videoFiles == null || videoFiles.isEmpty) {
      if (_isYoutubeLink(url)) {
        String? videoId;
        try {
          videoId = VideoId(url).value;
        } catch (e) {}

        if (videoId != null) {
          // This block is now redundant but kept for structure if needed,
          // though the top block covers it.
          // We can just keep the non-youtube check here or simply proceed.
          // Since we already checked _isYoutubeLink above, we can assume it's NOT a youtube link here?
          // No, if the above check is false, then we come here.
          // But if videoFiles is empty and it is NOT a youtube link, then what?
          // It continues to Get.put, then likely fails or shows empty.

          return YoutubePlayer(
            videoId: videoId,
            lessonId: lessonId,
            type: 'lesson_lecture_file',
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: const Center(
              child: Text("Invalid or unsupported video link."),
            ),
          );
        }
      }
    }

    Get.put(VideoLecturesController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topCenter,
                  colors: <Color>[AppColor.SecondryColor2, AppColor.DeepPurple],
                ),
              ),
            ),
            title: Text(
              "الفيديو",
              style: TextStyle(
                color: AppColor.White,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 20,
                  tablet: 30,
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        // body: Obx(() {
        //   final video = controller.videoFiles.isNotEmpty
        //       ? controller.videoFiles.firstWhere(
        //           (file) =>
        //               file['resolution'] == controller.selectedQuality.value,
        //           orElse: () => null,
        //         )
        //       : null;
        //   String videoId = video != null && video['id'] != null
        //       ? video['id'].toString()
        //       : Get.arguments['url'];
        //   String resolution = controller.selectedQuality.value;
        //   String progressKey = '${videoId}_$resolution';
        //   return Column(
        //     children: [
        //       controller.isError.value &&
        //               !controller.downloading.value &&
        //               !controller.isVideoDownloadedVar.value
        //           ? Column(
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 SizedBox(height: 200),
        //                 Center(
        //                   child: Container(
        //                     padding: EdgeInsets.all(24),
        //                     decoration: BoxDecoration(
        //                       color: Colors.red.shade50,
        //                       borderRadius: BorderRadius.circular(12),
        //                       boxShadow: [
        //                         BoxShadow(
        //                           color: Colors.black12,
        //                           blurRadius: 8,
        //                           offset: Offset(0, 4),
        //                         ),
        //                       ],
        //                     ),
        //                     child: Column(
        //                       mainAxisSize: MainAxisSize.min,
        //                       children: [
        //                         Icon(
        //                           Icons.wifi_off,
        //                           size: 48,
        //                           color: Colors.red.shade600,
        //                         ),
        //                         SizedBox(height: 16),
        //                         Text(
        //                           'شبكة الإنترنت لديك ضعيفة',
        //                           style: TextStyle(
        //                             fontSize: 18,
        //                             fontWeight: FontWeight.bold,
        //                             color: Colors.red.shade700,
        //                           ),
        //                           textAlign: TextAlign.center,
        //                         ),
        //                         SizedBox(height: 12),
        //                         Text(
        //                           'يرجى التحقق من الاتصال والمحاولة مجدداً',
        //                           style: TextStyle(
        //                             fontSize: 14,
        //                             color: Colors.grey.shade700,
        //                           ),
        //                           textAlign: TextAlign.center,
        //                         ),
        //                         SizedBox(height: 20),
        //                         ElevatedButton(
        //                           onPressed: () {
        //                             controller.loadVideoPath();
        //                           },
        //                           style: ElevatedButton.styleFrom(
        //                             foregroundColor: Colors.black87,
        //                             backgroundColor: Colors.yellow.shade700,
        //                             padding: EdgeInsets.symmetric(
        //                                 horizontal: 24, vertical: 12),
        //                             shape: RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(8),
        //                             ),
        //                             elevation: 4,
        //                           ),
        //                           child: Text(
        //                             'حاول مجدداً',
        //                             style: TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             )
        //           : Directionality(
        //               textDirection: TextDirection.rtl,
        //               child: Column(
        //                 children: [
        //                   controller.isError.value &&
        //                           controller.isVideoDownloadedVar.value
        //                       ? Center(
        //                           child: Padding(
        //                             padding: const EdgeInsets.symmetric(
        //                                 vertical: 100),
        //                             child: Text(
        //                               '${progressMapLec[progressKey] ?? "0%"} .... الرجاء الانتظار ريثما يتم اكمال تحميل الفيديو',
        //                             ),
        //                           ),
        //                         )
        //                       : Container(
        //                           height: 250,
        //                           width: MediaQuery.of(context).size.width,
        //                           child: controller.isLoading.value
        //                               ? Shimmer.fromColors(
        //                                   baseColor: Colors.grey[300]!,
        //                                   highlightColor: Colors.grey[100]!,
        //                                   child: Container(
        //                                     width: double.infinity,
        //                                     height: 200,
        //                                     color: Colors.white,
        //                                   ),
        //                                 )
        //                               : BetterPlayer(
        //                                   controller: controller
        //                                       .betterPlayerController!,
        //                                 ),
        //                         ),
        //                   if (controller.downloading.value)
        //                     Padding(
        //                       padding: const EdgeInsets.symmetric(
        //                           horizontal: 16.0, vertical: 10.0),
        //                       child: Column(
        //                         children: [
        //                           LinearProgressIndicator(
        //                             value: controller.progress.value,
        //                             backgroundColor: Colors.grey,
        //                             valueColor: AlwaysStoppedAnimation<Color>(
        //                                 AppColor.DeepPurple),
        //                           ),
        //                           SizedBox(height: 5),
        //                           Text(
        //                             'جاري التحميل الرجاء البقاء في الصفحة ريثما ينتهي التحميل: ${progressMapLec[progressKey] ?? "0%"}',
        //                             style: TextStyle(
        //                               color: Colors.black87,
        //                               fontSize: 14,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   SizedBox(height: 25),
        //                   Obx(() {
        //                     if (controller.videoFiles.length == 0) {
        //                       return !controller.isVideoDownloadedVar.value
        //                           ? Padding(
        //                               padding: const EdgeInsets.all(8.0),
        //                               child: Column(
        //                                 children: [
        //                                   ElevatedButton.icon(
        //                                     style: ElevatedButton.styleFrom(
        //                                       backgroundColor:
        //                                           AppColor.DeepPurple,
        //                                       padding: EdgeInsets.symmetric(
        //                                           horizontal: 20, vertical: 10),
        //                                       shape: RoundedRectangleBorder(
        //                                         borderRadius:
        //                                             BorderRadius.circular(15),
        //                                       ),
        //                                     ),
        //                                     icon: Icon(Icons.download,
        //                                         color: Colors.white),
        //                                     label: Text(
        //                                       "تحميل الفيديو",
        //                                       style: TextStyle(
        //                                           color: Colors.white),
        //                                     ),
        //                                     onPressed: () async {
        //                                       try {
        //                                         String url =
        //                                             Get.arguments['url'];
        //                                         await controller.downloadFile(
        //                                             url, "");
        //                                       } catch (e) {
        //                                         Get.snackbar(
        //                                             "خطأ", "فشل تحميل الفيديو",
        //                                             backgroundColor:
        //                                                 Colors.red);
        //                                       }
        //                                     },
        //                                   ),
        //                                   SizedBox(height: 10),
        //                                 ],
        //                               ),
        //                             )
        //                           : controller.isVideoDownloadedVar.value &&
        //                                   !controller.isError.value
        //                               ? Padding(
        //                                   padding: const EdgeInsets.only(
        //                                       right: 10.0),
        //                                   child: ElevatedButton.icon(
        //                                     style: ElevatedButton.styleFrom(
        //                                       backgroundColor: Colors.red,
        //                                       padding: EdgeInsets.symmetric(
        //                                           horizontal: 20, vertical: 10),
        //                                       shape: RoundedRectangleBorder(
        //                                         borderRadius:
        //                                             BorderRadius.circular(15),
        //                                       ),
        //                                     ),
        //                                     icon: Icon(Icons.delete,
        //                                         color: Colors.white),
        //                                     label: Text(
        //                                       "حذف الفيديو",
        //                                       style: TextStyle(
        //                                           color: Colors.white),
        //                                     ),
        //                                     onPressed: () {
        //                                       Get.defaultDialog(
        //                                         title: "تأكيد الحذف",
        //                                         titleStyle: TextStyle(
        //                                           color: Colors.red[800],
        //                                           fontWeight: FontWeight.bold,
        //                                           fontSize: 20,
        //                                         ),
        //                                         middleText:
        //                                             "هل أنت متأكد أنك تريد حذف الفيديو؟",
        //                                         middleTextStyle:
        //                                             TextStyle(fontSize: 16),
        //                                         confirm: ElevatedButton.icon(
        //                                           onPressed: () async {
        //                                             Get.back();
        //                                             try {
        //                                               final success = await controller
        //                                                   .deleteVideoFromStorage(
        //                                                       controller
        //                                                           .selectedQuality
        //                                                           .value);

        //                                               if (success) {
        //                                                 Get.snackbar("نجاح",
        //                                                     "تم الحذف بنجاح");
        //                                               } else {
        //                                                 Get.snackbar("فشل",
        //                                                     "فشل في حذف الفيديو أو أنه غير موجود",
        //                                                     backgroundColor:
        //                                                         Colors.red);
        //                                               }

        //                                               controller
        //                                                   .loadVideoPlayer(
        //                                                       true);
        //                                             } catch (e) {}
        //                                           },
        //                                           icon: Icon(Icons.check,
        //                                               color: Colors.white),
        //                                           label: Text("نعم",
        //                                               style: TextStyle(
        //                                                   color: Colors.white)),
        //                                           style:
        //                                               ElevatedButton.styleFrom(
        //                                             backgroundColor:
        //                                                 Colors.red[700],
        //                                             shape:
        //                                                 RoundedRectangleBorder(
        //                                               borderRadius:
        //                                                   BorderRadius.circular(
        //                                                       10),
        //                                             ),
        //                                           ),
        //                                         ),
        //                                         cancel: ElevatedButton.icon(
        //                                           onPressed: () => Get.back(),
        //                                           icon: Icon(Icons.close,
        //                                               color: Colors.white),
        //                                           label: Text("إلغاء",
        //                                               style: TextStyle(
        //                                                   color: Colors.white)),
        //                                           style:
        //                                               ElevatedButton.styleFrom(
        //                                             backgroundColor:
        //                                                 Colors.grey[600],
        //                                             shape:
        //                                                 RoundedRectangleBorder(
        //                                               borderRadius:
        //                                                   BorderRadius.circular(
        //                                                       10),
        //                                             ),
        //                                           ),
        //                                         ),
        //                                         radius: 15,
        //                                       );
        //                                     },
        //                                   ),
        //                                 )
        //                               : SizedBox();
        //                     } else {
        //                       return controller.videoFiles.isNotEmpty &&
        //                               !controller.downloading.value
        //                           ? Padding(
        //                               padding: const EdgeInsets.all(5.0),
        //                               child: Column(
        //                                 children: [
        //                                   Container(
        //                                     decoration: BoxDecoration(
        //                                       borderRadius:
        //                                           BorderRadius.circular(20),
        //                                       color: AppColor.DeepPurple2,
        //                                     ),
        //                                     child: Padding(
        //                                       padding:
        //                                           const EdgeInsets.all(8.0),
        //                                       child: DropdownButton<String>(
        //                                         dropdownColor:
        //                                             AppColor.DeepPurple2,
        //                                         focusColor: AppColor.DeepPurple,
        //                                         iconEnabledColor:
        //                                             AppColor.DeepPurple,
        //                                         hint: Text(
        //                                           'اختر دقة الفيديو',
        //                                           style: TextStyle(
        //                                               color: Colors.white),
        //                                         ),
        //                                         value: controller
        //                                                     .selectedQuality
        //                                                     .value
        //                                                     .isNotEmpty &&
        //                                                 controller
        //                                                         .selectedQuality
        //                                                         .value !=
        //                                                     ''
        //                                             ? controller
        //                                                 .selectedQuality.value
        //                                             : null,
        //                                         items: controller.videoFiles
        //                                             .map((video) {
        //                                           return DropdownMenuItem<
        //                                               String>(
        //                                             value: video['resolution'],
        //                                             child: Text(
        //                                               video['resolution'],
        //                                               style: TextStyle(
        //                                                   color: Colors.white),
        //                                             ),
        //                                           );
        //                                         }).toList(),
        //                                         onChanged: (String? newValue) {
        //                                           controller.selectedQuality
        //                                               .value = newValue!;
        //                                           controller.loadVideoPath();
        //                                         },
        //                                       ),
        //                                     ),
        //                                   ),
        //                                   SizedBox(height: 10),
        //                                   Row(
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.center,
        //                                     children: [
        //                                       if (!controller
        //                                               .isVideoDownloadedVar
        //                                               .value &&
        //                                           !controller.downloading.value)
        //                                         ElevatedButton.icon(
        //                                           style:
        //                                               ElevatedButton.styleFrom(
        //                                             backgroundColor:
        //                                                 AppColor.DeepPurple,
        //                                             padding:
        //                                                 EdgeInsets.symmetric(
        //                                                     horizontal: 20,
        //                                                     vertical: 10),
        //                                             shape:
        //                                                 RoundedRectangleBorder(
        //                                               borderRadius:
        //                                                   BorderRadius.circular(
        //                                                       15),
        //                                             ),
        //                                           ),
        //                                           icon: Icon(Icons.download,
        //                                               color: Colors.white),
        //                                           label: Text(
        //                                             "تحميل الفيديو",
        //                                             style: TextStyle(
        //                                                 color: Colors.white),
        //                                           ),
        //                                           onPressed: () async {
        //                                             String resolution =
        //                                                 controller
        //                                                     .selectedQuality
        //                                                     .value;
        //                                             if (resolution.isEmpty) {
        //                                               Get.snackbar("تنبيه",
        //                                                   "يرجى اختيار دقة أولاً",
        //                                                   backgroundColor:
        //                                                       Colors.orange);
        //                                               return;
        //                                             }

        //                                             final video = controller
        //                                                 .videoFiles
        //                                                 .firstWhere(
        //                                               (video) =>
        //                                                   video['resolution'] ==
        //                                                   resolution,
        //                                               orElse: () => null,
        //                                             );
        //                                             if (video == null) {
        //                                               Get.snackbar("خطأ",
        //                                                   "الرابط غير موجود",
        //                                                   backgroundColor:
        //                                                       Colors.red);
        //                                               return;
        //                                             }

        //                                             String url =
        //                                                 '${AppLink.baseUrl}/' +
        //                                                     video['videoPath'];

        //                                             try {
        //                                               await controller
        //                                                   .downloadFile(
        //                                                       url, resolution);
        //                                             } catch (e) {
        //                                               Get.snackbar("خطأ",
        //                                                   "فشل تحميل الفيديو",
        //                                                   backgroundColor:
        //                                                       Colors.red);
        //                                             }
        //                                           },
        //                                         ),
        //                                       if (controller
        //                                               .isVideoDownloadedVar
        //                                               .value &&
        //                                           !controller.isError.value)
        //                                         Padding(
        //                                           padding:
        //                                               const EdgeInsets.only(
        //                                                   right: 10.0),
        //                                           child: ElevatedButton.icon(
        //                                               style: ElevatedButton
        //                                                   .styleFrom(
        //                                                 backgroundColor:
        //                                                     Colors.red,
        //                                                 padding: EdgeInsets
        //                                                     .symmetric(
        //                                                         horizontal: 20,
        //                                                         vertical: 10),
        //                                                 shape:
        //                                                     RoundedRectangleBorder(
        //                                                   borderRadius:
        //                                                       BorderRadius
        //                                                           .circular(15),
        //                                                 ),
        //                                               ),
        //                                               icon: Icon(Icons.delete,
        //                                                   color: Colors.white),
        //                                               label: Text(
        //                                                 "حذف الفيديو",
        //                                                 style: TextStyle(
        //                                                     color:
        //                                                         Colors.white),
        //                                               ),
        //                                               onPressed: () {
        //                                                 Get.defaultDialog(
        //                                                   title: "تأكيد الحذف",
        //                                                   titleStyle: TextStyle(
        //                                                     color:
        //                                                         Colors.red[800],
        //                                                     fontWeight:
        //                                                         FontWeight.bold,
        //                                                     fontSize: 20,
        //                                                   ),
        //                                                   middleText:
        //                                                       "هل أنت متأكد أنك تريد حذف الفيديو؟",
        //                                                   middleTextStyle:
        //                                                       TextStyle(
        //                                                           fontSize: 16),
        //                                                   confirm:
        //                                                       ElevatedButton
        //                                                           .icon(
        //                                                     onPressed:
        //                                                         () async {
        //                                                       Get.back();
        //                                                       try {
        //                                                         final success =
        //                                                             await controller.deleteVideoFromStorage(controller
        //                                                                 .selectedQuality
        //                                                                 .value);

        //                                                         if (success) {
        //                                                           Get.snackbar(
        //                                                               "نجاح",
        //                                                               "تم الحذف بنجاح");
        //                                                         } else {
        //                                                           Get.snackbar(
        //                                                               "فشل",
        //                                                               "فشل في حذف الفيديو أو أنه غير موجود",
        //                                                               backgroundColor:
        //                                                                   Colors
        //                                                                       .red);
        //                                                         }

        //                                                         controller
        //                                                             .loadVideoPlayer(
        //                                                                 true);
        //                                                       } catch (e) {}
        //                                                     },
        //                                                     icon: Icon(
        //                                                         Icons.check,
        //                                                         color: Colors
        //                                                             .white),
        //                                                     label: Text("نعم",
        //                                                         style: TextStyle(
        //                                                             color: Colors
        //                                                                 .white)),
        //                                                     style:
        //                                                         ElevatedButton
        //                                                             .styleFrom(
        //                                                       backgroundColor:
        //                                                           Colors
        //                                                               .red[700],
        //                                                       shape:
        //                                                           RoundedRectangleBorder(
        //                                                         borderRadius:
        //                                                             BorderRadius
        //                                                                 .circular(
        //                                                                     10),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   cancel: ElevatedButton
        //                                                       .icon(
        //                                                     onPressed: () =>
        //                                                         Get.back(),
        //                                                     icon: Icon(
        //                                                         Icons.close,
        //                                                         color: Colors
        //                                                             .white),
        //                                                     label: Text("إلغاء",
        //                                                         style: TextStyle(
        //                                                             color: Colors
        //                                                                 .white)),
        //                                                     style:
        //                                                         ElevatedButton
        //                                                             .styleFrom(
        //                                                       backgroundColor:
        //                                                           Colors.grey[
        //                                                               600],
        //                                                       shape:
        //                                                           RoundedRectangleBorder(
        //                                                         borderRadius:
        //                                                             BorderRadius
        //                                                                 .circular(
        //                                                                     10),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   radius: 15,
        //                                                 );
        //                                               }),
        //                                         )
        //                                     ],
        //                                   ),
        //                                 ],
        //                               ),
        //                             )
        //                           : SizedBox();
        //                     }
        //                   }),
        //                 ],
        //               ),
        //             ),
        //       Expanded(
        //         child: CommentsWidget(
        //           lessonId: lessonId.toString(),
        //           type: 'lesson_lecture_file',
        //         ),
        //       ),
        //     ],
        //   );
        // }),
      ),
    );
  }

  T getValueForScreenType<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
  }) {
    return MediaQuery.of(context).size.width < 600
        ? mobile
        : (tablet ?? mobile);
  }
}
