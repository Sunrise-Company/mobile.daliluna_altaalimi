import 'dart:developer';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:path_provider/path_provider.dart';

import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:better_player/better_player.dart';

// var progressString = ''.obs;
var progressMapLess = <String, String>{}.obs;

class VideoLessonsController extends GetxController {
  late BetterPlayerController videolessonsController;

  // Rx variables for Obx
  var downloading = false.obs;
  var progress = 0.0.obs;
  late List<dynamic> videoFiles;
  var selectedQuality = ''.obs;
  var isLoading = true.obs;
  var isError = false.obs;
  var videoPath = ''.obs;
  Duration? lastPosition;

  var isVideoDownloadedVar = false.obs;

  @override
  void onInit() {
    super.onInit();
    videoFiles = Get.arguments['videoFiles'] ?? [];
    if (videoFiles.isNotEmpty) {
      selectedQuality.value = videoFiles.last['resolution'].toString();
    }
    loadVideoPlayer(true);
  }

  void loadVideoPath() async {
    // إيقاف وتحرير المشغل القديم إذا كان موجودًا
    if (videolessonsController.isVideoInitialized() == true) {
      lastPosition =
          await videolessonsController.videoPlayerController?.position;
      await videolessonsController.pause();
      videolessonsController.dispose();
      developer.log(
        'Old BetterPlayerController disposed for resolution: ${selectedQuality.value}',
      );
    }

    // تحديد ملف الفيديو بناءً على الدقة المختارة
    final videoFile = videoFiles.firstWhere(
      (file) => file['resolution'] == selectedQuality.value,
      orElse: () => videoFiles.first,
    );

    String resolution = selectedQuality.value;
    String url = '${AppLink.baseUrl}/' + videoFile['videoPath'];

    String localPath = await getLocalFilePath(resolution);
    bool exists = await isVideoDownloaded(resolution);
    String finalPath = exists ? localPath : url;

    // التحقق من صحة المسار المحلي
    if (exists) {
      final file = File(localPath);
      if (!await file.exists()) {
        developer.log('Local file does not exist: $localPath');
        exists = false;
        finalPath = url; // الرجوع إلى URL إذا كان الملف المحلي غير موجود
      } else {
        developer.log('Using local file: $localPath');
      }
    }

    videoPath.value = finalPath;
    Get.arguments['url'] = finalPath;

    // تحميل المشغل مع المسار الجديد
    await loadVideoPlayer(!exists);
  }

  // Future<String> downloadFile(String url, String resolution) async {
  //   Dio dio = Dio();
  //   downloading.value = true;
  //   progress.value = 0.0;
  //   // progressString.value = '0%';
  //   final dir = await getApplicationDocumentsDirectory();
  //   final video = videoFiles.firstWhere(
  //     (file) => file['resolution'] == resolution,
  //     orElse: () => null,
  //   );
  //   String videoId =
  //       video != null && video['id'] != null ? video['id'].toString() : url;
  //   final filePath = '${dir.path}/video_${videoId}_$resolution.mp4';

  //   try {
  //     String progressKey = '${videoId}_$resolution';
  //     log('progressKey' + progressKey);
  //     // تهيئة التقدم في progressMapLec
  //     progressMapLess[progressKey] = '0%';

  //     if (await File(filePath).exists()) {
  //       downloading.value = false;
  //       // progressString.value = '100%';
  //       progressMapLess[progressKey] = '100%';
  //       isVideoDownloadedVar.value = true;
  //       Get.snackbar("تنبيه", "الفيديو موجود بالفعل",
  //           backgroundColor: Colors.blue);
  //       return filePath;
  //     }

  //     await dio.download(
  //       url,
  //       filePath,
  //       onReceiveProgress: (rec, total) {
  //         progress.value = rec / total;
  //         progressMapLess[progressKey] =
  //             ((rec / total) * 100).toStringAsFixed(0) + "%";
  //         developer.log(
  //             'progressKey: ${progressKey} ${progressMapLess[progressKey]}');
  //       },
  //     );

  //     downloading.value = false;
  //     progressMapLess[progressKey] = '100%';
  //     progressMapLess[progressKey] == '100%'
  //         ? isVideoDownloadedVar.value = true
  //         : null;
  //     return filePath;
  //   } catch (e) {
  //     downloading.value = false;
  //     progress.value = 0.0;
  //     progressMapLess['${videoId}_$resolution'] = 'فشل';
  //     developer.log('Download error: $e');
  //     throw e;
  //   }
  // }
  Future<String> downloadFile(String url, String resolution) async {
    Dio dio = Dio();
    CancelToken cancelToken = CancelToken(); // إضافة CancelToken
    downloading.value = true;
    progress.value = 0.0;
    final dir = await getApplicationDocumentsDirectory();
    final video = videoFiles.firstWhere(
      (file) => file['resolution'] == resolution,
      orElse: () => null,
    );
    String videoId = video != null && video['id'] != null
        ? video['id'].toString()
        : url;
    final filePath = '${dir.path}/video_${videoId}_$resolution.mp4';
    String progressKey = '${videoId}_$resolution';
    progressMapLess[progressKey] = '0%';

    try {
      if (await File(filePath).exists()) {
        downloading.value = false;
        progressMapLess[progressKey] = '100%';
        isVideoDownloadedVar.value = true;
        Get.snackbar(
          "تنبيه",
          "الفيديو موجود بالفعل",
          backgroundColor: Colors.blue,
        );
        return filePath;
      }

      await dio.download(
        url,
        filePath,
        cancelToken: cancelToken, // تمرير CancelToken
        onReceiveProgress: (rec, total) {
          progress.value = rec / total;
          progressMapLess[progressKey] =
              ((rec / total) * 100).toStringAsFixed(0) + "%";
          developer.log(
            'progressKey: ${progressKey} ${progressMapLess[progressKey]}',
          );
        },
      );

      downloading.value = false;
      progressMapLess[progressKey] = '100%';
      isVideoDownloadedVar.value = true;
      return filePath;
    } catch (e) {
      downloading.value = false;
      progress.value = 0.0;
      progressMapLess['${videoId}_$resolution'] = 'فشل';
      developer.log('Download error: $e');
      throw e;
    } finally {
      cancelToken.cancel(); // إلغاء التحميل عند الانتهاء أو الفشل
    }
  }

  Future<String> getLocalFilePath(String resolution) async {
    final video = videoFiles.firstWhere(
      (file) => file['resolution'] == resolution,
      orElse: () => null,
    );
    String videoId = video != null && video['id'] != null
        ? video['id'].toString()
        : Get.arguments['url'];
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/video_${videoId}_$resolution.mp4';
  }

  Future<void> loadVideoPlayer(bool isUrl) async {
    developer.log(
      'Loading video player with URL: ${Get.arguments['url']}, isUrl: $isUrl',
    );
    isLoading.value = true;

    String resolution = selectedQuality.value;
    bool isDownloaded = await isVideoDownloaded(resolution);
    String videoUrl = Get.arguments['url'];

    try {
      isError.value = false;

      // إعداد مصدر البيانات
      BetterPlayerDataSource dataSource;
      if (isDownloaded) {
        dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          await getLocalFilePath(resolution),
        );
        developer.log(
          'Data source set to local file: ${await getLocalFilePath(resolution)}',
        );
      } else {
        dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          videoUrl,
          cacheConfiguration: BetterPlayerCacheConfiguration(
            useCache: true,
            maxCacheSize: 10 * 1024 * 1024, // 10 ميجابايت
            maxCacheFileSize: 10 * 1024 * 1024,
          ),
        );
        developer.log('Data source set to network URL: $videoUrl');
      }

      // إنشاء مثيل جديد للمشغل
      videolessonsController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: false,
          looping: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            progressBarPlayedColor: Colors.blue,
            progressBarHandleColor: Colors.grey,
            progressBarBackgroundColor: Colors.grey.withOpacity(0.2),
            enableSkips: true,
            enableFullscreen: true,
            enablePip: true,
            enablePlayPause: true,
            enableMute: true,
            enableAudioTracks: false,
            enableSubtitles: false,
            enableQualities: false,
            enableProgressText: true,
          ),
        ),
        betterPlayerDataSource: dataSource,
      );

      // إضافة مستمع للأحداث
      videolessonsController.addEventsListener((event) async {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          isLoading.value = false;
          if (lastPosition != null) {
            videolessonsController.seekTo(lastPosition!);
            developer.log('Seeked to last position: $lastPosition');
          }
          developer.log('Video player initialized successfully');
        } else if (event.betterPlayerEventType ==
            BetterPlayerEventType.exception) {
          isError.value = true;
          isLoading.value = false;
          developer.log('Video player error: ${event.parameters} ${videoUrl}');
          final video = videoFiles.firstWhere(
            (file) => file['resolution'] == resolution,
            orElse: () => null,
          );
          String videoId = video != null && video['id'] != null
              ? video['id'].toString()
              : videoUrl;

          String progressKey = '${videoId}_$resolution';
          if (isError.value == true &&
              isVideoDownloadedVar.value == true &&
              progressMapLess[progressKey] == null) {
            final success = await deleteVideoFromStorage(resolution);

            if (success) {
              Get.snackbar("فشل", "فشل في تنزيل الفيديو الرجاء لمحاولة مجدداً");
            } else {
              Get.snackbar(
                "فشل",
                "فشل في حذف الفيديو أو أنه غير موجود",
                backgroundColor: Colors.red,
              );
            }
          }
        }
      });

      // تهيئة مصدر البيانات
      await videolessonsController.setupDataSource(dataSource);
      developer.log('Data source set up successfully');
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      developer.log('Video loading error: $e');
    }
  }

  // Future<void> deleteVideoFromStorage(String resolution) async {
  //   try {
  //     final filePath = await getLocalFilePath(resolution);
  //     final file = File(filePath);

  //     if (await file.exists()) {
  //       await file.delete();
  //       isVideoDownloadedVar.value = false;
  //       Get.snackbar(
  //         "نجاح",
  //         "تم الحذف بنجاح",
  //       );
  //       developer.log('Video deleted: $filePath');
  //     } else {
  //       Get.snackbar("تنبيه", "الفيديو غير موجود في التخزين",
  //           backgroundColor: Colors.orange);
  //       developer.log('Video not found: $filePath');
  //     }

  //     loadVideoPath();
  //   } catch (e) {
  //     Get.snackbar("خطأ", "فشل في حذف الفيديو", backgroundColor: Colors.red);
  //     developer.log('Delete error: $e');
  //   }
  // }
  Future<bool> deleteVideoFromStorage(String resolution) async {
    try {
      final filePath = await getLocalFilePath(resolution);
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        isVideoDownloadedVar.value = false;
        developer.log('Video deleted: $filePath');
        loadVideoPath();
        return true; // تم الحذف بنجاح
      } else {
        developer.log('Video not found: $filePath');
        loadVideoPath();
        return false; // لم يتم الحذف لأن الملف غير موجود
      }
    } catch (e) {
      developer.log('Delete error: $e');
      return false; // حدث خطأ أثناء الحذف
    }
  }

  Future<bool> isVideoDownloaded(String resolution) async {
    final filePath = await getLocalFilePath(resolution);
    final exists = await File(filePath).exists();
    developer.log('isVideoDownloaded: $exists for $filePath');
    isVideoDownloadedVar.value = exists;
    return exists;
  }

  @override
  void dispose() {
    onClose();
    super.dispose();
  }

  @override
  void onClose() {
    developer.log('Closing VideoLessonsController');
    videolessonsController.dispose();
    super.onClose();
  }
}

//Chewieeee
// class VideoLessonsController extends GetxController {
//   late VideoPlayerController videolessonsController;
//   late ChewieController chewieController;

//   // متغيرات Rx لدعم Obx
//   var downloading = false.obs;
//   var progress = 0.0.obs;
//   var progressString = ''.obs;
//   late List<dynamic> videoFiles;
//   var selectedQuality = ''.obs;
//   var isLoading = true.obs;
//   var isError = false.obs;
//   var videoPath = ''.obs;
//   Duration? lastPosition;

//   var isVideoDownloadedVar = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     videoFiles = Get.arguments['videoFiles'];
//     if (videoFiles.length > 0)
//       selectedQuality.value = videoFiles.last['resolution'].toString();
//     loadVideoPlayer(true);
//   }

//   void loadVideoPath() async {
//     if (videolessonsController.value.isInitialized) {
//       lastPosition = videolessonsController.value.position;
//     }

//     final videoFile = videoFiles.firstWhere(
//       (file) => file['resolution'] == selectedQuality.value,
//       orElse: () => videoFiles.first,
//     );

//     String resolution = selectedQuality.value;
//     String url = '${AppLink.baseUrl}/' + videoFile['videoPath'];
//     String localPath = await getLocalFilePath(resolution);
//     bool exists = await isVideoDownloaded(resolution);
//     String finalPath = exists ? localPath : url;

//     videoPath.value = finalPath;
//     Get.arguments['url'] = finalPath;

//     if (chewieController.videoPlayerController.value.isInitialized) {
//       chewieController.pause();
//       videolessonsController.pause();
//     }

//     loadVideoPlayer(!exists);
//   }

//   Future<String> downloadFile(String url, String resolution) async {
//     Dio dio = Dio();
//     downloading.value = true;
//     progress.value = 0.0;
//     progressString.value = '0%';

//     try {
//       final dir = await getApplicationDocumentsDirectory();
//       final video = videoFiles.firstWhere(
//         (file) => file['resolution'] == resolution,
//         orElse: () => null,
//       );
//       String videoId =
//           video != null && video['id'] != null ? video['id'].toString() : url;
//       final filePath = '${dir.path}/video_${videoId}_$resolution.mp4';

//       if (await File(filePath).exists()) {
//         downloading.value = false;
//         progressString.value = '100%';
//         isVideoDownloadedVar.value = true;
//         Get.snackbar("تنبيه", "الفيديو موجود بالفعل",
//             backgroundColor: Colors.blue);
//         return filePath;
//       }

//       await dio.download(
//         url,
//         filePath,
//         onReceiveProgress: (rec, total) {
//           progress.value = rec / total;
//           progressString.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
//           developer.log('Progress: ${progressString.value}');
//         },
//       );

//       downloading.value = false;
//       progressString.value = '100%';
//       isVideoDownloadedVar.value = true;
//       return filePath;
//     } catch (e) {
//       downloading.value = false;
//       progress.value = 0.0;
//       progressString.value = 'فشل';
//       developer.log('Download error: $e');
//       throw e;
//     }
//   }

//   Future<String> getLocalFilePath(String resolution) async {
//     final video = videoFiles.firstWhere(
//       (file) => file['resolution'] == resolution,
//       orElse: () => null,
//     );
//     String videoId = video != null && video['id'] != null
//         ? video['id'].toString()
//         : Get.arguments['url'];
//     final dir = await getApplicationDocumentsDirectory();
//     return '${dir.path}/video_${videoId}_$resolution.mp4';
//   }

//   Future<void> loadVideoPlayer(bool isUrl) async {
//     developer.log('url: ${Get.arguments['url']}');
//     isLoading.value = true;

//     String resolution = selectedQuality.value;
//     bool isDownloaded = await isVideoDownloaded(resolution);
//     String videoUrl = Get.arguments['url'];

//     try {
//       isError.value = false;
//       if (isDownloaded) {
//         videolessonsController = VideoPlayerController.file(
//             File(await getLocalFilePath(resolution)));
//       } else {
//         videolessonsController = VideoPlayerController.network(videoUrl);
//       }

//       chewieController = ChewieController(
//         videoPlayerController: videolessonsController,
//         autoPlay: false,
//         looping: true,
//         cupertinoProgressColors: ChewieProgressColors(
//           handleColor: Colors.grey,
//         ),
//         materialProgressColors: ChewieProgressColors(),
//       );

//       videolessonsController.addListener(() {
//         if (videolessonsController.value.isInitialized) {
//           isLoading.value = false;
//         }
//       });

//       await videolessonsController.initialize();
//       if (lastPosition != null) {
//         await videolessonsController.seekTo(lastPosition!);
//       }
//     } catch (e) {
//       isLoading.value = false;
//       isError.value = true;
//       developer.log('Video loading error: $e');
//     }
//   }

//   Future<void> deleteVideoFromStorage(String resolution) async {
//     try {
//       final filePath = await getLocalFilePath(resolution);
//       final file = File(filePath);

//       if (await file.exists()) {
//         await file.delete();
//         isVideoDownloadedVar.value = false;
//         Get.snackbar(
//           "نجاح",
//           "تم حذف الفيديو بنجاح",
//         );
//         developer.log('Video deleted: $filePath');
//       } else {
//         Get.snackbar("تنبيه", "الفيديو غير موجود في التخزين",
//             backgroundColor: Colors.orange);
//         developer.log('Video not found: $filePath');
//       }

//       loadVideoPath();
//     } catch (e) {
//       Get.snackbar("خطأ", "فشل في حذف الفيديو", backgroundColor: Colors.red);
//       developer.log('Delete error: $e');
//     }
//   }

//   Future<bool> isVideoDownloaded(String resolution) async {
//     final filePath = await getLocalFilePath(resolution);
//     final exists = await File(filePath).exists();
//     developer.log('isVideoDownloaded: $exists for $filePath');
//     isVideoDownloadedVar.value = exists;
//     return exists;
//   }

//   @override
//   void dispose() {
//     onClose();
//     super.dispose();
//   }

//   @override
//   void onClose() {
//     developer.log('Closing VideoLessonsController');
//     videolessonsController.dispose();
//     chewieController.dispose();
//     super.onClose();
//   }
// }
