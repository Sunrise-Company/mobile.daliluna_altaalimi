// ignore_for_file: must_be_iacademyv3utable

import 'package:daliluna_altaalimi/view/widget/breadcrumb_widget.dart';
import 'package:daliluna_altaalimi/view/widget/customwidgetviewteacher.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/teacher_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:shimmer/shimmer.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';

class Teacher extends GetView<TeacherController> {
  Teacher({super.key});
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
                "الاساتذة",
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
        // backgroundColor: AppColor.BackGround2,
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
        //     backgroundColor: AppColor.DeepPurple,
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
        //     title: Text(
        //       "الأساتذة",
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
        body: Column(
          children: [
            const BreadcrumbWidget(),
            Expanded(
              child: GetBuilder<TeacherController>(
                builder: (controller) => controller.isLoadingtow
                    ? controller.dataList.isNotEmpty
                          ? AnimationLimiter(
                              child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color: AppColor.SecondryColor,
                                child: GridView.builder(
                                  padding: EdgeInsets.all(
                                    getValueForScreenType<double>(
                                      context: context,
                                      mobile: 15,
                                      tablet: 30,
                                    ),
                                  ),
                                  shrinkWrap: false,
                                  physics: BouncingScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing:
                                            getValueForScreenType<double>(
                                              context: context,
                                              mobile: 10,
                                              tablet: 20,
                                            ),
                                        mainAxisSpacing:
                                            getValueForScreenType<double>(
                                              context: context,
                                              mobile: 15,
                                              tablet: 30,
                                            ),
                                        childAspectRatio:
                                            getValueForScreenType<double>(
                                              context: context,
                                              mobile: 0.8,
                                              tablet: 0.7,
                                            ),
                                      ),
                                  itemCount: controller.dataList.length,
                                  itemBuilder: (context, index) {
                                    final teacher = controller.dataList[index];
                                    return DisplayTeacher(
                                      index,
                                      teacher,
                                      context,
                                      () {
                                        baskerc.updateteacherName(
                                          teacher['name'],
                                        );
                                        baskerc.updateteacherId(
                                          teacher['id'].toString(),
                                        );
                                        controller.goToSections(
                                          Get.arguments['subjetcsid']
                                              .toString(),
                                          teacher['id'].toString(),
                                          Get.arguments['classid'],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                          : Center(child: Text("لا يوجد أساتذة"))
                    : Loading(),
              ),
            ),
          ],
        ), // body: GetBuilder<TeacherController>(
        //     builder: (controller) => controller.isLoadingtow
        //         ? controller.dataList.isNotEmpty
        //             ? SingleChildScrollView(
        //                 child: Container(
        //                   padding: EdgeInsets.all(
        //                     getValueForScreenType<double>(
        //                       context: context,
        //                       mobile: 20,
        //                       tablet: 40,
        //                     ),
        //                   ),
        //                   child: AnimationLimiter(
        //                     child: Column(
        //                       children: [
        //                         ListView.separated(
        //                           physics: NeverScrollableScrollPhysics(),
        //                           separatorBuilder: (context, index) =>
        //                               SizedBox(
        //                             height: getValueForScreenType<double>(
        //                               context: context,
        //                               mobile: 30,
        //                               tablet: 50,
        //                             ),
        //                           ),
        //                           shrinkWrap: true,
        //                           itemCount: controller.dataList.length,
        //                           itemBuilder: (context, index) {
        //                             return AnimationConfiguration.staggeredList(
        //                               position: index,
        //                               duration:
        //                                   const Duration(milliseconds: 500),
        //                               child: SlideAnimation(
        //                                 horizontalOffset: 150.0,
        //                                 curve: Curves.decelerate,
        //                                 duration:
        //                                     const Duration(milliseconds: 700),
        //                                 child: FadeInAnimation(
        //                                     child: CustomWidgetViewTeacher(
        //                                         onTap: () {
        //                                           baskerc.updateteacherName(
        //                                               controller.dataList[index]
        //                                                       ['name']
        //                                                   .toString());
        //
        //                                           baskerc.updateteacherId(
        //                                               controller.dataList[index]
        //                                                       ['id']
        //                                                   .toString());
        //                                           print(Get
        //                                               .arguments['subjetcsid']
        //                                               .toString());
        //                                           print(
        //                                               Get.arguments['classid']);
        //                                           print('ddddddddddd');
        //                                           controller.goToSections(
        //                                               Get.arguments[
        //                                                       'subjetcsid']
        //                                                   .toString(),
        //                                               controller.dataList[index]
        //                                                       ['id']
        //                                                   .toString(),
        //                                               Get.arguments['classid']);
        //                                         },
        //                                         name: controller.dataList[index]
        //                                             ['name'],
        //                                         assetName: controller
        //                                                         .dataList[index]
        //                                                     ['image'] !=
        //                                                 null
        //                                             ? controller.dataList[index]
        //                                                 ['image']
        //                                             : "-")),
        //                               ),
        //                             );
        //                           },
        //                         )
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               )
        //             : Center(child: Text("لا يوجد أساتذة"))
        //         : Loading()
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
          child: BasketWidget(heroTag: "twelve"),
        ),
      ),
    );
  }
}
