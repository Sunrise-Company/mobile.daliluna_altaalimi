// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/lesson_controller.dart';
import 'package:daliluna_altaalimi/controller/lessonvedio_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:daliluna_altaalimi/view/widget/breadcrumb_widget.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';

class MyLessons extends GetView<LessonsController> {
  MyLessons({super.key});
  late LessonVediosController lessonvideoscontroller;

  @override
  Widget build(BuildContext context) {
    lessonvideoscontroller = Get.put(LessonVediosController());
    Get.put(BasketController());

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
        body: Column(
          children: [
            const BreadcrumbWidget(),
            Expanded(
              child: GetBuilder<LessonsController>(
                builder: (controller) => controller.isloaded
                    ? controller.mylectures.isNotEmpty
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
                                    itemCount: controller.mylectures.length,
                                    itemBuilder: (context, index) {
                                      final item = controller.mylectures[index];
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
                                                    offset: const Offset(0, 3),
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
                                                  item['name'] ?? "-",
                                                  style: TextStyle(
                                                    fontSize:
                                                        getValueForScreenType<
                                                          double
                                                        >(
                                                          context: context,
                                                          mobile: 16,
                                                          tablet: 22,
                                                        ),
                                                    fontWeight: FontWeight.bold,
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
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "عدد الملفات: ${item['app_lesson_lecture_files_count'] ?? 0}",
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
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColor.SecondryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "عرض",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          getValueForScreenType<
                                                            double
                                                          >(
                                                            context: context,
                                                            mobile: 12,
                                                            tablet: 16,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  controller.navigateToSection(
                                                    item,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Center(child: Text('لا يوجد'))
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
