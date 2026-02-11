import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytd;
import 'package:daliluna_altaalimi/background_download_service.dart';
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
    ytd.VideoOnlyStreamInfo video,
    ytd.AudioOnlyStreamInfo audio,
  ) : streamInfo = video,
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

enum DownloadStatus { none, downloading, merging, completed, failed, paused }

class DownloadTask {
  final String videoId;
  String? videoName; // اسم الفيديو للعرض
  double progress;
  DownloadStatus status;
  String statusText;
  int retryCount;
  String? videoUrl;
  String? audioUrl;
  bool isMuxed;
  DateTime? startTime;
  int downloadedBytes; // إضافة حقل لتتبع البيانات المحملة
  int totalBytes; // إضافة حقل لحجم الملف الكامل
  int? audioDownloadedBytes; // للتحميلات المنفصلة
  int? audioTotalBytes; // للتحميلات المنفصلة
  String? qualityLabel; // لتذكر الدقة المختارة عند التجديد

  DownloadTask({
    required this.videoId,
    this.videoName,
    this.progress = 0.0,
    this.status = DownloadStatus.none,
    this.statusText = '',
    this.retryCount = 0,
    this.videoUrl,
    this.audioUrl,
    this.isMuxed = true,
    this.startTime,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.audioDownloadedBytes,
    this.audioTotalBytes,
    this.qualityLabel,
  });

  Map<String, dynamic> toJson() => {
    'videoId': videoId,
    'videoName': videoName,
    'progress': progress,
    'status': status.index,
    'statusText': statusText,
    'retryCount': retryCount,
    'videoUrl': videoUrl,
    'audioUrl': audioUrl,
    'isMuxed': isMuxed,
    'startTime': startTime?.toIso8601String(),
    'downloadedBytes': downloadedBytes,
    'totalBytes': totalBytes,
    'audioDownloadedBytes': audioDownloadedBytes,
    'audioTotalBytes': audioTotalBytes,
    'qualityLabel': qualityLabel,
  };

  factory DownloadTask.fromJson(Map<String, dynamic> json) => DownloadTask(
    videoId: json['videoId'],
    videoName: json['videoName'],
    progress: json['progress'] ?? 0.0,
    status: DownloadStatus.values[json['status'] ?? 0],
    statusText: json['statusText'] ?? '',
    retryCount: json['retryCount'] ?? 0,
    videoUrl: json['videoUrl'],
    audioUrl: json['audioUrl'],
    isMuxed: json['isMuxed'] ?? true,
    startTime: json['startTime'] != null
        ? DateTime.parse(json['startTime'])
        : null,
    downloadedBytes: json['downloadedBytes'] ?? 0,
    totalBytes: json['totalBytes'] ?? 0,
    audioDownloadedBytes: json['audioDownloadedBytes'],
    audioTotalBytes: json['audioTotalBytes'],
    qualityLabel: json['qualityLabel'],
  );
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
  final Map<String, CancelToken> _cancelTokens = {};

  // إشعارات
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _notificationsInitialized = false;

  // ثوابت إعادة المحاولة
  static const int maxRetries = 3;
  static const Duration initialRetryDelay = Duration(seconds: 2);

  Stream<Map<String, DownloadTask>> get progressStream =>
      _progressController.stream;

  static const _muxChannel = MethodChannel('com.example.muxer');
  static const _prefsKey = 'download_tasks';

  DownloadTask? getTask(String videoId) => _tasks[videoId];

  /// تهيئة الإشعارات
  Future<void> initNotifications() async {
    if (_notificationsInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notifications.initialize(initSettings);
    _notificationsInitialized = true;
  }

  /// استعادة التحميلات المحفوظة عند بدء التطبيق
  Future<void> restorePendingDownloads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_prefsKey);

      if (tasksJson != null) {
        final Map<String, dynamic> tasksMap = jsonDecode(tasksJson);
        for (final entry in tasksMap.entries) {
          final task = DownloadTask.fromJson(entry.value);

          // استمر فقط في التحميلات غير المكتملة
          if (task.status == DownloadStatus.downloading ||
              task.status == DownloadStatus.paused) {
            task.status = DownloadStatus.paused;
            task.statusText = 'متوقف مؤقتاً - اضغط للاستمرار';
            _tasks[entry.key] = task;
          }
        }
        _notifyUpdates();
      }
    } catch (e) {
      // تجاهل أخطاء الاستعادة
    }
  }

  /// حفظ حالة التحميلات
  Future<void> _saveTasksState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksMap = <String, dynamic>{};

      for (final entry in _tasks.entries) {
        // احفظ فقط التحميلات الجارية أو المتوقفة
        if (entry.value.status == DownloadStatus.downloading ||
            entry.value.status == DownloadStatus.paused ||
            entry.value.status == DownloadStatus.merging) {
          tasksMap[entry.key] = entry.value.toJson();
        }
      }

      await prefs.setString(_prefsKey, jsonEncode(tasksMap));
    } catch (e) {
      // تجاهل أخطاء الحفظ
    }
  }

  /// عرض/تحديث إشعار التقدم
  Future<void> _showProgressNotification(DownloadTask task) async {
    if (!_notificationsInitialized) await initNotifications();

    final progress = (task.progress * 100).toInt();
    final title = task.videoName != null && task.videoName!.isNotEmpty
        ? 'تحميل: ${task.videoName}'
        : 'جاري التحميل';

    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'تحميل الفيديو',
      channelDescription: 'إشعارات تقدم التحميل',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: task.status == DownloadStatus.downloading,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      icon: '@mipmap/ic_launcher',
    );

    await _notifications.show(
      task.videoId.hashCode,
      title,
      task.statusText,
      NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
        macOS: const DarwinNotificationDetails(),
      ),
    );
  }

  /// عرض إشعار الاكتمال
  Future<void> _showCompletionNotification(
    DownloadTask task,
    bool success,
  ) async {
    if (!_notificationsInitialized) await initNotifications();

    final title = success ? 'اكتمل التحميل ✓' : 'فشل التحميل ✗';
    final message = task.videoName != null && task.videoName!.isNotEmpty
        ? (success
              ? 'تم تحميل "${task.videoName}" بنجاح'
              : 'فشل تحميل "${task.videoName}"')
        : (success ? 'تم تحميل الفيديو بنجاح' : 'فشل التحميل بعد عدة محاولات');

    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'تحميل الفيديو',
      channelDescription: 'إشعارات تحميل الفيديو',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    await _notifications.show(
      task.videoId.hashCode,
      title,
      message,
      NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
        macOS: const DarwinNotificationDetails(),
      ),
    );
  }

  /// إلغاء إشعار
  Future<void> _cancelNotification(String videoId) async {
    await _notifications.cancel(videoId.hashCode);
  }

  /// بدء التحميل مع دعم إعادة المحاولة
  Future<void> startDownload(
    String videoId,
    DownloadOption option, {
    String? videoName,
  }) async {
    if (_tasks[videoId]?.status == DownloadStatus.downloading ||
        _tasks[videoId]?.status == DownloadStatus.merging) {
      return;
    }

    // حساب الحجم الإجمالي
    final totalSize = option.isMuxed
        ? option.streamInfo.size.totalBytes
        : (option.videoStream!.size.totalBytes +
              option.audioStream!.size.totalBytes);

    final task = DownloadTask(
      videoId: videoId,
      videoName: videoName,
      status: DownloadStatus.downloading,
      statusText: 'جاري بدء التحميل...',
      videoUrl: option.streamInfo.url.toString(),
      audioUrl: option.audioStream?.url.toString(),
      isMuxed: option.isMuxed,
      startTime: DateTime.now(),
      totalBytes: totalSize,
      qualityLabel: option.label,
    );

    _tasks[videoId] = task;
    _cancelTokens[videoId] = CancelToken();
    _notifyUpdates();
    await _saveTasksState();

    await _executeDownload(task, option);
  }

  Future<void> startDownloadInBackground(
    String videoId,
    DownloadOption option, {
    String? videoName,
  }) async {
    if (_tasks[videoId]?.status == DownloadStatus.downloading ||
        _tasks[videoId]?.status == DownloadStatus.merging) {
      return;
    }

    // حساب الحجم الإجمالي
    final totalSize = option.isMuxed
        ? option.streamInfo.size.totalBytes
        : (option.videoStream!.size.totalBytes +
              option.audioStream!.size.totalBytes);

    final task = DownloadTask(
      videoId: videoId,
      videoName: videoName,
      status: DownloadStatus.downloading,
      statusText: 'جاري التحميل في الخلفية...',
      videoUrl: option.streamInfo.url.toString(),
      audioUrl: option.audioStream?.url.toString(),
      isMuxed: option.isMuxed,
      startTime: DateTime.now(),
      totalBytes: totalSize,
    );

    _tasks[videoId] = task;
    _notifyUpdates();
    await _saveTasksState();

    // بدء خدمة الخلفية
    await BackgroundDownloadService.startBackgroundDownload(
      videoId: videoId,
      videoUrl: option.streamInfo.url.toString(),
      audioUrl: option.audioStream?.url.toString(),
      isMuxed: option.isMuxed,
    );
  }

  /// استئناف التحميل المتوقف
  Future<void> resumeDownload(String videoId) async {
    final task = _tasks[videoId];
    if (task == null) {
      print('❌ لا يمكن استئناف التحميل: المهمة غير موجودة');
      return;
    }

    // التحقق من أن التحميل متوقف أو فشل
    if (task.status != DownloadStatus.paused &&
        task.status != DownloadStatus.failed) {
      print('❌ لا يمكن استئناف التحميل: الحالة = ${task.status}');
      return;
    }

    task.status = DownloadStatus.downloading;
    task.statusText = 'جاري استئناف التحميل...';
    task.retryCount = 0; // إعادة تعيين عداد المحاولات
    _cancelTokens[videoId] = CancelToken();
    _notifyUpdates();
    await _saveTasksState();

    print('✅ بدء استئناف التحميل للفيديو: $videoId');
    print('📊 التقدم السابق: ${(task.progress * 100).toStringAsFixed(1)}%');
    print(
      '📥 البيانات المحملة: ${task.downloadedBytes} / ${task.totalBytes} bytes',
    );

    // بما أن روابط YouTube تنتهي صلاحيتها، نحتاج إلى جلب روابط جديدة
    // ولكن سنحاول الاستئناف من نقطة التوقف إذا كان الملف موجوداً جزئياً
    if (task.videoUrl != null && task.videoUrl!.isNotEmpty) {
      // محاولة الاستئناف باستخدام الرابط القديم أولاً
      try {
        await _executeDownloadResume(task);
        return;
      } catch (e) {
        print('⚠️ فشل الاستئناف بالرابط القديم، سيتم جلب رابط جديد من YouTube');
      }
    }

    // إعادة جلب الروابط من YouTube (الروابط القديمة انتهت صلاحيتها)
    final yt = ytd.YoutubeExplode();
    try {
      print('🌐 جاري جلب روابط جديدة من YouTube...');
      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      final muxedStreams = manifest.muxed
          .where((s) => s.container == ytd.StreamContainer.mp4)
          .toList();

      if (muxedStreams.isNotEmpty) {
        // اختر أفضل جودة متاحة
        final stream = muxedStreams.first;
        final option = DownloadOption.muxed(stream);

        // تحديث الروابط الجديدة في المهمة
        task.videoUrl = option.streamInfo.url.toString();
        task.totalBytes = stream.size.totalBytes;

        // إعادة تعيين downloadedBytes لأننا سنبدأ من جديد
        task.downloadedBytes = 0;
        task.progress = 0.0;
        await _saveTasksState();

        print('⚠️ ملاحظة: رابط YouTube القديم انتهى، سيبدأ التحميل من الصفر');

        // بدء التحميل من جديد (لأننا لا نستطيع ضمان استمرارية رابط YouTube)
        await _executeDownload(task, option);
      } else {
        throw Exception('لم يتم العثور على دقات متاحة');
      }
    } catch (e) {
      print('❌ خطأ في جلب البيانات من YouTube: $e');
      task.status = DownloadStatus.failed;
      task.statusText = 'فشل الاستئناف - حاول مجدداً';
      _notifyUpdates();
      await _saveTasksState();
    } finally {
      yt.close();
    }
  }

  /// تنفيذ استئناف التحميل من نقطة التوقف
  Future<void> _executeDownloadResume(DownloadTask task) async {
    // هذه الدالة تحاول الاستئناف من حيث توقف التحميل
    final outPath = await _getLocalFilePath(task.videoId);
    final file = File(outPath);

    // التحقق من وجود ملف جزئي
    if (await file.exists()) {
      final fileSize = await file.length();
      print('📁 حجم الملف الموجود: $fileSize bytes');

      if (fileSize > 0 && fileSize < task.totalBytes) {
        print('✅ وجد ملف جزئي، محاولة الاستئناف...');

        try {
          // محاولة الاستئناف باستخدام الرابط القديم
          await _downloadWithRetryAndResume(
            url: task.videoUrl!,
            path: outPath,
            task: task,
            startByte: fileSize,
            onProgress: (received, total) {
              task.progress = (fileSize + received) / total;
              task.statusText =
                  'جاري الاستئناف... ${(task.progress * 100).toStringAsFixed(0)}%';
              _notifyUpdates();
              _showProgressNotification(task);
            },
          );

          // اكتمل التحميل
          task.status = DownloadStatus.completed;
          task.statusText = 'اكتمل التحميل!';
          _notifyUpdates();
          await _saveTasksState();
          await _showCompletionNotification(task, true);
          return;
        } catch (e) {
          print('⚠️ فشل الاستئناف بالرابط القديم: $e');
          // إذا فشل الاستئناف، حاول حذف الملف الجزئي والبدء من جديد
          // لأن الملف قد يكون تالفاً أو الرابط انتهى
          print('🔄 سيتم البدء من جديد مع رابط جديد...');

          // حذف الملف الجزئي التالف
          try {
            await file.delete();
            print('🗑️ تم حذف الملف الجزئي');
          } catch (deleteError) {
            print('⚠️ فشل حذف الملف الجزئي: $deleteError');
          }
        }
      } else if (fileSize >= task.totalBytes) {
        print('✅ الملف مكتمل بالفعل!');
        task.status = DownloadStatus.completed;
        task.statusText = 'اكتمل التحميل!';
        _notifyUpdates();
        await _saveTasksState();
        return;
      }
    } else {
      print('📭 لا يوجد ملف جزئي');
    }

    // إذا لم يوجد ملف جزئي أو فشل الاستئناف، ارمِ خطأ للرجوع للطريقة البديلة
    throw Exception('يجب جلب رابط جديد والبدء من الصفر');
  }

  /// إلغاء التحميل
  Future<void> cancelDownload(String videoId) async {
    _cancelTokens[videoId]?.cancel('User cancelled');
    _cancelTokens.remove(videoId);

    final task = _tasks[videoId];
    if (task != null) {
      task.status = DownloadStatus.none;
      task.statusText = 'تم الإلغاء';
      _notifyUpdates();
    }

    await _cancelNotification(videoId);
    _tasks.remove(videoId);
    await _saveTasksState();
    _notifyUpdates();
  }

  /// تنفيذ التحميل الفعلي مع إعادة المحاولة
  Future<void> _executeDownload(
    DownloadTask task,
    DownloadOption? option,
  ) async {
    try {
      final outPath = await _getLocalFilePath(task.videoId);
      final cancelToken = _cancelTokens[task.videoId];

      // عرض الإشعار والبدء
      _showProgressNotification(task);

      // جلب دفق البيانات (Streams) المناسب
      ytd.StreamInfo? videoStreamInfo;
      ytd.StreamInfo? audioStreamInfo;

      if (option != null) {
        videoStreamInfo = option.streamInfo;
        audioStreamInfo = option.audioStream;
      } else {
        final streams = await _refreshUrls(task);
        if (streams == null) throw Exception('فشل تجديد الروابط');
        videoStreamInfo = streams['video'];
        audioStreamInfo = streams['audio'];
      }

      if (task.isMuxed && videoStreamInfo != null) {
        // Use retry/resume logic
        await _downloadWithRetryAndResume(
          url: videoStreamInfo.url.toString(),
          path: outPath,
          task: task,
          startByte: 0,
          onProgress: (received, total) {
            final t = task.totalBytes > 0 ? task.totalBytes : total;
            if (t > 0) {
              task.progress = received / t;
              task.downloadedBytes = received; // This tracks total downloaded
              task.statusText =
                  'جاري التحميل... ${(task.progress * 100).toStringAsFixed(0)}%';
              _notifyUpdates();
              _showProgressNotification(task);
            }
          },
        );
      } else if (videoStreamInfo != null && audioStreamInfo != null) {
        final vTmp = '$outPath.video.mp4';
        final aTmp = '$outPath.audio.m4a';
        final totalSize =
            videoStreamInfo.size.totalBytes + audioStreamInfo.size.totalBytes;

        // تحميل الفيديو
        task.statusText = 'جاري تحميل الفيديو...';
        _notifyUpdates();
        _showProgressNotification(task);

        await _downloadWithRetryAndResume(
          url: videoStreamInfo.url.toString(),
          path: vTmp,
          task: task,
          startByte: 0,
          onProgress: (received, _) {
            // received is file size here
            if (totalSize > 0) {
              task.progress = received / totalSize;
              task.downloadedBytes = received; // Stores video size
              task.statusText =
                  'جاري تحميل الفيديو... ${(task.progress * 100).toStringAsFixed(0)}%';
              _notifyUpdates();
              _showProgressNotification(task);
            }
          },
        );

        // تحميل الصوت
        task.statusText = 'جاري تحميل الصوت...';
        _notifyUpdates();
        _showProgressNotification(task);

        await _downloadWithRetryAndResume(
          url: audioStreamInfo.url.toString(),
          path: aTmp,
          task: task,
          startByte: 0,
          onProgress: (received, _) {
            if (totalSize > 0) {
              final vSize =
                  task.downloadedBytes; // Video size stored previously
              task.progress = (vSize + received) / totalSize;
              task.audioDownloadedBytes = received;
              task.statusText =
                  'جاري تحميل الصوت... ${(task.progress * 100).toStringAsFixed(0)}%';
              _notifyUpdates();
              _showProgressNotification(task);
            }
          },
        );

        if (!(await File(vTmp).exists()) ||
            (await File(vTmp).length()) < 1000) {
          throw Exception('فشل تحميل الفيديو (ملف تالف)');
        }

        task.status = DownloadStatus.merging;
        task.statusText = 'جاري دمج الفيديو والصوت...';
        _notifyUpdates();
        _showProgressNotification(task);
        await _muxMp4(vTmp, aTmp, outPath);

        await File(vTmp).delete().catchError((_) => File(vTmp));
        await File(aTmp).delete().catchError((_) => File(aTmp));
      }

      task.status = DownloadStatus.completed;
      task.statusText = 'اكتمل التحميل!';
      _notifyUpdates();
      await _saveTasksState();
      await _showCompletionNotification(task, true);

      Future.delayed(const Duration(seconds: 5), () {
        if (_tasks[task.videoId]?.status == DownloadStatus.completed) {
          _tasks.remove(task.videoId);
          _notifyUpdates();
        }
      });
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;

      if ((e.response?.statusCode == 403 || e.toString().contains('403')) &&
          task.retryCount < 2) {
        print('⚠️ 403 Forbidden. Attempting URL refresh...');
        task.retryCount++;
        try {
          await _refreshUrls(task);
          return _executeDownload(task, null);
        } catch (resErr) {
          await _handleDownloadError(task, resErr);
        }
      } else {
        await _handleDownloadError(task, e);
      }
    } catch (e) {
      await _handleDownloadError(task, e);
    }
  }

  /// تحميل مع إعادة محاولة واستئناف من نقطة محددة
  Future<void> _downloadWithRetryAndResume({
    required String url,
    required String path,
    required DownloadTask task,
    required int startByte,
    required Function(int, int) onProgress,
  }) async {
    int attempts = 0;
    Duration delay = initialRetryDelay;

    while (attempts < maxRetries) {
      try {
        final cancelToken = _cancelTokens[task.videoId];
        if (cancelToken?.isCancelled ?? false) {
          throw DioException(
            requestOptions: RequestOptions(path: url),
            type: DioExceptionType.cancel,
          );
        }

        // 1. Get current file size for resume
        final file = File(path);
        int currentLength = 0;
        if (await file.exists()) {
          currentLength = await file.length();
        }

        // If explicitly resuming a part (like initial startByte), respect it if file is smaller?
        // Actually, startByte arg is usually 0 or specific.
        // If we are retrying, we ALWAYS want 'current file length'.
        // So we can ignore startByte argument in the loop logic and trust the file.
        // Except if startByte > currentLength (which shouldn't happen for downloads).

        // 2. Prepare request
        final options = Options(
          headers: {'Range': 'bytes=$currentLength-'},
          responseType: ResponseType.stream,
        );

        print('🔄 استئناف التحميل من البايت: $currentLength');

        final response = await _dio.get<ResponseBody>(
          url,
          options: options,
          cancelToken: cancelToken,
        );

        // 3. Write stream to file
        final raf = file.openSync(mode: FileMode.append);
        try {
          final stream = response.data!.stream;
          await for (final chunk in stream) {
            // Check cancel again inside loop for responsiveness
            if (cancelToken?.isCancelled ?? false) {
              throw DioException(
                requestOptions: RequestOptions(path: url),
                type: DioExceptionType.cancel,
              );
            }
            raf.writeFromSync(chunk);
            currentLength += chunk.length;
            onProgress(currentLength - startByte, task.totalBytes);
            // Note: onProgress expects (received, total).
            // 'received' usually means bytes received in *this* session?
            // No, task.progress = (fileSize + received) / total; in caller?
            // Let's check caller.
            // In _executeDownloadResume:
            // onProgress: (received, total) { task.progress = (fileSize + received) / total; }
            // So 'received' is bytes downloaded *since call started*.
            // But here we are resuming interally.
            // If we report 'currentLength - startByte', that is the delta since function start.
            // Yes, that matches expectations if startByte was the file size at function call time.
          }
        } finally {
          raf.closeSync();
        }

        return; // Success
      } on DioException catch (e) {
        if (e.type == DioExceptionType.cancel) rethrow;

        attempts++;
        if (attempts >= maxRetries) rethrow;

        print(
          '⚠️ فشل التحميل (محاولة $attempts/$maxRetries). إعادة المحاولة...',
        );
        await Future.delayed(delay);
        delay *= 2;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) rethrow;
        await Future.delayed(delay);
      }
    }
  }

  /// معالجة خطأ التحميل
  Future<void> _handleDownloadError(DownloadTask task, dynamic error) async {
    print('❌ Download failed for ${task.videoId}: $error');
    task.status = DownloadStatus.failed;
    // Show the actual error message if possible, or a generic one
    final errorMsg = error.toString().replaceAll('Exception:', '').trim();
    task.statusText = 'فشل: $errorMsg';
    _notifyUpdates();
    await _saveTasksState();
    await _showCompletionNotification(task, false);

    // تنظيف الملف التالف إذا وجد
    try {
      final path = await _getLocalFilePath(task.videoId);
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}

    // إزالة المهمة بعد 10 ثوانٍ
    Future.delayed(const Duration(seconds: 10), () {
      if (_tasks[task.videoId]?.status == DownloadStatus.failed) {
        _tasks.remove(task.videoId);
        _notifyUpdates();
      }
    });
  }

  Future<String> _getLocalFilePath(String videoId) async {
    final directory = await getApplicationDocumentsDirectory();
    String cleanId = videoId;
    try {
      cleanId = ytd.VideoId(videoId).value;
    } catch (_) {
      cleanId = videoId.replaceAll(RegExp(r'[^\w\d_-]'), '');
    }
    return '${directory.path}/$cleanId.mp4';
  }

  Future<void> _muxMp4(
    String videoPath,
    String audioPath,
    String outPath,
  ) async {
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

  /// تحديث الروابط في حالة انتهاء الصلاحية أو الخطأ 403
  Future<Map<String, ytd.StreamInfo>?> _refreshUrls(DownloadTask task) async {
    final yt = ytd.YoutubeExplode();
    try {
      String cleanId = task.videoId;
      try {
        cleanId = ytd.VideoId(task.videoId).value;
      } catch (_) {}

      final manifest = await yt.videos.streamsClient.getManifest(
        cleanId,
        ytClients: [
          ytd.YoutubeApiClient.safari,
          ytd.YoutubeApiClient.androidVr,
        ],
      );

      Map<String, ytd.StreamInfo> result = {};

      if (task.isMuxed) {
        final muxed = manifest.muxed.where(
          (s) => s.container == ytd.StreamContainer.mp4,
        );
        if (muxed.isNotEmpty) {
          // محاولة المطابقة مع الدقة السابقة
          ytd.MuxedStreamInfo? best;
          if (task.qualityLabel != null) {
            best = muxed.firstWhere(
              (s) =>
                  task.qualityLabel!.contains('${s.videoResolution.height}p'),
              orElse: () => muxed.withHighestBitrate(),
            );
          } else {
            best = muxed.withHighestBitrate();
          }
          task.videoUrl = best.url.toString();
          task.totalBytes = best.size.totalBytes;
          result['video'] = best;
        }
      } else {
        final videos = manifest.videoOnly.where(
          (s) => s.container == ytd.StreamContainer.mp4,
        );
        final a = manifest.audioOnly.withHighestBitrate();

        ytd.VideoOnlyStreamInfo? v;
        if (task.qualityLabel != null) {
          v = videos.firstWhere(
            (s) => task.qualityLabel!.contains('${s.videoResolution.height}p'),
            orElse: () => videos.withHighestBitrate(),
          );
        } else {
          v = videos.withHighestBitrate();
        }

        task.videoUrl = v.url.toString();
        task.audioUrl = a.url.toString();
        task.totalBytes = v.size.totalBytes + a.size.totalBytes;

        result['video'] = v;
        result['audio'] = a;
      }
      await _saveTasksState();
      return result;
    } catch (e) {
      print('❌ Error refreshing URLs: $e');
      return null;
    } finally {
      yt.close();
    }
  }

  void dispose() {
    for (final token in _cancelTokens.values) {
      token.cancel();
    }
    _cancelTokens.clear();
    _progressController.close();
  }
}
