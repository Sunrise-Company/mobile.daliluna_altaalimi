// import 'dart:developer';

import 'dart:developer';
import 'dart:io';
import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:daliluna_altaalimi/core/services/version_service.dart';
import 'package:daliluna_altaalimi/data/model/version_model.dart';
import 'package:daliluna_altaalimi/view/screen/update_app.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/apptheme.dart';
import 'package:daliluna_altaalimi/modules/bindings/basket_bindings.dart';
import 'package:daliluna_altaalimi/routes.dart';
import 'package:video_player/video_player.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:emulator_checker/emulator_checker.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isEmulator = await checkIfEmulator();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await _initializeNotifications();
  final shouldUpdate = await checkVersionNeedsUpdate();
  if (isEmulator) {
    SystemNavigator.pop();
  } else {
    runApp(
      DevicePreview(
        enabled: false, //!kReleaseMode, // فقط في وضع التطوير
        builder: (context) => MyApp(forceUpdate: shouldUpdate),
      ),
    );
  }
}

Future<bool> checkIfEmulator() async {
  bool isGenericEmulator = await EmulatorChecker.isEmulator();
  if (isGenericEmulator) return true;

  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final String host = androidInfo.host ?? '';
    final String device = androidInfo.device ?? '';
    if (host.toLowerCase() == 'ubuntu' && device.toLowerCase() == 'aosp') {
      return true;
    }

    List<String> ldPlayerPaths = [
      '/storage/emulated/0/storage/secure',
      '/storage/emulated/0/Android/data/com.android.ld.appstore',
    ];
    for (String path in ldPlayerPaths) {
      if (await Directory(path).exists()) {
        return true;
      }
    }
  }

  return false;
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
    log("serverVersion ${serverVersion.versionNum.toString()}");
    log("localVersion ${localVersion}");
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
  late VideoPlayerController videoPlayerController;

  MyApp({required this.forceUpdate, super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
      theme: themeArabic,
      debugShowCheckedModeBanner: false,
      title: 'دليلنا التعليمي',
      getPages: routes,
      initialBinding: BasketBinding(),

      home: forceUpdate ? ForceUpdateScreen() : null,
    );
  }
}
