import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/view/teacher/pdf.dart';
import 'package:daliluna_altaalimi/view/teacher/VediosWithoutAppBarTeacher.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/viewlesson_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/teacherController/lessonDepsFileTeacherController.dart';
import '../widget/GetValueForScreen.dart';

class ViewSectionTeacher extends GetView<TeacherLessonDepsFileContrlloer> {
  ViewSectionTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ViewLessonController());
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
        //     leading: CustomIconAppBar(),
        //     elevation: 0.0,
        //     flexibleSpace: Container(
        //       decoration: BoxDecoration(
        //         gradient: LinearGradientPainter(
        //           begin: Alignment.topRight,
        //           end: Alignment.centerLeft,
        //           colors: <Color>[AppColor.PrimaryColor, AppColor.DeepPurple],
        //         ),
        //       ),
        //     ),
        //     title: Text(
        //       controller.name.toString(),
        //       style: TextStyle(
        //         color: AppColor.White,
        //         fontSize: getValueForScreenType<double>(
        //           context: context,
        //           mobile: 20,
        //           tablet: 30,
        //         ),
        //       ),
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
                controller.name.toString(),
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
        // body: DefaultTabController(
        //   length: 2,
        //   child: Column(
        //     children: [
        //       TabBar(
        //         padding: EdgeInsets.all(
        //           getValueForScreenType<double>(
        //             context: context,
        //             mobile: 10,
        //             tablet: 20,
        //           ),
        //         ),
        //         indicatorColor: AppColor.DeepPurple,
        //         tabs: [
        //           Tab(
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               children: [
        //                 Text(
        //                   "الفيديوهات",
        //                   style: TextStyle(
        //                     color: AppColor.PrimaryColor,
        //                     fontSize: getValueForScreenType<double>(
        //                       context: context,
        //                       mobile: 13,
        //                       tablet: 17,
        //                     ),
        //                   ),
        //                 ),
        //                 Icon(
        //                   Icons.video_collection_rounded,
        //                   color: AppColor.SecondryColor,
        //                   size: 25,
        //                 )
        //               ],
        //             ),
        //           ),
        //           Tab(
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               children: [
        //                 Text(
        //                   "الملفات",
        //                   style: TextStyle(
        //                     color: AppColor.PrimaryColor,
        //                     fontSize: getValueForScreenType<double>(
        //                       context: context,
        //                       mobile: 13,
        //                       tablet: 17,
        //                     ),
        //                   ),
        //                 ),
        //                 Icon(
        //                   Icons.picture_as_pdf_rounded,
        //                   color: AppColor.SecondryColor,
        //                   size: 25,
        //                 )
        //               ],
        //             ),
        //           ),
        //         ],
        //         onTap: (index) {
        //           controller.changeTabIndex(index);
        //         },
        //       ),
        //       Expanded(
        //         child: GetBuilder<TeacherLessonDepsFileContrlloer>(
        //           builder: (controller) {
        //             return TabBarView(
        //               children: [
        //                 VediosWithoutAppBarTeacher(
        //                     controller.dataListvidoe, controller.isloded.value),
        //                 PdfsTeacher(
        //                     controller.dataListfile, controller.isloded.value)
        //               ],
        //             );
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getValueForScreenType<double>(
                    context: context,
                    mobile: 8,
                    tablet: 16,
                  ),
                  horizontal: getValueForScreenType<double>(
                    context: context,
                    mobile: 10,
                    tablet: 20,
                  ),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColor.SecondryColor2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColor.PrimaryColor,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getValueForScreenType<double>(
                      context: context,
                      mobile: 13,
                      tablet: 17,
                    ),
                  ),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
                  onTap: (index) {
                    controller.changeTabIndex(index);
                  },
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_collection_rounded,
                            color: AppColor.PrimaryColor,
                            size: 24,
                          ),
                          SizedBox(width: 6),
                          Text("الفيديوهات"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_as_pdf_rounded,
                            color: AppColor.PrimaryColor,
                            size: 24,
                          ),
                          SizedBox(width: 6),
                          Text("الملفات"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GetBuilder<TeacherLessonDepsFileContrlloer>(
                  builder: (controller) {
                    return TabBarView(
                      children: [
                        VediosWithoutAppBarTeacher(
                          controller.dataListvidoe,
                          controller.isloded.value,
                        ),
                        PdfsTeacher(
                          controller.dataListfile,
                          controller.isloded.value,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
