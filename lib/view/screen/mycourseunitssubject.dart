import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/data/datasource/static/static.dart';
import 'package:daliluna_altaalimi/view/widget/customcardunits.dart';

class MyCourseUnitsSubject extends StatelessWidget {
  const MyCourseUnitsSubject({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.BackGround,
        appBar: AppBar(
          backgroundColor: AppColor.PrimaryColor,
          elevation: 0.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          title: const Text("وحدات المادة"),
        ),
        body: AnimationLimiter(
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: AppColor.SecondryColor,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 8 / 9,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
              ),
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemCount: UnitsSUbjectList.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 200.0,
                    curve: Curves.easeInOutBack,
                    duration: const Duration(milliseconds: 600),
                    child: FadeInAnimation(
                      child: CustomCardUnits(
                        onTapShop: () {
                          Get.toNamed(AppRoute.login);
                        },
                        onTap: () {
                          Get.toNamed(AppRoute.mycourseLessons);
                        },
                        icon: UnitsSUbjectList[index].iconClip!,
                        textIcon: UnitsSUbjectList[index].textIcon!,
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
