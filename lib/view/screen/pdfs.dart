// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/pdfLessons.dart';
import 'package:daliluna_altaalimi/view/widget/customcardsubject.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';

class Pdfs extends StatelessWidget {
  final List pdfs;
  final bool isLoading;
  final bool isPurchased;

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
                                      "محتوى حصري للمشتركين",
                                      "اشترك في القسم للوصول إلى هذا الملف وكل المحتوى.",
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

                                    // Check if it's a valid URL
                                    final bool isValidUrl =
                                        linkStr.startsWith('http://') ||
                                        linkStr.startsWith('https://');
                                    log(linkStr.toString());
                                    // Show dialog with the link
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          pdfs[index]['name'] ?? 'رابط خارجي',
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
                                              const Text(
                                                'الرابط:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              _buildClickableText(
                                                linkStr,
                                                context,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          if (isValidUrl)
                                            TextButton.icon(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                try {
                                                  final Uri url = Uri.parse(
                                                    linkStr,
                                                  );
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode
                                                        .externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'لا يمكن فتح الرابط',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'خطأ في فتح الرابط: $e',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.open_in_browser,
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
                                        "محتوى حصري للمشتركين",
                                        "اشترك في القسم للوصول إلى هذا الملف وكل المحتوى.",
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
                                      ), // Adjust based on card margin
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

  // Helper method to build clickable text with URLs
  Widget _buildClickableText(String text, BuildContext context) {
    final urlPattern = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );

    final matches = urlPattern.allMatches(text);

    if (matches.isEmpty) {
      // No URLs found, return plain text
      return SelectableText(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      );
    }

    // Build text with clickable URLs
    final spans = <TextSpan>[];
    int currentPosition = 0;

    for (final match in matches) {
      // Add text before URL
      if (match.start > currentPosition) {
        spans.add(
          TextSpan(
            text: text.substring(currentPosition, match.start),
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        );
      }

      // Add clickable URL
      final url = match.group(0)!;
      spans.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              try {
                final Uri uri = Uri.parse(url);
                if (!await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                )) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('لا يمكن فتح الرابط')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطأ في فتح الرابط: $e')),
                );
              }
            },
        ),
      );

      currentPosition = match.end;
    }

    // Add remaining text after last URL
    if (currentPosition < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentPosition),
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      );
    }

    return SelectableText.rich(TextSpan(children: spans));
  }
}
