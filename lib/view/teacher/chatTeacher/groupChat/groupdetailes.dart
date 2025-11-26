import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widget/GetValueForScreen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> groupData;

  GroupDetailsScreen({required this.groupData});

  @override
  Widget build(BuildContext context) {
    final teacher = groupData['teacher']?['name'] ?? "مجهول";
    final students = (groupData['students'] as List?) ?? [];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            getValueForScreenType<double>(
              context: context,
              mobile: 55,
              tablet: 100,
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColor.PrimaryColor,
            title: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: AppColor.SecondryColor,
              child: Text(
                "تفاصيل المجموعة",
                style: TextStyle(
                  fontSize: responsiveValue(
                    context: context,
                    mobile: 20,
                    tablet: 35,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(70),
        //   child: AppBar(
        //     elevation: 0,
        //     flexibleSpace: Container(
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomRight,
        //           colors: <Color>[
        //             AppColor.DeepPurple,
        //             AppColor.PrimaryColor,
        //           ],
        //         ),
        //       ),
        //     ),
        //     title: Text(
        //       'تفاصيل المجموعة',
        //       style: TextStyle(color: AppColor.White, fontSize: 20),
        //     ),
        //     centerTitle: true,
        //     iconTheme: IconThemeData(color: AppColor.White),
        //   ),
        // ),
        // body: Container(
        //   color: Colors.white,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Card(
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(15),
        //           ),
        //           elevation: 5,
        //           color: Colors.white.withOpacity(0.9),
        //           child: ListTile(
        //             leading: Icon(Icons.person, color: AppColor.PrimaryColor),
        //             title: Text(
        //               'المعلم: $teacher',
        //               style:
        //                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //             ),
        //           ),
        //         ),
        //         SizedBox(height: 15),
        //         Text(
        //           'الطلاب:',
        //           style: TextStyle(
        //             fontSize: 16,
        //             fontWeight: FontWeight.bold,
        //             color: AppColor.black,
        //           ),
        //         ),
        //         SizedBox(height: 10),
        //         Expanded(
        //           child: students.isEmpty
        //               ? Center(
        //                   child: Text(
        //                     'لا يوجد طلاب في هذه المجموعة',
        //                     style:
        //                         TextStyle(color: AppColor.White, fontSize: 16),
        //                   ),
        //                 )
        //               : ListView.builder(
        //                   itemCount: students.length,
        //                   itemBuilder: (context, index) {
        //                     return Card(
        //                       shape: RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(12),
        //                       ),
        //                       elevation: 3,
        //                       color: Colors.white.withOpacity(0.9),
        //                       child: ListTile(
        //                         leading: Icon(Icons.person,
        //                             color: AppColor.PrimaryColor),
        //                         title: Text(
        //                           students[index]['arabic_name'],
        //                           style: TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.w500),
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                 ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ====== قسم المشرف ======
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    color: AppColor.SecondryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: responsiveValue(
                          context: context,
                          mobile: 45,
                          tablet: 60,
                        ),
                        height: responsiveValue(
                          context: context,
                          mobile: 45,
                          tablet: 60,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColor.SecondryColor2,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المشرف',
                              style: TextStyle(
                                fontSize: responsiveValue(
                                  context: context,
                                  mobile: 15,
                                  tablet: 20,
                                ),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              teacher,
                              style: TextStyle(
                                fontSize: responsiveValue(
                                  context: context,
                                  mobile: 17,
                                  tablet: 22,
                                ),
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ====== عنوان الطلاب ======
                const Text(
                  'الطلاب',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                /// ====== قائمة الطلاب ======
                Expanded(
                  child: students.isEmpty
                      ? const Center(
                          child: Text(
                            'لا يوجد طلاب في هذه المجموعة',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: students.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            final student = students[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: responsiveValue(
                                      context: context,
                                      mobile: 22,
                                      tablet: 30,
                                    ),
                                    backgroundColor: AppColor.SecondryColor,
                                    child: const Icon(
                                      Icons.person_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      student['arabic_name'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
