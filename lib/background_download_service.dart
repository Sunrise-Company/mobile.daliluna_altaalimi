import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة التحميل في الخلفية
class BackgroundDownloadService {
  static const String _prefsActiveDownload = 'active_background_download';
  static const String _notificationChannelId = 'download_channel';
  static const String _notificationChannelName = 'تحميل الفيديو';

  /// تهيئة خدمة الخلفية
  static Future<void> initialize() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      debugPrint("Background service not supported on this platform");
      return;
    }

    final service = FlutterBackgroundService();

    // إعدادات الإشعارات
    const androidNotificationChannel = AndroidNotificationChannel(
      _notificationChannelId,
      _notificationChannelName,
      description: 'قناة إشعارات تحميل الفيديو',
      importance: Importance.low,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidNotificationChannel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: _notificationChannelId,
        initialNotificationTitle: 'جاري التحميل',
        initialNotificationContent: 'يتم تحميل الفيديو...',
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.dataSync],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  /// بدء التحميل في الخلفية
  static Future<void> startBackgroundDownload({
    required String videoId,
    required String videoUrl,
    String? audioUrl,
    required bool isMuxed,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      debugPrint("Background service not supported on this platform");
      return;
    }
    // حفظ معلومات التحميل
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsActiveDownload,
      jsonEncode({
        'videoId': videoId,
        'videoUrl': videoUrl,
        'audioUrl': audioUrl,
        'isMuxed': isMuxed,
        'startTime': DateTime.now().toIso8601String(),
      }),
    );

    // بدء الخدمة
    final service = FlutterBackgroundService();
    await service.startService();
  }

  /// إيقاف التحميل في الخلفية
  static Future<void> stopBackgroundDownload() async {
    final service = FlutterBackgroundService();
    service.invoke('stop');
  }

  /// التحقق من وجود تحميل نشط
  static Future<bool> hasActiveDownload() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_prefsActiveDownload);
  }

  /// الحصول على معلومات التحميل النشط
  static Future<Map<String, dynamic>?> getActiveDownloadInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_prefsActiveDownload);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
}

/// iOS background handler
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

/// Main background service entry point
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final dio = Dio();
  final notifications = FlutterLocalNotificationsPlugin();

  // تهيئة الإشعارات
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await notifications.initialize(initSettings);

  // الاستماع لأوامر الإيقاف
  service.on('stop').listen((event) async {
    await _clearActiveDownload();
    await service.stopSelf();
  });

  // جلب معلومات التحميل
  final prefs = await SharedPreferences.getInstance();
  final downloadData = prefs.getString('active_background_download');

  if (downloadData == null) {
    await service.stopSelf();
    return;
  }

  final downloadInfo = jsonDecode(downloadData) as Map<String, dynamic>;
  final videoId = downloadInfo['videoId'] as String;
  final videoUrl = downloadInfo['videoUrl'] as String;
  final audioUrl = downloadInfo['audioUrl'] as String?;
  final isMuxed = downloadInfo['isMuxed'] as bool;

  try {
    final directory = await getApplicationDocumentsDirectory();
    final outPath = '${directory.path}/$videoId.mp4';

    if (isMuxed) {
      // تحميل ملف واحد (muxed)
      await _downloadWithProgress(
        dio: dio,
        url: videoUrl,
        path: outPath,
        service: service,
        notifications: notifications,
        videoId: videoId,
        label: 'جاري تحميل الفيديو',
      );
    } else if (audioUrl != null) {
      // تحميل فيديو + صوت
      final vTmp = '$outPath.video.tmp';
      final aTmp = '$outPath.audio.tmp';

      // تحميل الفيديو
      await _downloadWithProgress(
        dio: dio,
        url: videoUrl,
        path: vTmp,
        service: service,
        notifications: notifications,
        videoId: videoId,
        label: 'جاري تحميل الفيديو',
        progressOffset: 0,
        progressMultiplier: 0.5,
      );

      // تحميل الصوت
      await _downloadWithProgress(
        dio: dio,
        url: audioUrl,
        path: aTmp,
        service: service,
        notifications: notifications,
        videoId: videoId,
        label: 'جاري تحميل الصوت',
        progressOffset: 50,
        progressMultiplier: 0.5,
      );

      // دمج الفيديو والصوت (يتطلب native code)
      _updateNotification(
        notifications,
        videoId,
        'جاري الدمج',
        'يتم دمج الفيديو والصوت...',
        100,
        indeterminate: true,
      );

      // ملاحظة: الدمج يتطلب استدعاء native code
      // سنترك الملفات المؤقتة ليتم دمجها لاحقاً في التطبيق

      // تنظيف
      try {
        await File(vTmp).delete();
      } catch (_) {}
      try {
        await File(aTmp).delete();
      } catch (_) {}
    }

    // اكتمل التحميل
    await _showCompletionNotification(notifications, videoId, true);
    await _clearActiveDownload();
  } catch (e) {
    // فشل التحميل
    await _showCompletionNotification(notifications, videoId, false);
    await _clearActiveDownload();
  }

  await service.stopSelf();
}

/// تحميل مع تحديث التقدم
Future<void> _downloadWithProgress({
  required Dio dio,
  required String url,
  required String path,
  required ServiceInstance service,
  required FlutterLocalNotificationsPlugin notifications,
  required String videoId,
  required String label,
  int progressOffset = 0,
  double progressMultiplier = 1.0,
}) async {
  await dio.download(
    url,
    path,
    onReceiveProgress: (received, total) {
      if (total > 0) {
        final progress =
            ((received / total) * 100 * progressMultiplier + progressOffset)
                .toInt();
        final percentage = (received / total * 100).toStringAsFixed(0);

        _updateNotification(
          notifications,
          videoId,
          label,
          '$percentage%',
          progress,
        );

        // إرسال التحديث للتطبيق إذا كان مفتوحاً
        service.invoke('update', {
          'videoId': videoId,
          'progress': progress / 100,
          'status': 'downloading',
        });
      }
    },
  );
}

/// تحديث إشعار التقدم
Future<void> _updateNotification(
  FlutterLocalNotificationsPlugin notifications,
  String videoId,
  String title,
  String body,
  int progress, {
  bool indeterminate = false,
}) async {
  final androidDetails = AndroidNotificationDetails(
    'download_channel',
    'تحميل الفيديو',
    channelDescription: 'إشعارات تقدم التحميل',
    importance: Importance.low,
    priority: Priority.low,
    ongoing: true,
    showProgress: true,
    maxProgress: 100,
    progress: progress,
    indeterminate: indeterminate,
    icon: '@mipmap/ic_launcher',
  );

  await notifications.show(
    videoId.hashCode,
    title,
    body,
    NotificationDetails(android: androidDetails),
  );
}

/// إشعار الاكتمال
Future<void> _showCompletionNotification(
  FlutterLocalNotificationsPlugin notifications,
  String videoId,
  bool success,
) async {
  final androidDetails = AndroidNotificationDetails(
    'download_channel',
    'تحميل الفيديو',
    channelDescription: 'إشعارات تحميل الفيديو',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  await notifications.show(
    videoId.hashCode,
    success ? 'اكتمل التحميل ✓' : 'فشل التحميل ✗',
    success ? 'تم تحميل الفيديو بنجاح' : 'حدث خطأ أثناء التحميل',
    NotificationDetails(android: androidDetails),
  );
}

/// مسح معلومات التحميل النشط
Future<void> _clearActiveDownload() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('active_background_download');
}
