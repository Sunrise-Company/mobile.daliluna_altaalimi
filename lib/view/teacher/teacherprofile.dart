import 'package:daliluna_altaalimi/controller/teacherController/teacherProfile.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constant/color.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/customreadmore.dart';
import '../widget/customtitle.dart';

class TeacherProfileWidget extends StatelessWidget {
  final TeacherProfileController teacherController = Get.put(
    TeacherProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(
        //     getValueForScreenType<double>(
        //       context: context,
        //       mobile: 55,
        //       tablet: 100,
        //     ),
        //   ),
        //   child: AppBar(
        //     titleSpacing: getValueForScreenType<double>(
        //       context: context,
        //       mobile: 30,
        //       tablet: 50,
        //     ),
        //     elevation: 0,
        //     flexibleSpace: Container(
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomRight,
        //           colors: <Color>[AppColor.DeepPurple, AppColor.PrimaryColor],
        //         ),
        //       ),
        //     ),
        //     title: const Text(
        //       "البروفايل",
        //       style: TextStyle(color: AppColor.White),
        //     ),
        //   ),
        // ),
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
                "الملف الشخصي ",
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
        body: Obx(() {
          final image = teacherController.image.value;
          final name = teacherController.arabicName.value;
          final description = "${teacherController.description.value}";
          final education = teacherController.education.value;

          return ResponsiveBuilder(
            builder: (context, sizingInformation) {
              final isTablet =
                  sizingInformation.deviceScreenType == DeviceScreenType.tablet;

              final imageHeight = MediaQuery.of(context).size.height * 0.5;
              final borderRadius = isTablet ? 40.0 : 30.0;
              final horizontalPadding = isTablet ? 40.0 : 20.0;

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    /// ✅ صورة المدرس بالخلفية العلوية
                    Container(
                      height: imageHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            image.isNotEmpty
                                ? AppLink.image + "/" + image
                                : 'https://placehold.co/600x400',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: imageHeight - 40),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: isTablet ? 35 : 25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: const Offset(0, -2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// الاسم
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: responsiveValue(
                                context: context,
                                mobile: 20,
                                tablet: 30,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            height: responsiveValue(
                              context: context,
                              mobile: 20,
                              tablet: 30,
                            ),
                          ),

                          /// التعليم
                          if (education.isNotEmpty &&
                              education != 'تعليم غير متوفر')
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20 : 14,
                                vertical: isTablet ? 10 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.SecondryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: AppColor.SecondryColor,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                education,
                                style: TextStyle(
                                  color: AppColor.SecondryColor,
                                  fontSize: responsiveValue(
                                    context: context,
                                    mobile: 14,
                                    tablet: 20,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          const SizedBox(height: 25),

                          /// العنوان "الوصف"
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomTitle(text: "الوصف"),
                          ),
                          const SizedBox(height: 10),

                          /// نص الوصف (بشكل مختصر إذا طويل)
                          CustomReadMore(text: description),

                          const SizedBox(height: 25),

                          // Institutes Section
                          if (teacherController.institutes.isNotEmpty) ...[
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomTitle(text: "المعهد"),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                direction: Axis.horizontal,
                                children: teacherController.institutes.map((
                                  inst,
                                ) {
                                  // Handle if inst is String or Object
                                  String name = "";
                                  if (inst is String) {
                                    name = inst;
                                  } else if (inst is Map &&
                                      inst['name'] != null) {
                                    name = inst['name'];
                                  }

                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.PrimaryColor.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColor
                                            .PrimaryColor.withOpacity(0.5),
                                      ),
                                    ),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        color: AppColor.PrimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],

                          // Classes/Subjects Section
                          if (teacherController.classes.isNotEmpty) ...[
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomTitle(text: "المواد"),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: teacherController.classes.map((cls) {
                                  String name = "";
                                  if (cls is String) {
                                    name = cls;
                                  } else if (cls is Map &&
                                      cls['name'] != null) {
                                    name = cls['name'];
                                  }

                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.DeepPurple.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColor.DeepPurple.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        color: AppColor.DeepPurple,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),

        // body: Center(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Obx(() => Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             SizedBox(height: 40),
        //             Row(
        //               children: [
        //                 CircleAvatar(
        //                   radius: 48,
        //                   backgroundImage: NetworkImage(AppLink.image +
        //                       '/' +
        //                       teacherController
        //                           .image.value), // Use the fetched image
        //                 ),
        //                 SizedBox(width: 8),
        //                 Text(
        //                   teacherController
        //                       .arabicName.value, // Display the fetched name
        //                   style: TextStyle(
        //                     fontSize: 17,
        //                     fontWeight: FontWeight.bold,
        //                     color: AppColor.DeepPurple,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             SizedBox(height: 16),
        //             Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Container(
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(15),
        //                   color: AppColor.BackGround,
        //                 ),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(14.0),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         'الوصف:',
        //                         style: TextStyle(
        //                           fontSize: 17,
        //                           color: AppColor.DeepPurple,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: [
        //                           Flexible(
        //                             child: Text(
        //                               teacherController.description
        //                                   .value, // Display the fetched description
        //                               style: TextStyle(fontSize: 15),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                       SizedBox(height: 8),
        //                       Text(
        //                         'التعليم:',
        //                         textAlign: TextAlign.center,
        //                         style: TextStyle(
        //                             fontSize: 17,
        //                             color: AppColor.DeepPurple,
        //                             fontWeight: FontWeight.bold),
        //                       ),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: [
        //                           Container(
        //                               child: Flexible(
        //                             child: Text(
        //                                 teacherController.education
        //                                     .value, // Display the fetched education
        //                                 style: TextStyle(fontSize: 15)),
        //                           )),
        //                         ],
        //                       ),
        //                       SizedBox(height: 8),
        //                       // Text(
        //                       //   'المواد:',
        //                       //   textAlign:
        //                       //       TextAlign.center,
        //                       //   style:
        //                       //       TextStyle(fontSize:
        //                       //           17, color:
        //                       //           AppColor.DeepPurple, fontWeight:
        //                       //           FontWeight.bold),
        //                       // ),
        //                       // Row(
        //                       //   mainAxisAlignment:
        //                       //       MainAxisAlignment.start,
        //                       //   children:
        //                       //       [
        //                       //         Container(child:
        //                       //             Text('مادة العلوم, مادة اللغة العربية',
        //                       //             style:
        //                       //                 TextStyle(fontSize:
        //                       //                     15))),
        //                       //       ],
        //                       // ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         )),
        //   ),
        // ),
      ),
    );
  }
}
