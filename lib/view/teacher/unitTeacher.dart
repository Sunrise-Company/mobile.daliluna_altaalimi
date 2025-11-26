// ignore_for_file: must_be_immutable

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

import '../../controller/teacherController/lessonUnitTeacherController.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/customCardTeacher.dart';

class UnitTeacher extends GetView<TeacherLessonDepsUnitContrlloer> {
  UnitTeacher({super.key});
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
                "الوحدات",
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
        //       "الوحدات",
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
        body: Obx(
          () => controller.isloded.value
              ? controller.dataList.isNotEmpty
                    ? AnimationLimiter(
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: AppColor.SecondryColor,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: getValueForScreenType<double>(
                                context: context,
                                mobile: 10,
                                tablet: 30,
                              ),
                              vertical: getValueForScreenType<double>(
                                context: context,
                                mobile: 15,
                                tablet: 30,
                              ),
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: getValueForScreenType<double>(
                                context: context,
                                mobile: 10,
                                tablet: 20,
                              ),
                            ),
                            itemCount: controller.dataList.length,
                            itemBuilder: (context, index) {
                              final item = controller.dataList[index];
                              final sectionName = item['name'] ?? '';

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  horizontalOffset: 200.0,
                                  curve: Curves.easeInOutBack,
                                  duration: const Duration(milliseconds: 600),
                                  child: FadeInAnimation(
                                    child: Card(
                                      elevation: 6,
                                      shadowColor: AppColor.PrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      color: Colors.white,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              getValueForScreenType<double>(
                                                context: context,
                                                mobile: 12,
                                                tablet: 25,
                                              ),
                                          vertical:
                                              getValueForScreenType<double>(
                                                context: context,
                                                mobile: 8,
                                                tablet: 15,
                                              ),
                                        ),
                                        onTap: () {
                                          Get.toNamed(
                                            '/lectureTeacher',
                                            arguments: {
                                              'id': item['id'].toString(),
                                            },
                                          );
                                        },
                                        leading: CircleAvatar(
                                          radius: getValueForScreenType<double>(
                                            context: context,
                                            mobile: 25,
                                            tablet: 40,
                                          ),
                                          backgroundColor: AppColor
                                              .SecondryColor.withOpacity(0.5),
                                          child: Icon(
                                            Icons.menu_book_rounded,
                                            color: AppColor.PrimaryColor,
                                            size: getValueForScreenType<double>(
                                              context: context,
                                              mobile: 22,
                                              tablet: 35,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          sectionName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getValueForScreenType<double>(
                                                  context: context,
                                                  mobile: 15,
                                                  tablet: 22,
                                                ),
                                            color: AppColor.PrimaryColor,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5.0,
                                          ),
                                          child: Text(
                                            "اضغط لعرض الدروس",
                                            style: TextStyle(
                                              color: AppColor.grey,
                                              fontSize:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 13,
                                                    tablet: 18,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppColor.SecondryColor,
                                          size: getValueForScreenType<double>(
                                            context: context,
                                            mobile: 18,
                                            tablet: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : const Center(child: Text("لا يوجد"))
              : const Loading(),
        ),

        // body: Obx(() => controller.isloded.value
        //     ? controller.dataList.isNotEmpty
        //         ? SingleChildScrollView(
        //             child: AnimationLimiter(
        //               child: Column(
        //                 children: [
        //                   ListView.builder(
        //                     padding: EdgeInsets.symmetric(
        //                       vertical: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 20,
        //                         tablet: 40,
        //                       ),
        //                       horizontal: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 40,
        //                         tablet: 60,
        //                       ),
        //                     ),
        //                     physics: NeverScrollableScrollPhysics(),
        //                     shrinkWrap: true,
        //                     itemCount: controller.dataList.length,
        //                     itemBuilder: (context, index) {
        //                       return AnimationConfiguration.staggeredList(
        //                         position: index,
        //                         duration: const Duration(milliseconds: 500),
        //                         child: SlideAnimation(
        //                           horizontalOffset: 150.0,
        //                           curve: Curves.easeInQuint,
        //                           duration: const Duration(milliseconds: 700),
        //                           child: FadeInAnimation(
        //                             child: CustomCardTeacherSections(
        //                               onTapShop: () {
        //                                 Get.toNamed('/lectureTeacher',
        //                                     arguments: {
        //                                       'id': controller.dataList[index]
        //                                               ['id']
        //                                           .toString()
        //                                     });
        //                               },
        //                               section: controller.dataList[index]
        //                                   ['name'],
        //                             ),
        //                           ),
        //                         ),
        //                       );
        //                     },
        //                   )
        //                 ],
        //               ),
        //             ),
        //           )
        //         : Center(child: Text("لا يوجد "))
        //     : Loading()),
      ),
    );
  }
}
