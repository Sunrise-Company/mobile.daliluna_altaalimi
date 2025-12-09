import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:daliluna_altaalimi/core/services/breadcrumb_service.dart';
import 'package:daliluna_altaalimi/core/services/breadcrumb_observer.dart';
import 'package:daliluna_altaalimi/core/services/version_service.dart';
import 'package:daliluna_altaalimi/data/model/version_model.dart';
import 'package:daliluna_altaalimi/view/screen/update_app.dart';
import 'package:device_preview/device_preview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/apptheme.dart';
import 'package:daliluna_altaalimi/modules/bindings/basket_bindings.dart';
import 'package:daliluna_altaalimi/routes.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:emulator_checker/emulator_checker.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Fix: Initialize in root zone
  runZonedGuarded(
    () async {
      Get.put(BreadcrumbService()); // Initialize BreadcrumbService

      try {
        // 1. Check Emulator (Blocking)
        String? emulatorReason = await checkIfEmulator().timeout(
          const Duration(seconds: 5),
          onTimeout: () => null,
        );

        if (emulatorReason != null) {
          String deviceInfo = await _getDeviceInfoString();
          _showErrorScreen(
            "Emulator Detected",
            "Reason: $emulatorReason",
            details: deviceInfo,
            isWarning: true,
          );
          return;
        }

        // 2. Initialize Notifications (Blocking)
        await _initializeNotifications();

        // 3. Check Version (Blocking)
        final shouldUpdate = await checkVersionNeedsUpdate().timeout(
          const Duration(seconds: 5),
          onTimeout: () => false,
        );

        // 4. Run App
        runApp(
          DevicePreview(
            enabled: false, //!kReleaseMode, // فقط في وضع التطوير
            builder: (context) => MyApp(forceUpdate: shouldUpdate),
          ),
        );
      } catch (e, stack) {
        log("Error in main: $e", error: e, stackTrace: stack);
        String deviceInfo = await _getDeviceInfoString();
        _showErrorScreen("Startup Error", e.toString(), details: deviceInfo);
      }
    },
    (error, stack) {
      log("Uncaught error: $error", error: error, stackTrace: stack);
      _showErrorScreen("Uncaught Error", error.toString());
    },
  );
}

Future<String> _getDeviceInfoString() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    return '''
Device: ${androidInfo.device}
Host: ${androidInfo.host}
Model: ${androidInfo.model}
Product: ${androidInfo.product}
Hardware: ${androidInfo.hardware}
Brand: ${androidInfo.brand}
IsPhysical: ${androidInfo.isPhysicalDevice}
Tags: ${androidInfo.tags}
Type: ${androidInfo.type}
Fingerprint: ${androidInfo.fingerprint}
''';
  }
  return "Not Android";
}

void _showErrorScreen(
  String title,
  String message, {
  String? details,
  bool isWarning = false,
}) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isWarning
                        ? Icons.warning_amber_rounded
                        : Icons.error_outline,
                    size: 80,
                    color: isWarning ? Colors.orange : Colors.red,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isWarning ? Colors.red : Colors.grey[800],
                    ),
                  ),
                  if (details != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        details,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  const Text(
                    "Please contact support with this screenshot.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<String?> checkIfEmulator() async {
  try {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      // 1. Trust Physical Device Flag (Fix for Redmi Pad SE)
      if (androidInfo.isPhysicalDevice) {
        return null;
      }

      final String host = androidInfo.host ?? '';
      final String device = androidInfo.device ?? '';

      // Log info for debugging
      log('Device Info - Host: $host, Device: $device');

      if (host.toLowerCase() == 'ubuntu' && device.toLowerCase() == 'aosp') {
        return "Host: $host, Device: $device";
      }

      List<String> ldPlayerPaths = [
        '/storage/emulated/0/storage/secure',
        '/storage/emulated/0/Android/data/com.android.ld.appstore',
      ];
      for (String path in ldPlayerPaths) {
        if (await Directory(path).exists()) {
          return "Found path: $path";
        }
      }
    }

    // 2. Generic Check (Only runs if isPhysicalDevice is false or not Android)
    bool isGenericEmulator = await EmulatorChecker.isEmulator();
    if (isGenericEmulator) return "Generic EmulatorChecker detected";
  } catch (e) {
    log('Error in checkIfEmulator: $e');
  }

  return null;
}

Future<void> _initializeNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        Sockectcontroller sockectcontroller = Get.put(Sockectcontroller());
        sockectcontroller.navigateToChatScreen(response.payload!);
      }
    },
  );
}

Future<bool> checkVersionNeedsUpdate() async {
  try {
    final VersionService service = VersionService();
    final VersionModel? serverVersion = await service.fetchVersion();
    if (serverVersion == null) return false;
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final String localVersion = packageInfo.buildNumber.isNotEmpty
        ? '${packageInfo.version}+${packageInfo.buildNumber}'
        : packageInfo.version;

    if (isVersionOlder("${localVersion}", "${serverVersion.versionNum}")) {
      return true;
    }
  } catch (e) {
    print('Error checking version: $e');
  }
  return false;
}

bool isVersionOlder(String local, String remote) {
  log('local   $local');
  log('remote  $remote');

  (List<int>, int?) parseVersion(String version) {
    final parts = version.split('+');
    final mainVersion = parts[0];
    final versionParts = mainVersion.split('.').map(int.parse).toList();
    final buildNumber = parts.length > 1 ? int.tryParse(parts[1]) : null;
    return (versionParts, buildNumber);
  }

  final (localParts, localBuild) = parseVersion(local);
  final (remoteParts, remoteBuild) = parseVersion(remote);

  for (int i = 0; i < remoteParts.length; i++) {
    if (i >= localParts.length || localParts[i] < remoteParts[i]) {
      return true;
    } else if (localParts[i] > remoteParts[i]) {
      return false;
    }
  }

  if (localBuild != null && remoteBuild != null) {
    return localBuild < remoteBuild;
  }

  if (localBuild == null && remoteBuild != null) {
    return true;
  }
  if (localBuild != null && remoteBuild == null) {
    return false;
  }

  return false;
}

class MyApp extends StatelessWidget {
  final bool forceUpdate;

  const MyApp({required this.forceUpdate, super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      theme: themeArabic,
      debugShowCheckedModeBanner: false,
      title: 'دليلنا التعليمي',
      getPages: routes,
      initialBinding: BasketBinding(),
      navigatorObservers: [BreadcrumbObserver()],
      home: forceUpdate ? ForceUpdateScreen() : null,
    );
  }
}
