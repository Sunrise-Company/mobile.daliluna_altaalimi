import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/ourcourses_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcard.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/GetValueForScreen.dart';
import '../widget/customDrawer.dart';

class MyCourses extends StatelessWidget {
  MyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    // LoginController logincontroller = Get.put(LoginController());
    // logincontroller.checkIfLogin();
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: customDrawer(context),

      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(
      //     getValueForScreenType<double>(
      //       context: context,
      //       mobile: 55,
      //       tablet: 100,
      //     ),
      //   ),
      //   child: AppBar(
      //     actions: [
      //       Obx(() {
      //         return Row(
      //           children: [
      //             logincontroller.isLoginsuccess == true
      //                 ? InkWell(
      //                     onTap: () {
      //                       logincontroller.logout();
      //                     },
      //                     child: Row(
      //                       children: [
      //                         Text(
      //                           "تسجيل الخروج",
      //                           style: TextStyle(
      //                             color: AppColor.PrimaryColor,
      //                             fontSize: getValueForScreenType<double>(
      //                               context: context,
      //                               mobile: 12,
      //                               tablet: 15,
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(
      //                           width: getValueForScreenType<double>(
      //                             context: context,
      //                             mobile: 5,
      //                             tablet: 10,
      //                           ),
      //                         ),
      //                         Icon(
      //                           Icons.logout_rounded,
      //                           color: AppColor.PrimaryColor,
      //                           size: getValueForScreenType<double>(
      //                             context: context,
      //                             mobile: 20,
      //                             tablet: 40,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   )
      //                 : InkWell(
      //                     onTap: () {
      //                       Get.toNamed(AppRoute.login);
      //                     },
      //                     child: Row(
      //                       children: [
      //                         Text(
      //                           "تسجيل الدخول",
      //                           style: TextStyle(
      //                             color: AppColor.PrimaryColor,
      //                             fontSize: getValueForScreenType<double>(
      //                               context: context,
      //                               mobile: 12,
      //                               tablet: 15,
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(
      //                           width: getValueForScreenType<double>(
      //                             context: context,
      //                             mobile: 5,
      //                             tablet: 10,
      //                           ),
      //                         ),
      //                         Icon(
      //                           Icons.login,
      //                           color: AppColor.PrimaryColor,
      //                           size: getValueForScreenType<double>(
      //                             context: context,
      //                             mobile: 20,
      //                             tablet: 40,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //           ],
      //         );
      //       })
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
      //     titleSpacing: getValueForScreenType<double>(
      //       context: context,
      //       mobile: 30,
      //       tablet: 50,
      //     ),
      //     title: const Text(
      //       "دوراتي",
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
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                size: getValueForScreenType<double>(
                  context: context,
                  mobile: 25,
                  tablet: 40,
                ),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),

          // leading: IconButton(
          //   icon: Icon(
          //     Icons.menu,
          //     color: Colors.white,
          //     size: getValueForScreenType<double>(
          //       context: context,
          //       mobile: 25,
          //       tablet: 40,
          //     ),
          //   ),
          //   onPressed: () {
          //     Scaffold.of(context).openDrawer();
          //   },
          // ),
          title: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: AppColor.SecondryColor,
            child: Text(
              "دوراتي",
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
      body: GetBuilder<OurCoursesController>(
        builder: (controller) => controller.myClassess.length == 0
            ? Center(
                child: Text(
                  "لا يوجد لديك اشتراك في الدورات",
                  style: TextStyle(
                    fontSize: getValueForScreenType<double>(
                      context: context,
                      mobile: 15,
                      tablet: 25,
                    ),
                    color: AppColor.grey,
                  ),
                ),
              )
            :
              // AnimationLimiter(
              //         child: GlowingOverscrollIndicator(
              //           axisDirection: AxisDirection.down,
              //           color: AppColor.SecondryColor,
              //           child: GridView.builder(
              //             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //               maxCrossAxisExtent: getValueForScreenType<double>(
              //                 context: context,
              //                 mobile: 300,
              //                 tablet: 600,
              //               ),
              //               childAspectRatio: getValueForScreenType<double>(
              //                 context: context,
              //                 mobile: 8 / 8,
              //                 tablet: 8 / 5,
              //               ),
              //               crossAxisSpacing: getValueForScreenType<double>(
              //                 context: context,
              //                 mobile: 7,
              //                 tablet: 10,
              //               ),
              //               mainAxisSpacing: getValueForScreenType<double>(
              //                 context: context,
              //                 mobile: 15,
              //                 tablet: 30,
              //               ),
              //             ),
              //             scrollDirection: Axis.vertical,
              //             shrinkWrap: false,
              //             itemCount: controller.myClassess.length,
              //             itemBuilder: (BuildContext context, int index) {
              //               return AnimationConfiguration.staggeredList(
              //                 position: index,
              //                 duration: const Duration(milliseconds: 500),
              //                 child: SlideAnimation(
              //                   horizontalOffset: 200.0,
              //                   curve: Curves.ease,
              //                   duration: const Duration(milliseconds: 600),
              //                   child: FadeInAnimation(
              //                     child: CustomCard(
              //                       text: controller.myClassess[index]['name'],
              //                       onTap: () {
              //                         controller.goToMySubjects(
              //                             controller.myClassess[index]['id']);
              //                       },
              //                       nameImage: controller.myClassess[index]
              //                                   ['image'] !=
              //                               null
              //                           ? controller.dataList[index]['image']
              //                           : "-",
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              AnimationLimiter(
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: AppColor.SecondryColor,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemCount: controller.myClassess.length,
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
                              text: controller.myClassess[index]['name'],
                              subtitleWidget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller
                                              .myClassess[index]['institute_name'] !=
                                          null ||
                                      controller
                                              .myClassess[index]['institute'] !=
                                          null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.school_outlined,
                                            size: getValueForScreenType<double>(
                                              context: context,
                                              mobile: 14,
                                              tablet: 18,
                                            ),
                                            color: AppColor.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            controller
                                                    .myClassess[index]['institute_name'] ??
                                                controller
                                                    .myClassess[index]['institute']['name'] ??
                                                '',
                                            style: TextStyle(
                                              color: AppColor.grey,
                                              fontSize:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 12,
                                                    tablet: 16,
                                                  ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (controller
                                              .myClassess[index]['institute'] !=
                                          null &&
                                      controller
                                              .myClassess[index]['institute']['address'] !=
                                          null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: getValueForScreenType<double>(
                                              context: context,
                                              mobile: 14,
                                              tablet: 18,
                                            ),
                                            color: AppColor.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              controller
                                                  .myClassess[index]['institute']['address'],
                                              style: TextStyle(
                                                color: AppColor.grey,
                                                fontSize:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 11,
                                                      tablet: 15,
                                                    ),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              onTap: () {
                                controller.goToMySubjects(
                                  controller.myClassess[index]['id'],
                                );
                              },
                              nameImage: controller.myClassess[index]['image'],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
