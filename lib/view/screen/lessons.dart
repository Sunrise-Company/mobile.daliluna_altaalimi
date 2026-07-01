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
import 'package:daliluna_altaalimi/core/constant/cart_keys.dart';
import 'package:daliluna_altaalimi/view/widget/breadcrumb_widget.dart';
import '../../controller/home_controller.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';

class Lessons extends GetView<LessonsController> {
  Lessons({super.key});
  late BasketController baskerc;
  final homeController = Get.put(HomeController());

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
        //       "ط§ظ„ط¯ط±ظˆط³",
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
                                                          top: 10.0,
                                                        ),
                                                    child: Wrap(
                                                      spacing: 8,
                                                      runSpacing: 8,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      children: [
                                                        // Files Count Badge
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 4,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[100],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            border: Border.all(
                                                              color: Colors
                                                                  .grey[300]!,
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .file_copy_outlined,
                                                                size: 14,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "${controller.dataList[index]['app_lesson_lecture_files_count']} ملف",
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      getValueForScreenType<
                                                                        double
                                                                      >(
                                                                        context:
                                                                            context,
                                                                        mobile:
                                                                            11,
                                                                        tablet:
                                                                            14,
                                                                      ),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey[800],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Price Badge
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 4,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                AppColor
                                                                    .SecondryColor.withOpacity(
                                                                  0.12,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            border: Border.all(
                                                              color:
                                                                  AppColor
                                                                      .SecondryColor.withOpacity(
                                                                    0.3,
                                                                  ),
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          child:
                                                              (homeController
                                                                      .isDeployed ==
                                                                  1)
                                                              ? Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .payments_outlined,
                                                                      size: 14,
                                                                      color: AppColor
                                                                          .PrimaryColor,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      "${controller.dataList[index]['price'] ?? '0'}",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            getValueForScreenType<
                                                                              double
                                                                            >(
                                                                              context: context,
                                                                              mobile: 12,
                                                                              tablet: 15,
                                                                            ),
                                                                        color: AppColor
                                                                            .PrimaryColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Text(
                                                                      "ل.س",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            getValueForScreenType<
                                                                              double
                                                                            >(
                                                                              context: context,
                                                                              mobile: 10,
                                                                              tablet: 12,
                                                                            ),
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: AppColor
                                                                            .PrimaryColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : SizedBox(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  trailing: Obx(() {
                                                    final currentLessonId =
                                                        controller
                                                            .dataList[index]['id']
                                                            ?.toString();

                                                    // ملاحظة: نتحقق من ID الدرس المحدد فقط
                                                    final isInMySections =
                                                        controller.mylectures.any((
                                                          section,
                                                        ) {
                                                          if (section != null) {
                                                            final purchasedLessonId =
                                                                section['id']
                                                                    ?.toString();

                                                            //التحقق من مطابقة ID الدرس
                                                            if (purchasedLessonId ==
                                                                currentLessonId) {
                                                              return true;
                                                            }
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

                                                    return (homeController
                                                                .isDeployed ==
                                                            1)
                                                        ? CustomButtonBuy(
                                                            onTap: () async {
                                                              var res = await baskerc.updateBasket(
                                                                controller
                                                                    .dataList[index]['id']
                                                                    .toString(),
                                                                'lesson',
                                                                controller
                                                                    .dataList[index]['name'],
                                                                controller
                                                                    .dataList[index]['price'],
                                                                baskerc
                                                                    .teacherName
                                                                    .toString(),
                                                                baskerc
                                                                    .className
                                                                    .toString(),
                                                                baskerc
                                                                    .subjectName
                                                                    .toString(),
                                                                baskerc
                                                                    .teacherId
                                                                    .toString(),
                                                                baskerc.classId
                                                                    .toString(),
                                                                baskerc
                                                                    .subjectId
                                                                    .toString(),
                                                                baskerc
                                                                    .maindepId
                                                                    .toString(),
                                                                baskerc
                                                                    .instituteId
                                                                    .toString(),
                                                                controller
                                                                    .dataList[index]['app_unit_id']
                                                                    .toString(),
                                                              );
                                                              print(
                                                                'lesson add success',
                                                              );
                                                              return res;
                                                            },
                                                            targetCartKey:
                                                                CartAnimationKeys
                                                                    .lessons,
                                                          )
                                                        : SizedBox();
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
                          : const Center(child: Text("لا يوجد دروس"))
                    : Loading(),
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          width: getValueForScreenType<double>(
            context: context,
            mobile: 56, // ط§ظ„ط¹ط±ط¶ ط¹ظ„ظ‰ ط§ظ„ظ…ظˆط¨ط§ظٹظ„
            tablet: 80, // ط§ظ„ط¹ط±ط¶ ط¹ظ„ظ‰ ط§ظ„طھط§ط¨ظ„طھ
          ),
          height: getValueForScreenType<double>(
            context: context,
            mobile: 56, // ط§ظ„ط§ط±طھظپط§ط¹ ط¹ظ„ظ‰ ط§ظ„ظ…ظˆط¨ط§ظٹظ„
            tablet: 80, // ط§ظ„ط§ط±طھظپط§ط¹ ط¹ظ„ظ‰ ط§ظ„طھط§ط¨ظ„طھ
          ),
          child: BasketWidget(
            heroTag: "three",
            customKey: CartAnimationKeys.lessons,
          ),
        ),
      ),
    );
  }
}
