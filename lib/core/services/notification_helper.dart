import 'dart:developer';

import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

// Top-level callback for handling notification clicks (Foreground & Background)
@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse response) {
  print("===== NOTIFICATION CLICKED =====");
  print("Payload: ${response.payload}");
  debugPrint("===== NOTIFICATION CLICKED =====");
  debugPrint("Payload: ${response.payload}");
  log("===== NOTIFICATION CLICKED =====");
  log(
    "NotificationHelper: Notification clicked with payload: ${response.payload}",
  );

  if (response.payload != null) {
    NotificationHelper._handleNavigation(response.payload!);
  } else {
    log("NotificationHelper: Payload is NULL!");
  }
}

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static String? launchPayload;

  static Future<void> initialize() async {
    log("NotificationHelper: Starting initialization...");

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize the plugin with callback for notification clicks
    // This callback ONLY fires when app is actively running (foreground/background)
    // and user clicks a notification. It does NOT fire when app is killed.
    log(
      "NotificationHelper: Registering onDidReceiveNotificationResponse callback",
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Create notification channel explicitly for Android 8.0+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'chat_channel_id',
      'Chat Notifications',
      description: 'إشعارات الرسائل الجديدة',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    log("NotificationHelper: Notification channel created");
    log("NotificationHelper: Initialization completed successfully");
    log(
      "NotificationHelper: Callback registered - ready to receive notification clicks",
    );
  }

  static void _handleNavigation(String payload) {
    debugPrint(
      "NotificationHelper: _handleNavigation called with payload: $payload",
    );
    try {
      SocketController socketController;
      if (Get.isRegistered<SocketController>()) {
        socketController = Get.find<SocketController>();
        debugPrint("NotificationHelper: Found existing SocketController");
      } else {
        socketController = Get.put(SocketController(), permanent: true);
        debugPrint("NotificationHelper: Created new SocketController");
      }
      socketController.navigateToChatScreen(payload);
    } catch (e, stack) {
      log("NotificationHelper: Error handling navigation: $e");
      debugPrint("NotificationHelper: Error: $e\n$stack");
    }
  }
}
