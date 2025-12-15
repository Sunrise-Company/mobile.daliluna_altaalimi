import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytd;
import 'dart:math';

class DownloadOption {
  final String label;
  final ytd.StreamInfo streamInfo;
  final ytd.VideoOnlyStreamInfo? videoStream;
  final ytd.AudioOnlyStreamInfo? audioStream;

  DownloadOption.muxed(ytd.MuxedStreamInfo stream)
      : streamInfo = stream,
        videoStream = null,
        audioStream = null,
        label =
            '${stream.videoResolution.height}p - ${_formatBytes(stream.size.totalBytes)}';

  DownloadOption.separate(
      ytd.VideoOnlyStreamInfo video, ytd.AudioOnlyStreamInfo audio)
      : streamInfo = video,
        videoStream = video,
        audioStream = audio,
        label =
            '${video.videoResolution.height}p - ${_formatBytes(video.size.totalBytes + audio.size.totalBytes)} (MP4)';

  bool get isMuxed => videoStream == null;

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    final i = (log(bytes) / log(1024)).floor();
    final sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${sizes[i]}';
  }
}

enum DownloadStatus { none, downloading, merging, completed, failed }

class DownloadTask {
  final String videoId;
  double progress;
  DownloadStatus status;
  String statusText;

  DownloadTask({
    required this.videoId,
    this.progress = 0.0,
    this.status = DownloadStatus.none,
    this.statusText = '',
  });
}

class DownloadService {
  DownloadService._privateConstructor();
  static final DownloadService _instance =
      DownloadService._privateConstructor();
  static DownloadService get instance => _instance;

  final Dio _dio = Dio();
  final Map<String, DownloadTask> _tasks = {};
  final _progressController =
      StreamController<Map<String, DownloadTask>>.broadcast();

  Stream<Map<String, DownloadTask>> get progressStream =>
      _progressController.stream;

  static const _muxChannel = MethodChannel('com.example.muxer');

  DownloadTask? getTask(String videoId) {
    return _tasks[videoId];
  }

  Future<void> startDownload(String videoId, DownloadOption option) async {
    if (_tasks[videoId]?.status == DownloadStatus.downloading ||
        _tasks[videoId]?.status == DownloadStatus.merging) {
      return;
    }

    final task = DownloadTask(
        videoId: videoId,
        status: DownloadStatus.downloading,
        statusText: 'Starting download...');
    _tasks[videoId] = task;
    _notifyUpdates();

    try {
      final outPath = await _getLocalFilePath(videoId);

      if (option.isMuxed) {
        await _downloadUrl(option.streamInfo.url.toString(), outPath,
            (received, total) {
          task.progress = received / total;
          task.statusText =
              'Downloading... ${(task.progress * 100).toStringAsFixed(0)}%';
          _notifyUpdates();
        });
      } else {
        final v = option.videoStream!;
        final a = option.audioStream!;
        final vTmp = '$outPath.video.tmp';
        final aTmp = '$outPath.audio.tmp';
        final totalSize = v.size.totalBytes + a.size.totalBytes;

        task.statusText = 'Downloading video...';
        _notifyUpdates();
        await _downloadUrl(v.url.toString(), vTmp, (received, total) {
          task.progress = received / totalSize;
          task.statusText =
              'Downloading video... ${(task.progress * 100).toStringAsFixed(0)}%';
          _notifyUpdates();
        });

        task.statusText = 'Downloading audio...';
        _notifyUpdates();
        await _downloadUrl(a.url.toString(), aTmp, (received, total) {
          task.progress = (v.size.totalBytes + received) / totalSize;
          task.statusText =
              'Downloading audio... ${(task.progress * 100).toStringAsFixed(0)}%';
          _notifyUpdates();
        });

        task.status = DownloadStatus.merging;
        task.statusText = 'Merging tracks...';
        _notifyUpdates();

        await _muxMp4(vTmp, aTmp, outPath);
        await File(vTmp)
            .delete()
            .catchError((e) {});
        await File(aTmp)
            .delete()
            .catchError((e) {});
      }

      task.status = DownloadStatus.completed;
      task.statusText = 'Download complete!';
      _notifyUpdates();

      Future.delayed(const Duration(seconds: 5), () {
        if (_tasks[videoId]?.status == DownloadStatus.completed) {
          _tasks.remove(videoId);
          _notifyUpdates();
        }
      });
    } catch (e, stack) {
      task.status = DownloadStatus.failed;
      task.statusText = 'Download failed.';
      _notifyUpdates();
      Future.delayed(const Duration(seconds: 5), () {
        if (_tasks[videoId]?.status == DownloadStatus.failed) {
          _tasks.remove(videoId);
          _notifyUpdates();
        }
      });
    }
  }

  Future<void> _downloadUrl(
      String url, String path, Function(int, int) onProgress) async {
    await _dio.download(url, path, onReceiveProgress: onProgress);
  }

  Future<String> _getLocalFilePath(String videoId) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$videoId.mp4';
  }

  Future<void> _muxMp4(
      String videoPath, String audioPath, String outPath) async {
    await _muxChannel.invokeMethod('mux', {
      'video': videoPath,
      'audio': audioPath,
      'out': outPath,
    });
  }

  void _notifyUpdates() {
    if (!_progressController.isClosed) {
      _progressController.add(Map.from(_tasks));
    }
  }

  void dispose() {
    _progressController.close();
  }
}
