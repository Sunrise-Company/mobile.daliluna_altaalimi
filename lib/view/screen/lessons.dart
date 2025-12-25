// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:daliluna_altaalimi/view/widget/custombuttonbuy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/lesson_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:daliluna_altaalimi/view/widget/breadcrumb_widget.dart';

import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';

class Lessons extends GetView<LessonsController> {
  Lessons({super.key});
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
                "الدروس",
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
        //     title: Text(
        //       "الدروس",
        //       style: TextStyle(
        //         color: AppColor.White,
        //         fontSize: getValueForScreenType<double>(
        //           context: context,
        //           mobile: 20,
        //           tablet: 30,
        //         ),
        //       ),
        //     ),
        //     backgroundColor: AppColor.DeepPurple,
        //     elevation: 0.0,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.vertical(
        //         bottom: Radius.circular(
        //           getValueForScreenType<double>(
        //             context: context,
        //             mobile: 30,
        //             tablet: 60,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // body: GetBuilder<LessonsController>(
        //     builder: (controller) => controller.isloaded
        //         ? controller.dataList.isNotEmpty
        //             ? SingleChildScrollView(
        //                 child: AnimationLimiter(
        //                   child: Column(
        //                     children: [
        //                       ListView.builder(
        //                         padding: EdgeInsets.symmetric(
        //                           vertical: getValueForScreenType<double>(
        //                             context: context,
        //                             mobile: 20,
        //                             tablet: 40,
        //                           ),
        //                           horizontal: getValueForScreenType<double>(
        //                             context: context,
        //                             mobile: 30,
        //                             tablet: 60,
        //                           ),
        //                         ),
        //                         physics: NeverScrollableScrollPhysics(),
        //                         shrinkWrap: true,
        //                         itemCount: controller.dataList.length,
        //                         itemBuilder: (context, index) {
        //                           return Obx(() {
        //                             final bool isChecking =
        //                                 controller.checkingSectionId.value ==
        //                                     controller.dataList[index]['id'];
        //
        //                             return AnimationConfiguration.staggeredList(
        //                               position: index,
        //                               duration:
        //                                   const Duration(milliseconds: 500),
        //                               child: SlideAnimation(
        //                                 horizontalOffset: 150.0,
        //                                 curve: Curves.easeOutBack,
        //                                 duration:
        //                                     const Duration(milliseconds: 700),
        //                                 child: FadeInAnimation(
        //                                     child: CustomCardLesson(
        //                                   isChecking: isChecking,
        //                                   item: controller.dataList[index],
        //                                   lesson: controller.dataList[index]
        //                                               ['name'] !=
        //                                           null
        //                                       ? controller.dataList[index]
        //                                           ['name']
        //                                       : "-",
        //                                   price: controller.dataList[index]
        //                                               ['price'] !=
        //                                           null
        //                                       ? controller.dataList[index]
        //                                               ['price']
        //                                           .toString()
        //                                       : "-",
        //                                   count: controller.dataList[index][
        //                                           'app_lesson_lecture_files_count']
        //                                       .toString(),
        //                                   onTapShop: () {
        //                                     baskerc.updateBasket(
        //                                       controller.dataList[index]['id']
        //                                           .toString(),
        //                                       'lesson',
        //                                       controller.dataList[index]
        //                                           ['name'],
        //                                       controller.dataList[index]
        //                                           ['price'],
        //                                       baskerc.teacherName.toString(),
        //                                       baskerc.className.toString(),
        //                                       baskerc.subjectName.toString(),
        //                                       baskerc.teacherId.toString(),
        //                                       baskerc.classId.toString(),
        //                                       baskerc.subjectId.toString(),
        //                                       baskerc.maindepId.toString(),
        //                                     );
        //                                     print('lessson add success');
        //                                   },
        //                                   onTap: () {
        //                                     log(controller.dataList[index]
        //                                         .toString());
        //                                     controller.navigateToSection(
        //                                         controller.dataList[index]);
        //                                   },
        //                                 )),
        //                               ),
        //                             );
        //                           });
        //                         },
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               )
        //             : Center(child: Text("لا يوجد"))
        //         : Loading()),
        body: Column(
          children: [
            const BreadcrumbWidget(),
            Expanded(
              child: GetBuilder<LessonsController>(
                builder: (controller) => controller.isloaded
                    ? controller.dataList.isNotEmpty
                          ? SingleChildScrollView(
                              child: AnimationLimiter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: getValueForScreenType<double>(
                                      context: context,
                                      mobile: 15,
                                      tablet: 30,
                                    ),
                                    horizontal: getValueForScreenType<double>(
                                      context: context,
                                      mobile: 15,
                                      tablet: 40,
                                    ),
                                  ),
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controller.dataList.length,
                                    itemBuilder: (context, index) {
                                      return Obx(() {
                                        final bool isChecking =
                                            controller
                                                .checkingSectionId
                                                .value ==
                                            controller.dataList[index]['id'];

                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          child: SlideAnimation(
                                            horizontalOffset: 150.0,
                                            curve: Curves.easeOutBack,
                                            duration: const Duration(
                                              milliseconds: 700,
                                            ),
                                            child: FadeInAnimation(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          AppColor.PrimaryColor,
                                                      blurRadius: 6,
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        horizontal:
                                                            getValueForScreenType<
                                                              double
                                                            >(
                                                              context: context,
                                                              mobile: 15,
                                                              tablet: 25,
                                                            ),
                                                        vertical:
                                                            getValueForScreenType<
                                                              double
                                                            >(
                                                              context: context,
                                                              mobile: 8,
                                                              tablet: 12,
                                                            ),
                                                      ),
                                                  leading: Icon(
                                                    Icons.play_circle_fill,
                                                    color: AppColor.grey,
                                                    size:
                                                        getValueForScreenType<
                                                          double
                                                        >(
                                                          context: context,
                                                          mobile: 59,
                                                          tablet: 59,
                                                        ),
                                                  ),
                                                  title: Text(
                                                    controller
                                                            .dataList[index]['name'] ??
                                                        "-",
                                                    style: TextStyle(
                                                      fontSize:
                                                          getValueForScreenType<
                                                            double
                                                          >(
                                                            context: context,
                                                            mobile: 16,
                                                            tablet: 22,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColor.PrimaryColor,
                                                    ),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 6.0,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.folder_open,
                                                          size: 18,
                                                          color: AppColor
                                                              .SecondryColor,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "عدد الملفات: ${controller.dataList[index]['app_lesson_lecture_files_count']}",
                                                          style: TextStyle(
                                                            fontSize:
                                                                getValueForScreenType<
                                                                  double
                                                                >(
                                                                  context:
                                                                      context,
                                                                  mobile: 12,
                                                                  tablet: 16,
                                                                ),
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          "${controller.dataList[index]['price'] ?? '-'}",
                                                          style: TextStyle(
                                                            fontSize:
                                                                getValueForScreenType<
                                                                  double
                                                                >(
                                                                  context:
                                                                      context,
                                                                  mobile: 13,
                                                                  tablet: 18,
                                                                ),
                                                            color: AppColor
                                                                .PrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  trailing: Obx(() {
                                                    final isInMySections = controller.mylectures.any((
                                                      section,
                                                    ) {
                                                      final dep = section;

                                                      if (dep != null) {
                                                        return dep['app_unit_id']
                                                                    .toString() ==
                                                                controller
                                                                    .dataList[index]['app_unit_id']
                                                                    .toString() &&
                                                            dep['app_lesson_id']
                                                                    .toString() ==
                                                                controller
                                                                    .dataList[index]['app_lesson_id']
                                                                    .toString() &&
                                                            dep['app_class_id']
                                                                    .toString() ==
                                                                controller
                                                                    .dataList[index]['app_class_id']
                                                                    .toString();
                                                      }
                                                      return false;
                                                    });

                                                    if (isInMySections) {
                                                      return SizedBox(
                                                        width:
                                                            getValueForScreenType<
                                                              double
                                                            >(
                                                              context: context,
                                                              mobile: 90,
                                                              tablet: 150,
                                                            ),
                                                        height:
                                                            getValueForScreenType<
                                                              double
                                                            >(
                                                              context: context,
                                                              mobile: 40,
                                                              tablet: 50,
                                                            ),
                                                        child: Card(
                                                          elevation: 3,
                                                          color: AppColor
                                                              .SecondryColor2,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Text(
                                                                "تم الاشتراك",
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      getValueForScreenType<
                                                                        double
                                                                      >(
                                                                        context:
                                                                            context,
                                                                        mobile:
                                                                            10,
                                                                        tablet:
                                                                            17,
                                                                      ),
                                                                  color: AppColor
                                                                      .DeepPurple,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .check_circle,
                                                                size:
                                                                    getValueForScreenType<
                                                                      double
                                                                    >(
                                                                      context:
                                                                          context,
                                                                      mobile:
                                                                          17,
                                                                      tablet:
                                                                          22,
                                                                    ),
                                                                color: AppColor
                                                                    .SecondryColor,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    return CustomButtonBuy(
                                                      onTap: () {
                                                        baskerc.updateBasket(
                                                          controller
                                                              .dataList[index]['id']
                                                              .toString(),
                                                          'lesson',
                                                          controller
                                                              .dataList[index]['name'],
                                                          controller
                                                              .dataList[index]['price'],
                                                          baskerc.teacherName
                                                              .toString(),
                                                          baskerc.className
                                                              .toString(),
                                                          baskerc.subjectName
                                                              .toString(),
                                                          baskerc.teacherId
                                                              .toString(),
                                                          baskerc.classId
                                                              .toString(),
                                                          baskerc.subjectId
                                                              .toString(),
                                                          baskerc.maindepId
                                                              .toString(),
                                                          baskerc.instituteId
                                                              .toString(),
                                                          controller
                                                              .dataList[index]['app_unit_id']
                                                              .toString(),
                                                        );
                                                        print(
                                                          'lesson add success',
                                                        );
                                                      },
                                                    );
                                                  }),

                                                  onTap: () {
                                                    log(
                                                      controller.dataList[index]
                                                          .toString(),
                                                    );
                                                    controller
                                                        .navigateToSection(
                                                          controller
                                                              .dataList[index],
                                                        );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                          : const Center(child: Text("لا يوجد"))
                    : Loading(),
              ),
            ),
          ],
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
            child: BasketWidget(heroTag: "three"),
          ),
        ),
      ),
    );
  }
}
