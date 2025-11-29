import 'package:daliluna_altaalimi/controller/unitssubject_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:daliluna_altaalimi/view/widget/breadcrumb_widget.dart';
import '../widget/GetValueForScreen.dart';

class MyUnitsSubject extends GetView<UnitsSubjectController> {
  MyUnitsSubject({super.key});

  Widget build(BuildContext context) {
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
                "وحدات المادة",
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
              child: GetBuilder<UnitsSubjectController>(
                builder: (controller) => controller.isLoadingtow
                    ? controller.myunits.isNotEmpty
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
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: getValueForScreenType<double>(
                                          context: context,
                                          mobile: 10,
                                          tablet: 20,
                                        ),
                                      ),
                                  itemCount: controller.myunits.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.myunits[index];
                                    final name = item['name'] ?? '';
                                    final price = item['price'].toString();

                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      child: SlideAnimation(
                                        horizontalOffset: 200.0,
                                        curve: Curves.easeInOutBack,
                                        duration: const Duration(
                                          milliseconds: 600,
                                        ),
                                        child: FadeInAnimation(
                                          child: Card(
                                            elevation: 6,
                                            shadowColor: AppColor.PrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            color: Colors.white,
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal:
                                                        getValueForScreenType<
                                                          double
                                                        >(
                                                          context: context,
                                                          mobile: 12,
                                                          tablet: 25,
                                                        ),
                                                    vertical:
                                                        getValueForScreenType<
                                                          double
                                                        >(
                                                          context: context,
                                                          mobile: 8,
                                                          tablet: 15,
                                                        ),
                                                  ),
                                              onTap: () {
                                                controller.goToMyLesson(
                                                  item['id'],
                                                  item['app_lesson_id'],
                                                );
                                              },
                                              leading: CircleAvatar(
                                                radius:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 25,
                                                      tablet: 40,
                                                    ),
                                                backgroundColor:
                                                    AppColor
                                                        .SecondryColor.withOpacity(
                                                      0.5,
                                                    ),
                                                child: Icon(
                                                  Icons.menu_book_rounded,
                                                  color: AppColor.PrimaryColor,
                                                  size:
                                                      getValueForScreenType<
                                                        double
                                                      >(
                                                        context: context,
                                                        mobile: 22,
                                                        tablet: 35,
                                                      ),
                                                ),
                                              ),
                                              title: Text(
                                                name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      getValueForScreenType<
                                                        double
                                                      >(
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
                                                  "السعر: $price ",
                                                  style: TextStyle(
                                                    color: AppColor.grey,
                                                    fontSize:
                                                        getValueForScreenType<
                                                          double
                                                        >(
                                                          context: context,
                                                          mobile: 13,
                                                          tablet: 18,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              trailing: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColor.SecondryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Center(child: Text("لا يوجد وحدات"))
                    : Loading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
