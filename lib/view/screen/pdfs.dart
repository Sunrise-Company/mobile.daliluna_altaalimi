// ignore_for_file: must_be_immutable

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/pdfLessons.dart';
import 'package:daliluna_altaalimi/view/widget/customcardsubject.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';

class Pdfs extends StatelessWidget {
  final List pdfs;
  final bool isLoading;
  Pdfs(this.pdfs, this.isLoading);

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
                          onTap: () {
                            print(pdfs[index]['file']);
                            pdfs[index]['file'] != null
                                ? Navigator.push(
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
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return pdfLessons(
                                          name: pdfs[index]['name'],
                                          isUrl: true,
                                          url: pdfs[index]['link'],
                                        );
                                      },
                                    ),
                                  );
                            // pdfs[index]['link'] != null
                            //     ? print(pdfs[index]['link'])
                            //     : print(pdfs[index]['file']);
                            // Get.toNamed(AppRoute.viewPdf);
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
