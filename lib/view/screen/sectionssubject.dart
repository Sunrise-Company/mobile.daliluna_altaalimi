// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:daliluna_altaalimi/view/widget/customcardmycourses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/sectionssubject_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcardsections.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';
import 'package:daliluna_altaalimi/view/widget/customiconbasket.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';

class SectionsSubject extends GetView<SectionsSubjectController> {
  SectionsSubject({super.key});
  late BasketController baskerc;

  @override
  Widget build(BuildContext context) {
    baskerc = Get.put(BasketController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                "الاقسام",
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
        //   preferredSize: Size.fromHeight(
        //     getValueForScreenType<double>(
        //       context: context,
        //       mobile: 55,
        //       tablet: 100,
        //     ),
        //   ),
        //   child: AppBar(
        //     leading: CustomIconAppBar(),
        //     actions: [
        //       Obx(
        //         () => CustomIconBasket(
        //             text: baskerc.mycart.length != 0
        //                 ? baskerc.mycart.length.toString()
        //                 : "0"),
        //       ),
        //     ],
        //     elevation: 0,
        //     flexibleSpace: Container(
        //       decoration: const BoxDecoration(
        //         gradient: LinearGradientPainter(
        //           begin: Alignment.topRight,
        //           end: Alignment.topCenter,
        //           colors: <Color>[AppColor.SecondryColor2, AppColor.DeepPurple],
        //         ),
        //       ),
        //     ),
        //     title: Text(
        //       "الأقسام",
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
        // body: GetBuilder<SectionsSubjectController>(
        //   builder: (controller) => controller.isLoadingtow
        //       ? controller.dataList.isNotEmpty
        //           ? SingleChildScrollView(
        //               child: AnimationLimiter(
        //                 child: Column(
        //                   children: [
        //                     ListView.builder(
        //                       padding: EdgeInsets.symmetric(
        //                         vertical: getValueForScreenType<double>(
        //                           context: context,
        //                           mobile: 20,
        //                           tablet: 40,
        //                         ),
        //                         horizontal: getValueForScreenType<double>(
        //                           context: context,
        //                           mobile: 40,
        //                           tablet: 60,
        //                         ),
        //                       ),
        //                       physics: NeverScrollableScrollPhysics(),
        //                       shrinkWrap: true,
        //                       itemCount: controller.dataList.length,
        //                       itemBuilder: (context, index) {
        //                         final item = controller.dataList[index];
        //                         log('main dep type ${item['main_dep']['type'].toString()}');
        //                         return Obx(() {
        //                           final bool isChecking =
        //                               controller.checkingSectionId.value ==
        //                                   item['id'];
        //
        //                           return AnimationConfiguration.staggeredList(
        //                             position: index,
        //                             duration: const Duration(milliseconds: 500),
        //                             child: SlideAnimation(
        //                               horizontalOffset: 150.0,
        //                               curve: Curves.easeInQuint,
        //                               duration:
        //                                   const Duration(milliseconds: 700),
        //                               child: FadeInAnimation(
        //                                 child: item['main_dep']['type']
        //                                             .toString() !=
        //                                         '4'
        //                                     ? CustomCardSections(
        //                                         item: item,
        //                                         isChecking: isChecking,
        //                                         onTap: () {
        //                                           controller
        //                                               .navigateToSection(item);
        //                                         },
        //                                         onTapShop: () {
        //                                           baskerc.updateBasket(
        //                                             item['id'].toString(),
        //                                             'section',
        //                                             item['name'],
        //                                             item['price'],
        //                                             baskerc.teacherName
        //                                                 .toString(),
        //                                             baskerc.className
        //                                                 .toString(),
        //                                             baskerc.subjectName
        //                                                 .toString(),
        //                                             baskerc.teacherId
        //                                                 .toString(),
        //                                             baskerc.classId.toString(),
        //                                             baskerc.subjectId
        //                                                 .toString(),
        //                                             baskerc.maindepId
        //                                                 .toString(),
        //                                           );
        //                                           print('customvideo');
        //                                         },
        //                                         countVideos:
        //                                             item['lesson_dep_files_count']
        //                                                     ?.toString() ??
        //                                                 '0',
        //                                         price: item['price'].toString(),
        //                                         section: item['name'],
        //                                         sectionId:
        //                                             item['id'].toString(),
        //                                         teacherId: baskerc.teacherId
        //                                             .toString(),
        //                                         subjectId: baskerc.subjectId
        //                                             .toString(),
        //                                         classId:
        //                                             baskerc.classId.toString(),
        //                                       )
        //                                     : CustomCardMyCourses(
        //                                         onTap: () {
        //                                           controller
        //                                               .navigateToSection(item);
        //                                         },
        //                                         section: item['name'],
        //                                       ),
        //                               ),
        //                             ),
        //                           );
        //                         });
        //                       },
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             )
        //           : Center(child: Text("لا يوجد "))
        //       : Loading(),
        // ),
        body: GetBuilder<SectionsSubjectController>(
          builder: (controller) => controller.isLoadingtow
              ? controller.dataList.isNotEmpty
                    ? SingleChildScrollView(
                        child: AnimationLimiter(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                              vertical: getValueForScreenType<double>(
                                context: context,
                                mobile: 15,
                                tablet: 25,
                              ),
                              horizontal: getValueForScreenType<double>(
                                context: context,
                                mobile: 10,
                                tablet: 40,
                              ),
                            ),
                            itemCount: controller.dataList.length,
                            itemBuilder: (context, index) {
                              final item = controller.dataList[index];
                              log(
                                'main dep type ${item['main_dep']['type'].toString()}',
                              );

                              return Obx(() {
                                final bool isChecking =
                                    controller.checkingSectionId.value ==
                                    item['id'];

                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    horizontalOffset: 120.0,
                                    duration: const Duration(milliseconds: 700),
                                    child: FadeInAnimation(
                                      child:
                                          item['main_dep']['type'].toString() !=
                                              '4'
                                          ? CustomListTileSection(
                                              item: item,
                                              isChecking: isChecking,
                                              onTap: () {
                                                controller.navigateToSection(
                                                  item,
                                                );
                                              },
                                              onTapShop: () {
                                                baskerc.updateBasket(
                                                  item['id'].toString(),
                                                  'section',
                                                  item['name'],
                                                  item['price'],
                                                  baskerc.teacherName
                                                      .toString(),
                                                  baskerc.className.toString(),
                                                  baskerc.subjectName
                                                      .toString(),
                                                  baskerc.teacherId.toString(),
                                                  baskerc.classId.toString(),
                                                  baskerc.subjectId.toString(),
                                                  baskerc.maindepId.toString(),
                                                );
                                              },
                                            )
                                          : CustomListTileMyCourses(
                                              section: item['name'],
                                              onTap: () {
                                                controller.navigateToSection(
                                                  item,
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      )
                    : const Center(child: Text("لا يوجد"))
              : const Loading(),
        ),

        floatingActionButton: Obx(
          () => SizedBox(
            width: getValueForScreenType<double>(
              context: context,
              mobile: 56, // العرض على الموبايل
              tablet: 80, // العرض على التابلت
            ),
            height: getValueForScreenType<double>(
              context: context,
              mobile: 56, // الارتفاع على الموبايل
              tablet: 80, // الارتفاع على التابلت
            ),
            child: BasketWidget(heroTag: "ten"),
          ),
        ),
      ),
    );
  }
}
