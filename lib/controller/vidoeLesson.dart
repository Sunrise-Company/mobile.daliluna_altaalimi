import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:dio/dio.dart';
import 'dart:developer' as developer;

// var progressString = ''.obs;
import 'package:better_player_plus/better_player_plus.dart';

var progressMapLess = <String, String>{}.obs;

class VideoLessonsController extends GetxController {
  // Common
  var downloading = false.obs;
  var progress = 0.0.obs;
  late List<dynamic> videoFiles;
  var selectedQuality = ''.obs;
  var isLoading = true.obs;
  var isError = false.obs;
  var videoPath = ''.obs;
  Duration? lastPosition;
  var isVideoDownloadedVar = false.obs;

  // iOS Specific
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  // Android Specific
  BetterPlayerController? betterPlayerController;

  @override
  void onInit() {
    super.onInit();
    videoFiles = Get.arguments['videoFiles'] ?? [];

    String url = Get.arguments['url'] as String;
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return;
    }

    if (videoFiles.isNotEmpty) {
      selectedQuality.value = videoFiles.last['resolution'].toString();
    }
    loadVideoPlayer(true);
  }

  void loadVideoPath() async {
    Duration? currentPos;
    if (Platform.isIOS) {
      if (videoPlayerController?.value.isInitialized == true) {
        currentPos = videoPlayerController?.value.position;
      }
    } else {
      if (betterPlayerController?.videoPlayerController?.value.initialized ==
          true) {
        currentPos =
            betterPlayerController?.videoPlayerController?.value.position;
      }
    }
    lastPosition = currentPos;

    // تحديد ملف الفيديو بناءً على الدقة المختارة
    final videoFile = videoFiles.firstWhere(
      (file) => file['resolution'] == selectedQuality.value,
      orElse: () => videoFiles.isEmpty ? null : videoFiles.first,
    );

    if (videoFile == null &&
        !(Get.arguments['url'] as String).contains('http')) {
      return;
    }

    String resolution = selectedQuality.value;
    String url = videoFile != null
        ? '${AppLink.baseUrl}/' + videoFile['videoPath']
        : Get.arguments['url'];

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
    if (Platform.isIOS) {
      videoPlayerController?.pause();
    } else {
      betterPlayerController?.pause();
    }
    loadVideoPlayer(!exists);
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
      'Loading video player, platform: ${Platform.operatingSystem}',
    );
    isLoading.value = true;
    String resolution = selectedQuality.value;
    bool isDownloaded = await isVideoDownloaded(resolution);
    String videoUrl = Get.arguments['url'];

    try {
      isError.value = false;

      // Dispose existing
      videoPlayerController?.dispose();
      chewieController?.dispose();
      betterPlayerController?.dispose();

      if (Platform.isIOS) {
        // iOS: VideoPlayer + Chewie
        if (isDownloaded) {
          videoPlayerController = VideoPlayerController.file(
            File(await getLocalFilePath(resolution)),
          );
        } else {
          videoPlayerController = VideoPlayerController.networkUrl(
            Uri.parse(videoUrl),
          );
        }
        await videoPlayerController!.initialize();

        chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: true,
          looping: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.blue,
            handleColor: Colors.grey,
          ),
          placeholder: const Center(child: CircularProgressIndicator()),
          autoInitialize: true,
        );

        if (lastPosition != null) {
          await videoPlayerController!.seekTo(lastPosition!);
        }

        videoPlayerController!.addListener(() async {
          if (videoPlayerController!.value.isInitialized) {
            isLoading.value = false;
          }

          if (videoPlayerController!.value.hasError) {
            isError.value = true;
            isLoading.value = false;
            developer.log(
              'Video player error: ${videoPlayerController!.value.errorDescription} ${videoUrl}',
            );

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
                Get.snackbar(
                  "فشل",
                  "فشل في تنزيل الفيديو الرجاء لمحاولة مجدداً",
                );
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
      } else {
        // Android: BetterPlayer
        BetterPlayerDataSource dataSource;
        if (isDownloaded) {
          dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            await getLocalFilePath(resolution),
          );
        } else {
          dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            videoUrl,
          );
        }

        betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(
            autoPlay: true,
            looping: true,
            fullScreenByDefault: false,
            allowedScreenSleep: false,
            fit: BoxFit.contain,
          ),
          betterPlayerDataSource: dataSource,
        );

        if (lastPosition != null) {
          await betterPlayerController!.seekTo(lastPosition!);
        }
      }

      isLoading.value = false;
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
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
