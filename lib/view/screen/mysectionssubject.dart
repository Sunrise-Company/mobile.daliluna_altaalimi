import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/sectionssubject_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcardmycourses.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';
import 'package:daliluna_altaalimi/view/widget/customiconbasket.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';

class MySectionsSubject extends GetView<SectionsSubjectController> {
  MySectionsSubject({super.key});

  @override
  Widget build(BuildContext context) {
    BasketController baskerc = Get.put(BasketController());
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
        body: GetBuilder<SectionsSubjectController>(
          builder: (controller) => controller.isLoading
              ? controller.dataList.isNotEmpty
                    ? SingleChildScrollView(
                        child: AnimationLimiter(
                          child: Column(
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  vertical: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 20,
                                    tablet: 40,
                                  ),
                                  horizontal: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 30,
                                    tablet: 60,
                                  ),
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.mysection.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      horizontalOffset: 150.0,
                                      curve: Curves.easeInQuint,
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      child: FadeInAnimation(
                                        // كانت CustomCardMyCourses
                                        child: CustomListTileMyCourses(
                                          onTap: () {
                                            controller.navigateToSection(
                                              controller.mysection[index],
                                            );
                                          },
                                          section: controller
                                              .mysection[index]['name'],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(child: Text(" لا يوجد "))
              : Loading(),
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
            child: BasketWidget(heroTag: "five"),
          ),
        ),
      ),
    );
  }
}
