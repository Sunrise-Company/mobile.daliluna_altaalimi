import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'dart:io';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:daliluna_altaalimi/controller/videoLectureControllers.dart';
import 'package:daliluna_altaalimi/view/screen/youtube_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:chewie/chewie.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/widget/comments_widget.dart';

class VideoLecture extends GetView<VideoLecturesController> {
  bool _isYoutubeLink(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  @override
  Widget build(BuildContext context) {
    final String url = Get.arguments['url'] as String;
    final int lessonId = Get.arguments['lesson_dep_file_id'];

    if (_isYoutubeLink(url)) {
      String? videoId;
      try {
        videoId = VideoId(url).value;
      } catch (e) {}

      if (videoId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offNamed(
            AppRoute.youtubePlayer,
            arguments: {
              'videoId': videoId,
              'lessonId': lessonId,
              'type': 'lesson_lecture_file',
            },
          );
        });
        return const Scaffold(backgroundColor: Colors.black);
      } else {
        return Scaffold(
          appBar: AppBar(title: const Text("Error")),
          body: const Center(child: Text("Invalid or unsupported video link.")),
        );
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
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        body: Obx(() {
          final video = controller.videoFiles.isNotEmpty
              ? controller.videoFiles.firstWhere(
                  (file) =>
                      file['resolution'] == controller.selectedQuality.value,
                  orElse: () => null,
                )
              : null;
          String videoId = video != null && video['id'] != null
              ? video['id'].toString()
              : Get.arguments['url'];
          String resolution = controller.selectedQuality.value;
          String progressKey = '${videoId}_$resolution';

          if (controller.isError.value &&
              !controller.downloading.value &&
              !controller.isVideoDownloadedVar.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text("فشل تحميل الفيديو"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadVideoPath(),
                    child: const Text("حاول مجدداً"),
                  ),
                ],
              ),
            );
          }

          Widget playerWidget;
          if (Platform.isIOS) {
            playerWidget = controller.chewieController != null
                ? Chewie(controller: controller.chewieController!)
                : const Center(
                    child: Text(
                      "جاري التهيئة...",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
          } else {
            playerWidget = controller.betterPlayerController != null
                ? BetterPlayer(controller: controller.betterPlayerController!)
                : const Center(
                    child: Text(
                      "جاري التهيئة...",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
          }

          return Column(
            children: [
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : playerWidget,
              ),
              if (controller.downloading.value)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: controller.progress.value,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColor.DeepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "جاري التحميل: ${progressMapLec[progressKey] ?? '0%'}",
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              // Quality Selector
              if (controller.videoFiles.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedQuality.value.isNotEmpty
                        ? controller.selectedQuality.value
                        : null,
                    hint: const Text("اختر الجودة"),
                    items: controller.videoFiles.map((v) {
                      return DropdownMenuItem<String>(
                        value: v['resolution'],
                        child: Text(v['resolution']),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedQuality.value = val;
                        controller.loadVideoPath();
                      }
                    },
                  ),
                ),
              const SizedBox(height: 16),
              // Download/Delete Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!controller.isVideoDownloadedVar.value &&
                        !controller.downloading.value)
                      ElevatedButton.icon(
                        onPressed: () async {
                          final res = controller.selectedQuality.value;
                          final v = controller.videoFiles.firstWhere(
                            (e) => e['resolution'] == res,
                            orElse: () => null,
                          );
                          if (v != null) {
                            await controller.downloadFile(
                              '${AppLink.baseUrl}/${v['videoPath']}',
                              res,
                            );
                          } else {
                            await controller.downloadFile(
                              Get.arguments['url'],
                              "",
                            );
                          }
                        },
                        icon: const Icon(Icons.download),
                        label: const Text("تحميل"),
                      ),
                    if (controller.isVideoDownloadedVar.value)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                            title: "حذف الفيديو",
                            middleText: "هل أنت متأكد؟",
                            onConfirm: () async {
                              Get.back();
                              await controller.deleteVideoFromStorage(
                                controller.selectedQuality.value,
                              );
                              controller.loadVideoPlayer(true);
                            },
                            textConfirm: "نعم",
                            textCancel: "إلغاء",
                          );
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("حذف"),
                      ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: CommentsWidget(
                  lessonId: lessonId.toString(),
                  type: 'lesson_lecture_file',
                ),
              ),
            ],
          );
        }),
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
