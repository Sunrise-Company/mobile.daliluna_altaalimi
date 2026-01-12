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
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent "Red Screen of Death"
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material(color: Colors.transparent, child: SizedBox.shrink());
  };

  // Log Flutter errors instead of showing them
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint("Flutter Framework Error: ${details.exception}");
  };

  Get.put(BreadcrumbService()); // Initialize BreadcrumbService

  // ═══════════════════════════════════════════════════════════════
  // 🧪 DEBUG MODE: Test Error Screen Without Real Device
  // ═══════════════════════════════════════════════════════════════
  // Set to null to disable, or choose from:
  // - "emulator_path"    : Test LDPlayer detection
  // - "ubuntu_aosp"      : Test Ubuntu/AOSP detection
  // - "explicit_emulator": Test explicit emulator signatures
  // - "test_keys"        : Test test-keys detection
  // - "generic"          : Test generic fingerprint
  // - "generic_checker"  : Test generic EmulatorChecker
  // ═══════════════════════════════════════════════════════════════
  const String? DEBUG_ERROR_SCREEN_MODE =
      null; // Change to test different scenarios

  if (DEBUG_ERROR_SCREEN_MODE != null) {
    String deviceInfo = await _getDeviceInfoString();
    String testReason = _getDebugErrorReason(DEBUG_ERROR_SCREEN_MODE);
    String arabicReason = _translateEmulatorReason(testReason);

    _showErrorScreen(
      "تم اكتشاف محاكي",
      arabicReason,
      details: deviceInfo,
      isWarning: true,
    );
    return;
  }
  // ═══════════════════════════════════════════════════════════════

  // 1. Check Emulator (Blocking) - The ONLY error screen we want
  try {
    String? emulatorReason = await checkIfEmulator().timeout(
      const Duration(seconds: 5),
      onTimeout: () => null,
    );

    if (emulatorReason != null) {
      String deviceInfo = await _getDeviceInfoString();

      // Translate the reason to Arabic for better user understanding
      String arabicReason = _translateEmulatorReason(emulatorReason);

      _showErrorScreen(
        "تم اكتشاف محاكي",
        arabicReason,
        details: deviceInfo,
        isWarning: true,
      );
      return;
    }
  } catch (e) {
    // Ignore emulator check internal errors
    debugPrint("Emulator check error: $e");
  }

  // 2. Initialize Notifications (Non-blocking)
  try {
    await _initializeNotifications();
  } catch (e) {
    debugPrint("Notification init failed: $e");
  }

  // 3. Check Version (Non-blocking)
  bool shouldUpdate = false;
  try {
    shouldUpdate = await checkVersionNeedsUpdate().timeout(
      const Duration(seconds: 5),
      onTimeout: () => false,
    );
  } catch (e) {
    debugPrint("Version check failed: $e");
  }

  // 4. Run App
  runApp(
    DevicePreview(
      enabled: false, // فقط في وضع التطوير
      builder: (context) => MyApp(forceUpdate: shouldUpdate),
    ),
  );
}

String _getDebugErrorReason(String mode) {
  // Generate test error reasons for debugging
  switch (mode) {
    case "emulator_path":
      return "Found emulator path: /storage/emulated/0/Android/data/com.android.ld.appstore (STRONG EVIDENCE)";
    case "ubuntu_aosp":
      return "Host: ubuntu, Device: aosp (STRONG EVIDENCE)";
    case "explicit_emulator":
      return "Explicit emulator signature in product/model (STRONG EVIDENCE)";
    case "test_keys":
      return "Fingerprint contains test-keys (unknown brand)";
    case "generic":
      return "Fingerprint contains 'generic' (unknown brand)";
    case "generic_checker":
      return "Generic EmulatorChecker detected (non-physical, unknown brand)";
    default:
      return "Unknown debug mode: $mode";
  }
}

String _translateEmulatorReason(String reason) {
  // Translate emulator detection reasons to Arabic
  if (reason.contains('Found emulator path')) {
    return '''
تم اكتشاف مسارات خاصة بالمحاكيات على هذا الجهاز.

🔍 التفاصيل التقنية:
$reason

⚠️ هذا التطبيق لا يعمل على المحاكيات (Emulators) لأسباب أمنية.
يرجى استخدام جهاز حقيقي (هاتف أو تابلت) لتشغيل التطبيق.
''';
  } else if (reason.contains('Ubuntu') && reason.contains('AOSP')) {
    return '''
تم اكتشاف توليفة Ubuntu/AOSP المميزة للمحاكيات.

🔍 التفاصيل التقنية:
$reason

⚠️ هذا التطبيق لا يعمل على المحاكيات لأسباب أمنية.
يرجى استخدام جهاز حقيقي لتشغيل التطبيق.
''';
  } else if (reason.contains('Explicit emulator signature')) {
    return '''
تم اكتشاف علامات واضحة تدل على أن هذا محاكي وليس جهاز حقيقي.

🔍 التفاصيل التقنية:
$reason

⚠️ هذا التطبيق لا يعمل على المحاكيات (Android SDK/Emulator) لأسباب أمنية.
يرجى استخدام جهاز حقيقي لتشغيل التطبيق.
''';
  } else if (reason.contains('test-keys')) {
    return '''
تم اكتشاف "test-keys" في بصمة النظام من جهاز غير معروف.

🔍 التفاصيل التقنية:
$reason

⚠️ هذا قد يشير إلى محاكي أو ROM معدل على جهاز غير معروف.
إذا كنت تستخدم جهاز حقيقي، يرجى التواصل مع الدعم الفني.
''';
  } else if (reason.contains('generic')) {
    return '''
تم اكتشاف بصمة "generic" في النظام من جهاز غير معروف.

🔍 التفاصيل التقنية:
$reason

⚠️ هذا قد يشير إلى محاكي.
إذا كنت تستخدم جهاز حقيقي، يرجى التواصل مع الدعم الفني.
''';
  } else if (reason.contains('Generic EmulatorChecker')) {
    return '''
تم اكتشاف هذا الجهاز كمحاكي من خلال الفحص العام.

🔍 التفاصيل التقنية:
$reason

⚠️ هذا التطبيق لا يعمل على المحاكيات لأسباب أمنية.
يرجى استخدام جهاز حقيقي (هاتف أو تابلت) لتشغيل التطبيق.
''';
  }

  // Default fallback
  return '''
تم اكتشاف أن هذا الجهاز قد يكون محاكي.

🔍 التفاصيل التقنية:
$reason

⚠️ هذا التطبيق لا يعمل على المحاكيات لأسباب أمنية.
إذا كنت تستخدم جهاز حقيقي، يرجى التواصل مع الدعم الفني وإرسال لقطة شاشة لهذه الرسالة.
''';
}

Future<String> _getDeviceInfoString() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    return '''
╔════════════════════════════════════════╗
║        معلومات الجهاز - Device Info   ║
╚════════════════════════════════════════╝

📱 الجهاز الأساسي:
   • العلامة التجارية: ${androidInfo.brand}
   • الموديل: ${androidInfo.model}
   • الجهاز: ${androidInfo.device}
   • المنتج: ${androidInfo.product}

🔧 المواصفات التقنية:
   • المصنّع: ${androidInfo.manufacturer}
   • الهاردوير: ${androidInfo.hardware}
   • النوع: ${androidInfo.type}
   • المضيف: ${androidInfo.host}

💿 نظام التشغيل:
   • إصدار أندرويد: ${androidInfo.version.release}
   • SDK: ${androidInfo.version.sdkInt}
   • Security Patch: ${androidInfo.version.securityPatch}

🔐 معلومات البناء:
   • Tags: ${androidInfo.tags}
   • Fingerprint: ${androidInfo.fingerprint.length > 50 ? '${androidInfo.fingerprint.substring(0, 50)}...' : androidInfo.fingerprint}

✅ الحالة:
   • جهاز فيزيائي: ${androidInfo.isPhysicalDevice ? 'نعم ✓' : 'لا ✗'}
   • معرّف الجهاز: ${androidInfo.id}
''';
  }
  return "❌ النظام ليس أندرويد";
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
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App Logo or Icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          isWarning
                              ? Icons.warning_amber_rounded
                              : Icons.error_outline,
                          size: 80,
                          color: isWarning ? Colors.orange : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Title
                      Text(
                        'عذراً، لا يمكن تشغيل التطبيق',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isWarning
                              ? Colors.orange[700]
                              : Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Message Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue[700],
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'سبب الخطأ:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Device Details
                      if (details != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxHeight: 300),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone_android,
                                        color: Colors.grey[700],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'تفاصيل الجهاز',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '(للدعم الفني)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Flexible(
                                child: SingleChildScrollView(
                                  child: SelectableText(
                                    details,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      // Support Message
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.support_agent,
                              color: Colors.blue[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'يرجى التواصل مع الدعم الفني وإرسال لقطة شاشة لهذه الرسالة',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue[900],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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

      final String host = androidInfo.host;
      final String device = androidInfo.device;
      final String brand = androidInfo.brand;
      final String model = androidInfo.model;
      final String product = androidInfo.product;
      final String fingerprint = androidInfo.fingerprint;

      // Define known real device brands for later checks
      List<String> realDeviceBrands = [
        'samsung',
        'xiaomi',
        'redmi',
        'oppo',
        'vivo',
        'huawei',
        'honor',
        'realme',
        'oneplus',
        'motorola',
        'nokia',
        'sony',
        'lg',
        'asus',
        'lenovo',
        'google',
        'htc',
        'tcl',
      ];

      bool isKnownBrand = realDeviceBrands.any(
        (b) => brand.toLowerCase().contains(b),
      );

      // ============================================
      // STRONG CHECKS - Block regardless of brand
      // ============================================

      // 1. Check for specific emulator paths (STRONGEST evidence)
      List<String> ldPlayerPaths = [
        '/storage/emulated/0/storage/secure',
        '/storage/emulated/0/Android/data/com.android.ld.appstore',
      ];
      for (String path in ldPlayerPaths) {
        if (await Directory(path).exists()) {
          return "Found emulator path: $path (STRONG EVIDENCE)";
        }
      }

      // 2. Check for Ubuntu/AOSP combination (STRONG evidence)
      if (host.toLowerCase() == 'ubuntu' && device.toLowerCase() == 'aosp') {
        return "Host: $host, Device: $device (STRONG EVIDENCE)";
      }

      // 3. Check for explicit emulator/SDK strings (STRONG evidence)
      if (product.contains('sdk') ||
          product.contains('emulator') ||
          model.contains('Emulator') ||
          model.contains('Android SDK') ||
          fingerprint.contains('generic/')) {
        return "Explicit emulator signature in product/model (STRONG EVIDENCE)";
      }

      // ============================================
      // WEAK CHECKS - Allow exceptions for known brands
      // ============================================

      // 4. Check for test-keys (WEAK - many custom ROMs have this)
      if (fingerprint.contains('test-keys')) {
        if (isKnownBrand) {
          debugPrint(
            "⚠️ Device has test-keys but is known brand ($brand) - ALLOWING",
          );
          // Don't block - could be custom ROM on real device
        } else {
          return "Fingerprint contains test-keys (unknown brand)";
        }
      }

      // 5. Check for generic fingerprint (WEAK - some real devices have this)
      if (fingerprint.contains('generic')) {
        if (isKnownBrand) {
          debugPrint(
            "⚠️ Device has generic fingerprint but is known brand ($brand) - ALLOWING",
          );
          // Don't block
        } else {
          return "Fingerprint contains 'generic' (unknown brand)";
        }
      }

      // ============================================
      // FINAL CHECK - isPhysicalDevice
      // ============================================

      // 6. Only use isPhysicalDevice for unknown brands
      if (!androidInfo.isPhysicalDevice) {
        if (isKnownBrand) {
          debugPrint(
            "✅ Device marked as non-physical but is known brand: $brand - ALLOWING",
          );
          return null;
        }

        // Unknown brand + non-physical = do final generic check
        bool isGenericEmulator = await EmulatorChecker.isEmulator();
        if (isGenericEmulator) {
          return "Generic EmulatorChecker detected (non-physical, unknown brand)";
        }
      }
    }
  } catch (e) {
    debugPrint("Emulator check error: $e");
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
  } catch (e) {}
  return false;
}

bool isVersionOlder(String local, String remote) {
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
