// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/pdfLessons.dart';
import 'package:daliluna_altaalimi/view/widget/customcardsubject.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';

class PdfsTeacher extends StatelessWidget {
  final List pdfs;
  final bool isLoading;
  PdfsTeacher(this.pdfs, this.isLoading);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Loading() // إذا كان التحميل جارياً، اعرض مؤشر التحميل
            : pdfs.length != 0
            ? ListView.builder(
                itemCount: pdfs.length,
                itemBuilder: (BuildContext context, index) {
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
                        CustomCardSubject(
                          text: pdfs[index]['name'],
// <<<<<<< lib/view/teacher/pdf.dart
                          isFree:  int.tryParse(pdfs[index]['free_status'].toString()),
                          onTap: () {
                            print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz${pdfs[index]['free_status']}");

                            pdfs[index]['file'] != null
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return pdfLessons(
                                          name: pdfs[index]['name'],
                                          isUrl: true,
                                          url:
                                              '${AppLink.baseUrl}/storage/' +
                                              pdfs[index]['file'],
                                        );
                                      },
// =======
                          onTap: () async {
                            if (pdfs[index]['file'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return pdfLessons(
                                      name: pdfs[index]['name'],
                                      isUrl: true,
                                      url:
                                          '${AppLink.baseUrl}/storage/' +
                                          pdfs[index]['file'],
                                    );
                                  },
                                ),
                              );
                            } else {
                              final String? linkStr = pdfs[index]['link'];

                              if (linkStr == null || linkStr.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('لا يوجد رابط متاح'),
                                  ),
                                );
                                return;
                              }

                              final urlPattern = RegExp(
                                r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
                                caseSensitive: false,
                              );
                              final matches = urlPattern.allMatches(linkStr);
                              final List<String> extractedUrls = matches
                                  .map((m) => m.group(0)!)
                                  .toList();

                              log('النص الكامل: $linkStr');
                              log('الروابط المستخرجة: $extractedUrls');

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    pdfs[index]['name'] ?? 'رابط',
                                    style: const TextStyle(
                                      color: AppColor.PrimaryColor,
                                      fontWeight: FontWeight.bold,
// >>>>>>> lib/view/teacher/pdf.dart
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                    if (extractedUrls.isNotEmpty)
                                      TextButton.icon(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          final url = Uri.parse(
                                            extractedUrls.first,
                                          );
                                          await launchUrl(
                                            url,
                                            mode: LaunchMode.inAppBrowserView,
                                          );
                                        },
                                        icon: const Icon(Icons.open_in_new),
                                        label: const Text('فتح الرابط'),
                                      ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('إغلاق'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          onTapShop: () {},
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
