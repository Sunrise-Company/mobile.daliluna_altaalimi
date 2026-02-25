import 'package:daliluna_altaalimi/core/constant/imageasset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/lessondetails_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/widget/customreadmore.dart';
import 'package:daliluna_altaalimi/view/widget/customtitle.dart';
import 'package:daliluna_altaalimi/view/widget/customwidgetteacher.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:daliluna_altaalimi/view/widget/teacherloaad.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';

class LessonDetailsPage extends GetView<LessonDetailsController> {
  const LessonDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LessonDetailsController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
        //       "معلومات الاستاذ",
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
                "الملف الشخصي للأستاذ",
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
        // body: GetBuilder<LessonDetailsController>(
        //     builder: (controller) => controller.isLoading
        //         ? controller.dataList.isNotEmpty
        //             ? SingleChildScrollView(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     // TeacherLoad(),
        //
        //                     CustomWidgetTeacher(
        //                       assetName: controller.dataList['teacher_info']
        //                                       ?['image'] !=
        //                                   null &&
        //                               controller.dataList['teacher_info']![
        //                                       'image'] !=
        //                                   ''
        //                           ? AppLink.image +
        //                               "/" +
        //                               controller
        //                                   .dataList['teacher_info']!['image']
        //                           : 'https://placehold.co/200x200',
        //                       nameTeacher: controller.dataList['teacher_info']
        //                               ?['name'] ??
        //                           '',
        //                       aboutTeacher: controller.dataList['teacher_info']
        //                               ?['education'] ??
        //                           '',
        //                     ),
        //
        //                     Container(
        //                       width: MediaQuery.of(context).size.width,
        //                       color: AppColor.BackGround2,
        //                       child: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           CustomTitle(text: "الوصف"),
        //                           CustomReadMore(
        //                               text: controller.dataList['teacher_info']
        //                                       ['description']
        //                                   .toString()),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               )
        //             : Center(child: Text("لا يوجد "))
        //         : Loading()),
        body: GetBuilder<LessonDetailsController>(
          builder: (controller) => controller.isLoading
              ? controller.dataList.isNotEmpty
                    ? ResponsiveBuilder(
                        builder: (context, sizingInformation) {
                          final isTablet =
                              sizingInformation.deviceScreenType ==
                              DeviceScreenType.tablet;

                          final imageHeight =
                              MediaQuery.of(context).size.height * 0.5;
                          final borderRadius = isTablet ? 40.0 : 30.0;
                          final horizontalPadding = isTablet ? 40.0 : 20.0;

                          return SingleChildScrollView(
                            child: Stack(
                              children: [
                                /// ✅ صورة المدرس بالخلفية العلوية
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          controller.dataList['teacher_info']?['image'] !=
                                                  null &&
                                              controller
                                                      .dataList['teacher_info']?['image'] !=
                                                  ''
                                          ? NetworkImage(
                                              AppLink.image +
                                                  "/" +
                                                  controller
                                                      .dataList['teacher_info']!['image'],
                                            )
                                          : AssetImage(AppImageAsset.logo)
                                                as ImageProvider,
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
                                  margin: EdgeInsets.only(
                                    top: imageHeight - 40,
                                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        controller
                                                .dataList['teacher_info']?['name'] ??
                                            '',
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

                                      // if (controller
                                      //             .dataList['teacher_info']?['education'] !=
                                      //         '' &&
                                      //     controller
                                      //             .dataList['teacher_info']?['education'] !=
                                      //         null) ...[
                                      //   Container(
                                      //     padding: EdgeInsets.symmetric(
                                      //       horizontal: isTablet ? 20 : 14,
                                      //       vertical: isTablet ? 10 : 8,
                                      //     ),
                                      //     decoration: BoxDecoration(
                                      //       color: AppColor
                                      //           .SecondryColor.withOpacity(0.1),
                                      //       borderRadius: BorderRadius.circular(
                                      //         25,
                                      //       ),
                                      //       border: Border.all(
                                      //         color: AppColor.SecondryColor,
                                      //         width: 1.2,
                                      //       ),
                                      //     ),
                                      //     child: Text(
                                      //       controller
                                      //               .dataList['teacher_info']?['education'] ??
                                      //           '',
                                      //       style: TextStyle(
                                      //         color: AppColor.SecondryColor,
                                      //         fontSize: responsiveValue(
                                      //           context: context,
                                      //           mobile: 14,
                                      //           tablet: 20,
                                      //         ),
                                      //         fontWeight: FontWeight.w600,
                                      //       ),
                                      //     ),
                                      //   ),
                                      //   const SizedBox(height: 25),
                                      // ],
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CustomTitle(text: "الوصف"),
                                      ),
                                      const SizedBox(height: 10),

                                      CustomReadMore(
                                        text: controller
                                            .dataList['teacher_info']!['description']
                                            .toString(),
                                      ),

                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(child: Text("لا يوجد"))
              : const Loading(),
        ),
        floatingActionButton: SizedBox(
          width: getValueForScreenType<double>(
            context: context,
            mobile: 56,
            tablet: 80,
          ),
          height: getValueForScreenType<double>(
            context: context,
            mobile: 56,
            tablet: 80,
          ),
          child: BasketWidget(heroTag: "two"),
        ),
      ),
    );
  }
}
