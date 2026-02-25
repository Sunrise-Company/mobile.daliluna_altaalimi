// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/pdfLessons.dart';
import 'package:daliluna_altaalimi/view/widget/customcardsubject.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:daliluna_altaalimi/controller/home_controller.dart';

class Pdfs extends StatelessWidget {
  final List pdfs;
  final bool isLoading;
  final bool isPurchased;

  final homeController = Get.put(HomeController());
  Pdfs(this.pdfs, this.isLoading, {this.isPurchased = false});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Loading()
            : pdfs.length != 0
            ? ListView.builder(
                itemCount: pdfs.length,
                itemBuilder: (BuildContext context, index) {
                  final bool isLocked =
                      !isPurchased &&
                      pdfs[index]['free_status'].toString() != '1';

                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: getValueForScreenType<double>(
                        context: context,
                        mobile: 20,
                        tablet: 40,
                      ),
                      horizontal: getValueForScreenType<double>(
                        context: context,
                        mobile: 10,
                        tablet: 20,
                      ),
                    ),
                    child: Column(
                      children: [
                        Opacity(
                          opacity: isLocked ? 0.6 : 1.0,
                          child: Stack(
                            children: [
                              CustomCardSubject(
                                text: pdfs[index]['name'],
                                onTap: () async {
                                  if (isLocked) {
                                    Get.snackbar(
                                      homeController.isDeployed == 1
                                          ? "محتوى حصري للمشتركين"
                                          : "المحتوى سيكون متاحاً قريباً",
                                      homeController.isDeployed == 1
                                          ? "اشترك في القسم للوصول إلى هذا الملف وكل المحتوى."
                                          : "شكراً لاهتمامك، انتظرونا قريباً.",
                                      icon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppColor.PrimaryColor,
                                      colorText: Colors.white,
                                      margin: EdgeInsets.all(15),
                                      borderRadius: 12,
                                      duration: Duration(seconds: 4),
                                    );
                                    return;
                                  }

                                  if (pdfs[index]['file'] != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return pdfLessons(
                                            isUrl: true,
                                            name: pdfs[index]['name'],
                                            url:
                                                '${AppLink.baseUrl}/storage/' +
                                                pdfs[index]['file'],
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    final String? linkStr = pdfs[index]['link'];

                                    // Check if link is null or empty
                                    if (linkStr == null || linkStr.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('لا يوجد رابط متاح'),
                                        ),
                                      );
                                      return;
                                    }

                                    // استخراج الروابط من النص
                                    final urlPattern = RegExp(
                                      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
                                      caseSensitive: false,
                                    );
                                    final matches = urlPattern.allMatches(
                                      linkStr,
                                    );
                                    final List<String> extractedUrls = matches
                                        .map((m) => m.group(0)!)
                                        .toList();

                                    log('النص الكامل: $linkStr');
                                    log('الروابط المستخرجة: $extractedUrls');

                                    // عرض dialog مع النص والروابط
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          pdfs[index]['name'] ?? 'رابط',
                                          style: const TextStyle(
                                            color: AppColor.PrimaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // عرض النص الكامل
                                              SelectableText(
                                                linkStr,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          // إذا وُجدت روابط، اعرض زر لفتح الرابط
                                          if (extractedUrls.isNotEmpty)
                                            TextButton.icon(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                // فتح الرابط في متصفح داخل التطبيق
                                                final url = Uri.parse(
                                                  extractedUrls.first,
                                                );
                                                await launchUrl(
                                                  url,
                                                  mode: LaunchMode
                                                      .inAppBrowserView,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.open_in_new,
                                              ),
                                              label: const Text('فتح الرابط'),
                                            ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('إغلاق'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                onTapShop: () {},
                              ),
                              if (isLocked)
                                Positioned.fill(
                                  child: InkWell(
                                    onTap: () {
                                      Get.snackbar(
                                        homeController.isDeployed == 1
                                            ? "محتوى حصري للمشتركين"
                                            : "المحتوى سيكون متاحاً قريباً",
                                        homeController.isDeployed == 1
                                            ? "اشترك في القسم للوصول إلى هذا الملف وكل المحتوى."
                                            : "شكراً لاهتمامك، انتظرونا قريباً.",
                                        icon: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                        ),
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: AppColor.PrimaryColor,
                                        colorText: Colors.white,
                                        margin: EdgeInsets.all(15),
                                        borderRadius: 12,
                                        duration: Duration(seconds: 4),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(child: Text("لا يوجد ملفات")),
      ),
    );
  }
}
