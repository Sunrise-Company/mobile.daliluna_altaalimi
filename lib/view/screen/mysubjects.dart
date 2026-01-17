import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/subjects_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/customcard.dart';

class MySubjects extends GetView<SubjectsController> {
  MySubjects({super.key});

  @override
  Widget build(BuildContext context) {
    BasketController baskerc = Get.put(BasketController());
    Get.put(SubjectsController());
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
                "موادي",
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
        // appBar:
        // PreferredSize(
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
        //       decoration: BoxDecoration(
        //         gradient: LinearGradientPainter(
        //           begin: Alignment.topRight,
        //           end: Alignment.topCenter,
        //           colors: <Color>[AppColor.SecondryColor2, AppColor.DeepPurple],
        //         ),
        //       ),
        //     ),
        //     title: Text(
        //       "موادي",
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
        body: GetBuilder<SubjectsController>(
          builder: (controller) => controller.isLoading
              ? controller.mySubjects.isNotEmpty
                    ? AnimationLimiter(
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: AppColor.SecondryColor,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: false,
                            itemCount: controller.mySubjects.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  horizontalOffset: 200.0,
                                  curve: Curves.ease,
                                  duration: const Duration(milliseconds: 600),
                                  child: FadeInAnimation(
                                    child: CustomCard(
                                      onTap: () {
                                        print(
                                          controller.mySubjects[index]['name'],
                                        );
                                        log(
                                          controller.mySubjects[index]
                                              .toString(),
                                        );
                                        controller.goToMyTeachers(
                                          controller.mySubjects[index]['id'],
                                          controller
                                              .mySubjects[index]['app_class_id'],
                                        );
                                      },
                                      text:
                                          controller.mySubjects[index]['name'],
                                      nameImage:
                                          controller.mySubjects[index]['image'],
                                    ),
                                    // text: controller.myClassess[index]['name'],
                                    // onTap: () {
                                    //   controller.goToMySubjects(
                                    //     controller.myClassess[index]['id'],
                                    //   );
                                    // },
                                    // nameImage: controller.myClassess[index]['image'] != null
                                    //     ? controller.dataList[index]['image']
                                    //     : "-",
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    // AnimationLimiter(
                    //             child: GlowingOverscrollIndicator(
                    //               axisDirection: AxisDirection.down,
                    //               color: AppColor.SecondryColor,
                    //               child: GridView.builder(
                    //                 gridDelegate:
                    //                     SliverGridDelegateWithMaxCrossAxisExtent(
                    //                   maxCrossAxisExtent: getValueForScreenType<double>(
                    //                     context: context,
                    //                     mobile: 300,
                    //                     tablet: 600,
                    //                   ),
                    //                   childAspectRatio: getValueForScreenType<double>(
                    //                     context: context,
                    //                     mobile: 8 / 8,
                    //                     tablet: 8 / 5,
                    //                   ),
                    //                   crossAxisSpacing: getValueForScreenType<double>(
                    //                     context: context,
                    //                     mobile: 7,
                    //                     tablet: 10,
                    //                   ),
                    //                   mainAxisSpacing: getValueForScreenType<double>(
                    //                     context: context,
                    //                     mobile: 15,
                    //                     tablet: 30,
                    //                   ),
                    //                 ),
                    //                 scrollDirection: Axis.vertical,
                    //                 shrinkWrap: false,
                    //                 itemCount: controller.mySubjects.length,
                    //                 itemBuilder: (BuildContext context, int index) {
                    //                   return AnimationConfiguration.staggeredList(
                    //                     position: index,
                    //                     duration: const Duration(milliseconds: 500),
                    //                     child: SlideAnimation(
                    //                       horizontalOffset: 200.0,
                    //                       curve: Curves.easeInToLinear,
                    //                       duration: const Duration(milliseconds: 600),
                    //                       child: FadeInAnimation(
                    //                         child: CustomCardSubjects(
                    //                           onTap: () {
                    //                             print(controller.mySubjects[index]
                    //                                 ['name']);
                    //                             log(controller.mySubjects[index]
                    //                                 .toString());
                    //                             controller.goToMyTeachers(
                    //                               controller.mySubjects[index]['id'],
                    //                               controller.mySubjects[index]
                    //                                   ['app_class_id'],
                    //                             );
                    //                           },
                    //                           text: controller.mySubjects[index]
                    //                               ['name'],
                    //                           nameImage: controller.mySubjects[index]
                    //                               ['image'],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           )
                    : Center(child: Text("لا يوجد مواد"))
              : Loading(),
        ),

        // floatingActionButton: Obx(
        //   () => SizedBox(
        //     width: getValueForScreenType<double>(
        //       context: context,
        //       mobile: 56, // العرض على الموبايل
        //       tablet: 80, // العرض على التابلت
        //     ),
        //     height: getValueForScreenType<double>(
        //       context: context,
        //       mobile: 56, // الارتفاع على الموبايل
        //       tablet: 80, // الارتفاع على التابلت
        //     ),
        //     child: BasketWidget(heroTag: "six"),
        //   ),
        // ),
      ),
    );
  }
}
