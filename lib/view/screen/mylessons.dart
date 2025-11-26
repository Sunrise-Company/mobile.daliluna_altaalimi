// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/lesson_controller.dart';
import 'package:daliluna_altaalimi/controller/lessonvedio_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcardsectionmycourses.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';
import 'package:daliluna_altaalimi/view/widget/customiconbasket.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';

class MyLessons extends GetView<LessonsController> {
  MyLessons({super.key});
  late LessonVediosController lessonvideoscontroller;

  @override
  Widget build(BuildContext context) {
    lessonvideoscontroller = Get.put(LessonVediosController());
    BasketController baskerc = Get.put(BasketController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.BackGround2,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            getValueForScreenType<double>(
              context: context,
              mobile: 55,
              tablet: 100,
            ),
          ),
          child: AppBar(
            leading: CustomIconAppBar(),
            actions: [
              Stack(
                children: [
                  Obx(
                    () => CustomIconBasket(
                      text: baskerc.mycart.length != 0
                          ? baskerc.mycart.length.toString()
                          : "0",
                    ),
                  ),
                ],
              ),
            ],
            title: Text(
              "الدروس",
              style: TextStyle(
                color: AppColor.White,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 20,
                  tablet: 30,
                ),
              ),
            ),
            backgroundColor: AppColor.DeepPurple,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(
                  getValueForScreenType<double>(
                    context: context,
                    mobile: 30,
                    tablet: 60,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: GetBuilder<LessonsController>(
          builder: (controller) => controller.isloaded
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
                                    tablet: 30,
                                  ),
                                  horizontal: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 30,
                                    tablet: 40,
                                  ),
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.mylectures.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      horizontalOffset: 150.0,
                                      curve: Curves.easeOutBack,
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      child: FadeInAnimation(
                                        child: CustomCardSectionsMyCourses(
                                          onTap: () {
                                            // controller.goToVedios(controller
                                            //     .mylectures[index]['id']);
                                            controller.navigateToSection(
                                              controller.mylectures[index],
                                            );
                                          },
                                          section:
                                              controller
                                                      .mylectures[index]['name'] ==
                                                  null
                                              ? "-"
                                              : controller
                                                    .mylectures[index]['name'],
                                          // lesson: controller.mylectures[index]
                                          //             ['name'] !=
                                          //         null
                                          //     ? controller.mylectures[index]['name']
                                          //     : "-",
                                          // price: controller.mylectures[index]
                                          //             ['price'] !=
                                          //         null
                                          //     ? controller.mylectures[index]['price']
                                          //         .toString()
                                          //     : "-",
                                          // onTapShop: () {
                                          //   // Get.toNamed(AppRoute.login);
                                          //   print('33333');
                                          // },
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
                    : Center(child: Text('لا يوجد'))
              : Loading(),
        ),
      ),
    );
  }
}
