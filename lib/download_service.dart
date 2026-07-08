import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytd;
import 'package:daliluna_altaalimi/background_download_service.dart';
import 'dart:math';
import 'dart:isolate';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart' hide Response;

@pragma('vm:entry-point')
void downloadNotificationBackgroundHandler(NotificationResponse response) {
  print('🟣 [Background] Handler triggered! Action: ${response.actionId}');
  DartPluginRegistrant.ensureInitialized();

  if (response.payload == null) {
    print('🟣 [Background] Payload is null! Aborting.');
    return;
  }

  String videoId;
  if (response.payload!.startsWith('{')) {
    try {
      final data = jsonDecode(response.payload!);
      videoId = data['videoId'];
    } catch (e) {
      videoId = response.payload!;
    }
  } else {
    videoId = response.payload!;
  }

  print('🟣 [Background] Payload videoId: $videoId');

  final sendPort = IsolateNameServer.lookupPortByName('download_send_port');
  if (sendPort != null) {
    print('🟣 [Background] SendPort FOUND! Sending message...');
    if (response.actionId == 'cancel_download') {
      sendPort.send({'action': 'cancel', 'videoId': videoId});
    } else if (response.actionId == 'pause_download') {
      sendPort.send({'action': 'pause', 'videoId': videoId});
    } else if (response.actionId == 'resume_download') {
      sendPort.send({'action': 'resume', 'videoId': videoId});
    }
  } else {
    print(
      '🟣 [Background] SendPort is NULL! Main isolate might be dead or port not registered.',
    );
  }
}

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
  int? lessonId;
  String? type;

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
    this.lessonId,
    this.type,
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
    'lessonId': lessonId,
    'type': type,
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
    lessonId: json['lessonId'],
    type: json['type'],
  );
}

class DownloadService with WidgetsBindingObserver {
  DownloadService._privateConstructor();
  static final DownloadService _instance =
      DownloadService._privateConstructor();
  static DownloadService get instance => _instance;

  final Dio _dio = Dio();
  final Map<String, DownloadTask> _tasks = {};
  final _progressController =
      StreamController<Map<String, DownloadTask>>.broadcast();
  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, int> _lastNotifiedProgress = {};

  // إشعارات
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _notificationsInitialized = false;

  // ثوابت إعادة المحاولة
  static const int maxRetries = 3;
  static const Duration initialRetryDelay = Duration(seconds: 2);

  Stream<Map<String, DownloadTask>> get progressStream =>
      _progressController.stream;

  Map<String, DownloadTask> get tasks => _tasks;

  static const _muxChannel = MethodChannel('com.example.muxer');
  static const _wakeLockChannel = MethodChannel(
    'com.sunrise.daliluna/wakelock',
  );
  static const _prefsKey = 'download_tasks';

  DownloadTask? getTask(String videoId) => _tasks[videoId];

  Future<void> _acquireWakeLock() async {
    if (Platform.isAndroid) {
      try {
        await _wakeLockChannel.invokeMethod('acquire');
        print('🟢 Partial WakeLock acquired.');
      } catch (e) {
        print('Wakelock acquire error: $e');
      }
    }
  }

  Future<void> _releaseWakeLock() async {
    if (Platform.isAndroid) {
      try {
        await _wakeLockChannel.invokeMethod('release');
        print('🔴 Partial WakeLock released.');
      } catch (e) {
        print('Wakelock release error: $e');
      }
    }
  }

  void _checkAndReleaseWakeLock() {
    final hasActiveDownloads = _tasks.values.any(
      (t) =>
          t.status == DownloadStatus.downloading ||
          t.status == DownloadStatus.merging,
    );
    if (!hasActiveDownloads) {
      _releaseWakeLock();
    }
  }

  /// تهيئة الإشعارات
  Future<void> initNotifications() async {
    if (_notificationsInitialized) return;

    // مراقبة دورة حياة التطبيق لمعالجة إغلاق التطبيق (onTaskRemoved)
    WidgetsBinding.instance.addObserver(this);

    const androidSettings = AndroidInitializationSettings('ic_stat_logo');
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

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        print(
          '🟡 [Foreground] Notification Clicked: actionId=${response.actionId}',
        );
        if (response.payload == null) return;

        String videoId;
        int lessonId = 0;
        String type = 'lesson_dep_file';

        if (response.payload!.startsWith('{')) {
          try {
            final data = jsonDecode(response.payload!);
            videoId = data['videoId'];
            lessonId = data['lessonId'] ?? 0;
            type = data['type'] ?? 'lesson_dep_file';
          } catch (e) {
            videoId = response.payload!;
          }
        } else {
          videoId = response.payload!;
          final task = DownloadService.instance._tasks[videoId];
          lessonId = task?.lessonId ?? 0;
          type = task?.type ?? 'lesson_dep_file';
        }

        if (response.actionId == 'pause_download') {
          DownloadService.instance.pauseDownload(videoId);
        } else if (response.actionId == 'resume_download') {
          DownloadService.instance.resumeDownload(videoId);
        } else if (response.actionId == 'cancel_download') {
          print('🟡 [Foreground] Executing cancelDownload for $videoId');
          DownloadService.instance.cancelDownload(videoId);
        } else {
          // If actionId is empty, it means the user clicked the notification body itself
          final currentArgs = Get.arguments;
          final isSameVideo =
              Get.currentRoute == '/youtubeplayer' &&
              currentArgs != null &&
              currentArgs is Map &&
              currentArgs['videoId'] == videoId;

          if (isSameVideo) {
            print(
              '🟡 [Foreground] Already on the same video screen, ignoring navigation.',
            );
            return;
          }

          Get.toNamed(
            '/youtubeplayer', // AppRoute.youtubePlayer (all lowercase)
            preventDuplicates:
                false, // يسمح بفتح أكثر من فيديو فوق بعضهم (ولكن ليس نفس الفيديو)
            arguments: {'videoId': videoId, 'lessonId': lessonId, 'type': type},
          );
        }
      },
      onDidReceiveBackgroundNotificationResponse:
          downloadNotificationBackgroundHandler,
    );

    // Register ReceivePort for background communication
    final port = ReceivePort();
    IsolateNameServer.removePortNameMapping('download_send_port');
    IsolateNameServer.registerPortWithName(port.sendPort, 'download_send_port');
    port.listen((message) {
      print('🟢 [Foreground] Received message from background: $message');
      if (message is Map) {
        final action = message['action'];
        final videoId = message['videoId'];
        print('🟢 [Foreground] Action parsed: $action for video: $videoId');
        if (action == 'pause') {
          DownloadService.instance.pauseDownload(videoId);
        } else if (action == 'resume') {
          DownloadService.instance.resumeDownload(videoId);
        } else if (action == 'cancel') {
          DownloadService.instance.cancelDownload(videoId);
        }
      } else {
        print(
          '🟢 [Foreground] Message is NOT a Map! Type: ${message.runtimeType}',
        );
      }
    });

    _notificationsInitialized = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      print(
        '🔴 App is detached. User swiped app away, stopping foreground service to clear notification.',
      );
      // إيقاف الخدمة لإزالة الإشعار المعلق عندما يغلق المستخدم التطبيق (السحب من المهام)
      _stopForegroundService();
      _checkAndReleaseWakeLock();

      // إيقاف جميع التحميلات النشطة بشكل نظيف لكي لا يبقى شيء معلقاً
      for (final videoId in _cancelTokens.keys.toList()) {
        _cancelTokens[videoId]?.cancel('App killed by user');
      }
    }
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

          // استمر فقط في التحميلات غير المكتملة أو قيد الدمج
          if (task.status == DownloadStatus.downloading ||
              task.status == DownloadStatus.paused ||
              task.status == DownloadStatus.merging) {
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

    // خنق التحديثات (Rate Limiting) لتجنب اختناق نظام أندرويد
    if (task.status == DownloadStatus.downloading) {
      final lastProgress = _lastNotifiedProgress[task.videoId];
      // لا تقم بتحديث الإشعار إذا لم تتغير النسبة المئوية
      if (lastProgress != null && progress == lastProgress) {
        return;
      }
      _lastNotifiedProgress[task.videoId] = progress;
    }
    final title = task.videoName != null && task.videoName!.isNotEmpty
        ? 'تحميل: ${task.videoName}'
        : 'جاري التحميل';

    // أزرار الإجراء تختلف بحسب الحالة
    final List<AndroidNotificationAction> actions;
    if (task.status == DownloadStatus.paused) {
      actions = [
        const AndroidNotificationAction(
          'resume_download',
          '▶ استمرار',
          showsUserInterface: false,
          cancelNotification: false,
        ),
        const AndroidNotificationAction(
          'cancel_download',
          '✕ إلغاء',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ];
    } else {
      actions = [
        const AndroidNotificationAction(
          'pause_download',
          '⏸ إيقاف مؤقت',
          showsUserInterface: false,
          cancelNotification: false,
        ),
        const AndroidNotificationAction(
          'cancel_download',
          '✕ إلغاء',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ];
    }

    final androidDetails = AndroidNotificationDetails(
      'download_channel_v2', // تم تغيير المعرف لكي يقبل أندرويد الإعدادات الجديدة
      'دليلنا التعليمي',
      channelDescription: 'إشعارات تقدم التحميل',
      importance:
          Importance.max, // لمنع الإشعار من الذهاب لقسم "الإشعارات الصامتة"
      priority: Priority.high,
      playSound: false, // بدون صوت أثناء التقدم المباشر
      enableVibration: false,
      ongoing:
          task.status == DownloadStatus.downloading ||
          task.status == DownloadStatus.merging,
      autoCancel: false,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      icon: 'ic_stat_logo',
      actions: actions,
    );

    // عرض إشعار التقدم الفردي لكل فيديو
    await _notifications.show(
      task.videoId.hashCode,
      title,
      task.statusText,
      NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
        macOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode({
        'videoId': task.videoId,
        'lessonId': task.lessonId,
        'type': task.type,
      }),
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
      'download_channel_v2', // يجب أن يتطابق مع معرف تقدم التحميل
      'دليلنا التعليمي',
      channelDescription: 'إشعارات تحميل الفيديو',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true, // تفعيل الصوت عند الاكتمال
      enableVibration: true,
      icon: 'ic_stat_logo',
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
      payload: jsonEncode({
        'videoId': task.videoId,
        'lessonId': task.lessonId,
        'type': task.type,
      }),
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
    int? lessonId,
    String? type,
  }) async {
    if (_tasks[videoId]?.status == DownloadStatus.downloading ||
        _tasks[videoId]?.status == DownloadStatus.merging) {
      return;
    }

    // طلب السماح بتجاهل تحسينات البطارية (لمنع إغلاق التطبيق بسبب الرام)
    if (Platform.isAndroid) {
      final status = await Permission.ignoreBatteryOptimizations.status;
      if (!status.isGranted) {
        final bool? proceed = await Get.defaultDialog<bool>(
          title: "إعداد هام جداً ⚠️",
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: 18,
            color: AppColor.PrimaryColor,
          ),
          content: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "لضمان استمرار التحميل في الخلفية وعدم توقفه، يرجى تفعيل السماح للتطبيق بالعمل في الخلفية (أو اختيار 'بدون قيود' / No restrictions) في الشاشة التالية.",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
            ),
          ),
          barrierDismissible: false,
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(
                'تخطي',
                style: TextStyle(fontFamily: 'Cairo', color: AppColor.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.PrimaryColor,
              ),
              child: const Text(
                'الانتقال للإعدادات',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
              ),
            ),
          ],
        );

        if (proceed == true) {
          await Permission.ignoreBatteryOptimizations.request();
        }
      }
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
      lessonId: lessonId,
      type: type,
    );

    _tasks[videoId] = task;
    _cancelTokens[videoId] = CancelToken();
    _notifyUpdates();
    await _saveTasksState();
    await _acquireWakeLock();

    await _executeDownload(task, option);
  }

  Future<void> startDownloadInBackground(
    String videoId,
    DownloadOption option, {
    String? videoName,
    int? lessonId,
    String? type,
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
      qualityLabel: option.label,
      lessonId: lessonId,
      type: type,
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
      lessonId: lessonId ?? 0,
      type: type ?? '',
    );
  }

  /// إيقاف مؤقت للتحميل
  Future<void> pauseDownload(String videoId) async {
    final task = _tasks[videoId];
    if (task == null) return;
    if (task.status != DownloadStatus.downloading &&
        task.status != DownloadStatus.merging)
      return;

    // إلغاء الطلب الجاري (الـ Dio سيرمي CanceledException)
    if (!(_cancelTokens[videoId]?.isCancelled ?? true)) {
      _cancelTokens[videoId]?.cancel('pause');
    }

    task.status = DownloadStatus.paused;
    task.statusText = 'متوقف مؤقتاً - اضغط للاستمرار';
    _notifyUpdates();
    await _saveTasksState();
    await _stopForegroundService();
    _checkAndReleaseWakeLock();

    // تحديث الإشعار ليعرض زر الاستئناف
    _showProgressNotification(task);
  }

  /// إيقاف خدمة الـ Foreground Service
  Future<void> _stopForegroundService() async {
    try {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.stopForegroundService();
    } catch (e) {
      print('Foreground service stop error: $e');
    }
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
    await _acquireWakeLock();

    // مسح الذاكرة المؤقتة للنسبة المئوية لإجبار الإشعار على التحديث الفوري لحالة "الاستئناف"
    _lastNotifiedProgress.remove(videoId);
    // تحديث الإشعار ليعرض حالة التحميل
    _showProgressNotification(task);

    print('✅ بدء استئناف التحميل للفيديو: $videoId');

    // استخدام دالة التحميل الموحدة التي تدعم الاستئناف التلقائي
    await _executeDownload(task, null);
  }

  /// إلغاء التحميل
  Future<void> cancelDownload(String videoId) async {
    print('🔴 يتم الآن إلغاء التحميل للفيديو: $videoId');

    if (!(_cancelTokens[videoId]?.isCancelled ?? true)) {
      _cancelTokens[videoId]?.cancel('User cancelled');
    }
    _cancelTokens.remove(videoId);

    final task = _tasks[videoId];
    if (task != null) {
      task.status = DownloadStatus.none;
      task.statusText = 'تم الإلغاء';
      _notifyUpdates();
    }

    // إيقاف الـ Foreground Service ضروري جداً لكي يختفي الإشعار في الأندرويد
    await _stopForegroundService();
    await _cancelNotification(videoId);

    _tasks.remove(videoId);
    await _saveTasksState();
    _notifyUpdates();
    _checkAndReleaseWakeLock();
  }

  /// تنفيذ التحميل الفعلي مع إعادة المحاولة
  Future<void> _executeDownload(
    DownloadTask task,
    DownloadOption? option,
  ) async {
    try {
      final outPath = await _getLocalFilePath(task.videoId);

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
        // التحقق من وجود ملف جزئي
        int fileSize = 0;
        if (await File(outPath).exists()) {
          fileSize = await File(outPath).length();
        }

        if (task.totalBytes > 0 && fileSize >= task.totalBytes) {
          task.status = DownloadStatus.completed;
          task.statusText = 'اكتمل التحميل!';
          task.progress = 1.0;
          _notifyUpdates();
          await _saveTasksState();
          await _showCompletionNotification(task, true);
          return;
        }

        // Use retry/resume logic
        await _downloadWithRetryAndResume(
          url: videoStreamInfo.url.toString(),
          path: outPath,
          task: task,
          startByte: fileSize,
          onProgress: (received, total) {
            final t = task.totalBytes > 0 ? task.totalBytes : total;
            if (t > 0) {
              final totalNow = fileSize + received;
              task.progress = totalNow / t;
              task.downloadedBytes = totalNow;
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

        int vSize = 0;
        if (await File(vTmp).exists()) vSize = await File(vTmp).length();

        int aSize = 0;
        if (await File(aTmp).exists()) aSize = await File(aTmp).length();

        // تحميل الفيديو إذا لم يكتمل
        if (vSize < videoStreamInfo.size.totalBytes) {
          task.statusText = 'جاري تحميل الفيديو...';
          _notifyUpdates();
          _showProgressNotification(task);

          await _downloadWithRetryAndResume(
            url: videoStreamInfo.url.toString(),
            path: vTmp,
            task: task,
            startByte: vSize,
            onProgress: (received, _) {
              if (task.status == DownloadStatus.paused ||
                  task.status == DownloadStatus.none)
                return;
              if (totalSize > 0) {
                final totalV = vSize + received;
                task.progress = (totalV + aSize) / totalSize;
                task.downloadedBytes = totalV;
                task.statusText =
                    'جاري تحميل الفيديو... ${(task.progress * 100).toStringAsFixed(0)}%';
                _notifyUpdates();
                _showProgressNotification(task);
              }
            },
          );

          // تحديث الحجم بعد الانتهاء للدمج الصحيح
          if (await File(vTmp).exists()) vSize = await File(vTmp).length();
        } else {
          task.downloadedBytes = videoStreamInfo.size.totalBytes;
        }

        // تحميل الصوت إذا لم يكتمل
        if (aSize < audioStreamInfo.size.totalBytes) {
          if (task.status == DownloadStatus.paused ||
              task.status == DownloadStatus.none)
            return;
          task.statusText = 'جاري تحميل الصوت...';
          _notifyUpdates();
          _showProgressNotification(task);

          await _downloadWithRetryAndResume(
            url: audioStreamInfo.url.toString(),
            path: aTmp,
            task: task,
            startByte: aSize,
            onProgress: (received, _) {
              if (task.status == DownloadStatus.paused ||
                  task.status == DownloadStatus.none)
                return;
              if (totalSize > 0) {
                final totalA = aSize + received;
                task.progress = (vSize + totalA) / totalSize;
                task.audioDownloadedBytes = totalA;
                task.statusText =
                    'جاري تحميل الصوت... ${(task.progress * 100).toStringAsFixed(0)}%';
                _notifyUpdates();
                _showProgressNotification(task);
              }
            },
          );
        }

        if (!(await File(vTmp).exists()) ||
            (await File(vTmp).length()) < 1000) {
          throw Exception('فشل تحميل الفيديو (ملف تالف)');
        }

        task.status = DownloadStatus.merging;
        task.statusText = 'جاري دمج الفيديو والصوت...';
        _notifyUpdates();
        _showProgressNotification(task);

        // Safe-Write Protocol: Mux to a temporary path, then rename
        final mergePath = '$outPath.merging';
        try {
          await _muxMp4(vTmp, aTmp, mergePath);
          final mergeFile = File(mergePath);
          if (await mergeFile.exists()) {
            await mergeFile.rename(outPath);
          } else {
            throw Exception('فشل الدمج: الملف الناتج غير موجود');
          }
        } catch (e) {
          print('❌ [Muxer] Merge failed: $e');
          rethrow;
        } finally {
          // Clean up temp tracks
          if (await File(vTmp).exists()) await File(vTmp).delete();
          if (await File(aTmp).exists()) await File(aTmp).delete();
          if (await File(mergePath).exists()) await File(mergePath).delete();
        }
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
    } finally {
      _checkAndReleaseWakeLock();
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
        if ((cancelToken?.isCancelled ?? false) ||
            task.status == DownloadStatus.paused ||
            task.status == DownloadStatus.none) {
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

        Response<ResponseBody> response;
        try {
          response = await _dio.get<ResponseBody>(
            url,
            options: options,
            cancelToken: cancelToken,
          );
        } on DioException catch (e) {
          if (e.response?.statusCode == 416) {
            if (currentLength > 0) return; // File is likely complete

            // If empty file got 416, something is wrong
            await file.delete();
            throw Exception('Invalid range start, restarting...');
          }
          rethrow;
        }

        // 3. Write stream to file
        final raf = file.openSync(mode: FileMode.append);
        try {
          final stream = response.data!.stream;
          await for (final chunk in stream) {
            // Check cancel again inside loop for responsiveness
            if ((cancelToken?.isCancelled ?? false) ||
                task.status == DownloadStatus.paused ||
                task.status == DownloadStatus.none) {
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
        task.statusText = 'جاري إعادة المحاولة ($attempts/$maxRetries)...';
        _notifyUpdates();
        await Future.delayed(delay);
        delay *= 2;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) rethrow;

        task.statusText = 'جاري إعادة المحاولة ($attempts/$maxRetries)...';
        _notifyUpdates();
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
    try {
      print('⏳ [Muxer] Starting muxing: $videoPath + $audioPath -> $outPath');
      await _muxChannel.invokeMethod('mux', {
        'video': videoPath,
        'audio': audioPath,
        'out': outPath,
      });
      print('✅ [Muxer] Muxing channel call finished');
    } catch (e) {
      print('❌ [Muxer] Channel error during muxing: $e');
      rethrow;
    }
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
          (s) =>
              s.container == ytd.StreamContainer.mp4 &&
              s.videoCodec.startsWith('avc1'),
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
          (s) =>
              s.container == ytd.StreamContainer.mp4 &&
              s.videoCodec.startsWith('avc1'),
        );
        final audioStreams = manifest.audioOnly.where(
          (s) =>
              s.container == ytd.StreamContainer.mp4 &&
              !s.audioCodec.toLowerCase().contains('opus'),
        );
        final a = audioStreams.isNotEmpty
            ? audioStreams.withHighestBitrate()
            : manifest.audioOnly.withHighestBitrate();

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
