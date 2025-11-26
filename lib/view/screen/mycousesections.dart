import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/data/datasource/static/static.dart';
import 'package:daliluna_altaalimi/view/widget/customcard.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';

class MyCourseSections extends StatelessWidget {
  const MyCourseSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topCenter,
                  colors: <Color>[AppColor.DeepPurple, AppColor.PrimaryColor],
                ),
              ),
            ),
            title: Text(
              "الأقسام",
              style: TextStyle(
                color: AppColor.White,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 20,
                  tablet: 30,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: AppColor.BackGround2,
        body: AnimationLimiter(
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: AppColor.SecondryColor,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 8 / 9,
                crossAxisSpacing: 7,
                mainAxisSpacing: 10,
              ),
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemCount: MyCourseSectionList.length,
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
                          index == 2
                              ? Get.toNamed(AppRoute.mycourseUnitsSubject)
                              : index == 4
                              ? Get.toNamed(AppRoute.mycourseLessons)
                              : index == 3
                              ? Get.toNamed(AppRoute.mycourseLessons)
                              : index == 0
                              ? Get.toNamed(AppRoute.mycourseLessons)
                              : index == 1
                              ? Get.toNamed(AppRoute.mycourseLessons)
                              : Get.toNamed(AppRoute.login);
                        },
                        nameImage: MyCourseSectionList[index].image!,
                        text: MyCourseSectionList[index].textIcon!,
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
