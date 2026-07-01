import 'dart:io';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/linkapi.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:developer' as developer;

var progressMapLec = <String, String>{}.obs;

class VideoLecturesController extends GetxController {
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
    videoFiles = Get.arguments['videoFiles'];

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

    final videoFile = videoFiles.firstWhere(
      (file) => file['resolution'] == selectedQuality.value,
      orElse: () => videoFiles.first,
    );

    String resolution = selectedQuality.value;
    String url = '${AppLink.baseUrl}/' + videoFile['videoPath'];
    String localPath = await getLocalFilePath(resolution);
    bool exists = await isVideoDownloaded(resolution);

    String finalPath = exists ? localPath : url;

    videoPath.value = finalPath;
    Get.arguments['url'] = finalPath;

    if (Platform.isIOS) {
      videoPlayerController?.pause();
    } else {
      betterPlayerController?.pause();
    }
    loadVideoPlayer(!exists);
  }

  Future<void> loadVideoPlayer(bool isUrl) async {
    developer.log('url: ${Get.arguments['url']}');
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
            playedColor: Colors.deepPurple,
            handleColor: Colors.grey,
            bufferedColor: Colors.grey.shade300,
          ),
          placeholder: const Center(child: CircularProgressIndicator()),
          autoInitialize: true,
        );

        if (lastPosition != null) {
          await videoPlayerController!.seekTo(lastPosition!);
        }
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
      isError.value = true;
      isLoading.value = false;
      developer.log('Video loading error: $e');
    }
  }

  Future<bool> deleteVideoFromStorage(String resolution) async {
    try {
      final filePath = await getLocalFilePath(resolution);
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        isVideoDownloadedVar.value = false;
        developer.log('Video deleted: $filePath');
        loadVideoPath();
        return true;
      } else {
        developer.log('Video not found: $filePath');
        loadVideoPath();
        return false;
      }
    } catch (e) {
      developer.log('Delete error: $e');
      return false;
    }
  }

  Future<String> downloadFile(String url, String resolution) async {
    Dio dio = Dio();
    downloading.value = true;
    progress.value = 0.0;

    try {
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

      progressMapLec[progressKey] = '0%';

      if (await File(filePath).exists()) {
        downloading.value = false;
        progressMapLec[progressKey] = '100%';
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
        onReceiveProgress: (rec, total) {
          progress.value = rec / total;
          progressMapLec[progressKey] =
              ((rec / total) * 100).toStringAsFixed(0) + "%";
          developer.log(
            'Progress for $progressKey: ${progressMapLec[progressKey]}',
          );
        },
      );

      downloading.value = false;
      isVideoDownloadedVar.value = true;
      progressMapLec[progressKey] = '100%';
      return filePath;
    } catch (e) {
      final video = videoFiles.firstWhere(
        (file) => file['resolution'] == resolution,
        orElse: () => null,
      );

      String videoId = video != null && video['id'] != null
          ? video['id'].toString()
          : url;
      downloading.value = false;
      progress.value = 0.0;
      progressMapLec['${videoId}_$resolution'] = 'فشل';
      developer.log('Download error: $e');
      throw e;
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
    developer.log('Closing VideoLecturesController');
    videoPlayerController?.dispose();
    chewieController?.dispose();
    betterPlayerController?.dispose();
    super.onClose();
  }
}
