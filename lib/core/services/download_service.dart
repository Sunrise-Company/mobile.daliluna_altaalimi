// import 'dart:io';

import 'dart:io';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

enum DownloadState { none, downloading, downloaded, failed }

class DownloadStatus {
  final Rx<DownloadState> state;
  final RxDouble progress;
  final RxString statusText;

  DownloadStatus({
    DownloadState initialState = DownloadState.none,
    double initialProgress = 0.0,
    String text = '',
  }) : state = initialState.obs,
       progress = initialProgress.obs,
       statusText = text.obs;
}

class _DownloadOption {
  final String label;
  final bool isMuxed;
  final yt.StreamInfo streamInfo;
  final yt.AudioOnlyStreamInfo? audioStream;

  _DownloadOption.muxed(yt.MuxedStreamInfo stream)
    : streamInfo = stream,
      audioStream = null,
      isMuxed = true,
      label =
          '${stream.videoResolution.height}p - ${_formatBytes(stream.size.totalBytes)}';

  _DownloadOption.separate(
    yt.VideoOnlyStreamInfo video,
    yt.AudioOnlyStreamInfo audio,
  ) : streamInfo = video,
      audioStream = audio,
      isMuxed = false,
      label =
          '${video.videoResolution.height}p - ${_formatBytes(video.size.totalBytes + audio.size.totalBytes)} (فيديو + صوت)';

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    final i = (log(bytes) / log(1024)).floor();
    final sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${sizes[i]}';
  }
}

class DownloadController extends GetxController {
  final RxMap<String, DownloadStatus> downloadStatusMap =
      <String, DownloadStatus>{}.obs;
  final Dio _dio = Dio();
  final yt.YoutubeExplode _yt = yt.YoutubeExplode();

  static const _muxChannel = MethodChannel('com.example.muxer');

  @override
  void onInit() {
    super.onInit();
    _checkForExistingDownloads();
  }

  @override
  void onClose() {
    _yt.close();
    super.onClose();
  }

  Future<void> _muxMp4(
    String videoPath,
    String audioPath,
    String outPath,
  ) async {
    try {
      await _muxChannel.invokeMethod('mux', {
        'video': videoPath,
        'audio': audioPath,
        'out': outPath,
      });
      developer.log("Muxing successful");
    } on PlatformException catch (e) {
      developer.log("Failed to mux: '${e.message}'.");
      throw Exception("Failed to mux video and audio");
    }
  }

  void _checkForExistingDownloads() async {
    final dir = await getApplicationDocumentsDirectory();
    final directory = Directory(dir.path);
    final files = directory.listSync();

    for (var file in files) {
      if (file is File && file.path.endsWith('.mp4')) {
        String fileName = file.path.split('/').last.split('.mp4').first;
        if (fileName.startsWith('video_')) {
          String videoId = fileName.replaceFirst('video_', '');
          downloadStatusMap[videoId] = DownloadStatus(
            initialState: DownloadState.downloaded,
            initialProgress: 1.0,
          );
        }
      }
    }
  }

  Future<String> getLocalFilePath(String uniqueId) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/video_$uniqueId.mp4';
  }

  Future<void> startDownload(Map<String, dynamic> videoData) async {
    final String baseVideoId =
        (videoData['id']?.toString() ?? videoData['name']).replaceAll(
          RegExp(r'[^A-Za-z0-9]'),
          '_',
        );

    final List<dynamic>? files = videoData['files'];
    final String? link = videoData['link'];
    final String? singleFilePart = videoData['file'];

    if (files != null && files.isNotEmpty) {
      await _handleDirectDownloadWithQualities(files, baseVideoId);
    } else if (link != null && link.isNotEmpty) {
      if (link.contains('youtube.com') || link.contains('youtu.be')) {
        await _handleYoutubeDownload(link, baseVideoId);
      } else {
        await _handleSingleDirectDownload(link, baseVideoId);
      }
    } else if (singleFilePart != null && singleFilePart.isNotEmpty) {
      final String fullUrl =
          'https://arabicacademic.com/storage/' + singleFilePart;
      await _handleSingleDirectDownload(fullUrl, baseVideoId);
    } else {
      Get.snackbar(
        'خطأ',
        'لا يوجد رابط تحميل صالح لهذا الفيديو',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handleSingleDirectDownload(
    String fullDownloadUrl,
    String baseVideoId,
  ) async {
    final String uniqueId = baseVideoId;

    if (downloadStatusMap[uniqueId]?.state.value == DownloadState.downloading)
      return;

    final String savePath = await getLocalFilePath(uniqueId);
    await _downloadFile(fullDownloadUrl, savePath, uniqueId);
  }

  Future<void> _handleDirectDownloadWithQualities(
    List<dynamic> files,
    String baseVideoId,
  ) async {
    print(files.toString());
    print(baseVideoId);

    final List<dynamic> validFiles = files.where((f) {
      return f is Map && f['resolution'] != null && f['videoPath'] != null;
    }).toList();

    if (validFiles.isEmpty) {
      Get.snackbar(
        'خطأ',
        'لا توجد دقات تحميل صالحة لهذا الفيديو.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    List<String> resolutions = validFiles
        .map((f) => f['resolution'].toString())
        .toList();
    int? selectedIndex = await _showQualityDialog(
      resolutions,
      List.generate(validFiles.length, (i) => i),
    );

    if (selectedIndex != null) {
      final selectedFile = validFiles[selectedIndex];

      final String uniqueId = "${baseVideoId}_${selectedFile['resolution']}";

      if (downloadStatusMap[uniqueId]?.state.value == DownloadState.downloading)
        return;

      final String downloadUrl =
          'https://arabicacademic.com/' + selectedFile['videoPath'];
      final String filePath = await getLocalFilePath(uniqueId);

      await _downloadFile(downloadUrl, filePath, uniqueId);
    }
  }

  Future<void> _handleYoutubeDownload(String url, String videoId) async {
    if (downloadStatusMap[videoId]?.state.value == DownloadState.downloading)
      return;

    try {
      downloadStatusMap[videoId] = DownloadStatus(
        initialState: DownloadState.downloading,
        initialProgress: -1,
        text: 'جلب الدقات...',
      );

      final manifest = await _yt.videos.streamsClient.getManifest(url);
      final List<_DownloadOption> options = [];

      options.addAll(
        manifest.muxed
            .where((s) => s.container == yt.StreamContainer.mp4)
            .map((s) => _DownloadOption.muxed(s)),
      );

      final bestAudio = manifest.audioOnly.withHighestBitrate();
      if (bestAudio != null) {
        options.addAll(
          manifest.videoOnly
              .where((s) => s.container == yt.StreamContainer.mp4)
              .where(
                (v) => !options.any(
                  (o) => o.label.startsWith('${v.videoResolution.height}p'),
                ),
              )
              .map((v) => _DownloadOption.separate(v, bestAudio)),
        );
      }

      downloadStatusMap.remove(videoId);

      if (options.isEmpty) {
        throw Exception("No downloadable streams found.");
      }

      final selectedOption = await _showQualityDialog(
        options.map((o) => o.label).toList(),
        options,
      );

      if (selectedOption != null) {
        await _startFinalDownload(selectedOption, videoId);
      }
    } catch (e, stack) {
      developer.log("Youtube Error: $e", stackTrace: stack);
      downloadStatusMap[videoId] = DownloadStatus(
        initialState: DownloadState.failed,
      );
      Get.snackbar(
        'خطأ',
        'فشل في جلب دقات الفيديو من يوتيوب',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _startFinalDownload(
    _DownloadOption option,
    String videoId,
  ) async {
    final outPath = await getLocalFilePath(videoId);

    downloadStatusMap[videoId] = DownloadStatus(
      initialState: DownloadState.downloading,
    );

    try {
      if (option.isMuxed) {
        await _downloadStream(option.streamInfo.url.toString(), outPath, (
          rec,
          total,
        ) {
          final status = downloadStatusMap[videoId]!;
          status.progress.value = rec / total;
          status.statusText.value =
              'جاري التحميل... ${(status.progress.value * 100).toStringAsFixed(0)}%';
        });
      } else {
        final videoStream = option.streamInfo as yt.VideoOnlyStreamInfo;
        final audioStream = option.audioStream!;
        final vTmp = '$outPath.video.tmp';
        final aTmp = '$outPath.audio.tmp';

        int vRecv = 0, aRecv = 0;
        final totalBytes =
            videoStream.size.totalBytes + audioStream.size.totalBytes;

        final status = downloadStatusMap[videoId]!;

        await Future.wait([
          _downloadStream(videoStream.url.toString(), vTmp, (rec, _) {
            vRecv = rec;
            status.progress.value = (vRecv + aRecv) / totalBytes;
            status.statusText.value =
                'جاري التحميل... ${(status.progress.value * 100).toStringAsFixed(0)}%';
          }),
          _downloadStream(audioStream.url.toString(), aTmp, (rec, _) {
            aRecv = rec;
            status.progress.value = (vRecv + aRecv) / totalBytes;
            status.statusText.value =
                'جاري التحميل... ${(status.progress.value * 100).toStringAsFixed(0)}%';
          }),
        ]);

        status.statusText.value = 'جاري دمج الملفات...';
        status.progress.value = -1;

        await _muxMp4(vTmp, aTmp, outPath);

        await File(vTmp).delete().catchError((_) {});
        await File(aTmp).delete().catchError((_) {});
      }

      downloadStatusMap[videoId]?.state.value = DownloadState.downloaded;
      Get.snackbar(
        'نجاح',
        'تم تحميل الفيديو بنجاح!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e, stack) {
      developer.log("Download/Mux Error: $e", stackTrace: stack);
      downloadStatusMap[videoId] = DownloadStatus(
        initialState: DownloadState.failed,
      );
      Get.snackbar(
        'خطأ',
        'فشل تحميل الفيديو أو دمجه',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );

      final file = File(outPath);
      if (await file.exists()) await file.delete();
    }
  }

  Future<void> _downloadStream(
    String url,
    String path,
    void Function(int, int) onProg,
  ) async {
    await _dio.download(
      url,
      path,
      onReceiveProgress: (rec, total) {
        if (total > 0) onProg(rec, total);
      },
    );
  }

  Future<void> _downloadFile(
    String url,
    String savePath,
    String uniqueId,
  ) async {
    if (downloadStatusMap[uniqueId]?.state.value == DownloadState.downloading)
      return;

    downloadStatusMap[uniqueId] = DownloadStatus(
      initialState: DownloadState.downloading,
    );

    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final status = downloadStatusMap[uniqueId];
            if (status != null) {
              double progress = received / total;
              status.progress.value = progress;
              status.statusText.value =
                  'جاري التحميل... ${(progress * 100).toStringAsFixed(0)}%';
            }
          }
        },
      );
      final status = downloadStatusMap[uniqueId];
      if (status != null) {
        status.state.value = DownloadState.downloaded;
        status.progress.value = 1.0;
      }
      Get.snackbar(
        'نجاح',
        'تم تحميل الفيديو بنجاح!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      developer.log("Download Error for $uniqueId: $e");
      final status = downloadStatusMap[uniqueId];
      if (status != null) {
        status.state.value = DownloadState.failed;
      }
      Get.snackbar(
        'خطأ',
        'فشل تحميل الفيديو',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );

      final file = File(savePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<T?> _showQualityDialog<T>(List<String> options, List<T> values) {
    double dialogContentHeight = 200.0;

    return Get.defaultDialog<T>(
      title: 'اختر الدقة للتحميل',
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      content: SizedBox(
        height: dialogContentHeight,
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(options[index], textAlign: TextAlign.center),
              onTap: () {
                Get.back(result: values[index]);
              },
            );
          },
        ),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text('إلغاء')),
    );
  }

  Future<void> deleteVideo(String videoId) async {
    try {
      final filePath = await getLocalFilePath(videoId);
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        downloadStatusMap.remove(videoId);
        Get.snackbar(
          'تم الحذف',
          'تم حذف الفيديو من جهازك.',
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      developer.log("Delete Error: $e");
      Get.snackbar(
        'خطأ',
        'فشل حذف الفيديو',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
