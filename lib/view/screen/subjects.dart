// ignore_for_file: must_be_iacademyv3utable

import 'package:daliluna_altaalimi/view/widget/breadcrumb_widget.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/subjects_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcardsubjects.dart';
import 'package:shimmer/shimmer.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';

class Subjects extends GetView<SubjectsController> {
  Subjects({super.key});
  late BasketController baskerc;

  @override
  Widget build(BuildContext context) {
    baskerc = Get.put(BasketController());

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
                "المواد",
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
        //   leading: CustomIconAppBar(),
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
        //       "المواد",
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
        // body: GetBuilder<SubjectsController>(
        //     builder: (controller) => controller.isLoadingtow
        //         ? controller.dataList.isNotEmpty
        //             ? AnimationLimiter(
        //                 child: GlowingOverscrollIndicator(
        //                   axisDirection: AxisDirection.down,
        //                   color: AppColor.SecondryColor,
        //                   child: GridView.builder(
        //                     gridDelegate:
        //                         SliverGridDelegateWithMaxCrossAxisExtent(
        //                       maxCrossAxisExtent: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 300,
        //                         tablet: 600,
        //                       ),
        //                       childAspectRatio: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 8 / 8,
        //                         tablet: 8 / 5,
        //                       ),
        //                       crossAxisSpacing: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 7,
        //                         tablet: 10,
        //                       ),
        //                       mainAxisSpacing: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 15,
        //                         tablet: 30,
        //                       ),
        //                     ),
        //                     scrollDirection: Axis.vertical,
        //                     shrinkWrap: false,
        //                     itemCount: controller.dataList.length,
        //                     itemBuilder: (BuildContext context, int index) {
        //                       return AnimationConfiguration.staggeredList(
        //                         position: index,
        //                         duration: const Duration(milliseconds: 500),
        //                         child: SlideAnimation(
        //                           horizontalOffset: 200.0,
        //                           curve: Curves.easeInToLinear,
        //                           duration: const Duration(milliseconds: 600),
        //                           child: FadeInAnimation(
        //                             child: CustomCardSubjects(
        //                               onTap: () {
        //                                 baskerc.updatelessonName(
        //                                     controller.dataList[index]['name']);
        //
        //                                 baskerc.updatelessonId(
        //                                     controller.dataList[index]['id']);
        //
        //                                 print(
        //                                     controller.dataList[index]['name']);
        //                                 print(Get.arguments['lessonid']);
        //                                 print(controller.dataList[index]['id']);
        //                                 controller.goToTeachers(
        //                                     Get.arguments['lessonid'],
        //                                     controller.dataList[index]['id']);
        //                               },
        //                               text: controller.dataList[index]['name'],
        //                               nameImage: controller.dataList[index]
        //                                   ['image'],
        //                             ),
        //                           ),
        //                         ),
        //                       );
        //                     },
        //                   ),
        //                 ),
        //               )
        //             : Center(child: Text("لا يوجد مواد"))
        //         : Loading()),
        body: Column(
          children: [
            const BreadcrumbWidget(),
            Expanded(
              child: GetBuilder<SubjectsController>(
                builder: (controller) => controller.isLoadingtow
                    ? controller.dataList.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.only(
                                top: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 10,
                                  tablet: 20,
                                ),
                                bottom: 100, // لو في Floating Button
                              ),
                              itemCount: controller.dataList.length,
                              itemBuilder: (context, index) {
                                final item = controller.dataList[index];
                                return SubjectListItem(
                                  name: item['name'],
                                  imageUrl: item['image'],
                                  onTap: () {
                                    baskerc.updatelessonName(item['name']);
                                    baskerc.updatelessonId(item['id']);
                                    controller.goToTeachers(
                                      Get.arguments['lessonid'],
                                      item['id'],
                                    );
                                  },
                                );
                              },
                            )
                          : Center(child: Text("لا يوجد مواد"))
                    : Loading(),
              ),
            ),
          ],
        ),

        floatingActionButton:
         SizedBox(
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
            child: BasketWidget(heroTag: "eleven"),

        ),
      ),
    );
  }
}
