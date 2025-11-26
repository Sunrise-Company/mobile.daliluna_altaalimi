import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/data/datasource/static/static.dart';
import 'package:daliluna_altaalimi/view/widget/customwidgetviewteacher.dart';

class MyCourseTeachers extends StatelessWidget {
  const MyCourseTeachers({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.BackGround2,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.DeepPurple,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          title: Text("الأساتذة"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: AnimationLimiter(
              child: Column(
                children: [
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 30),
                    shrinkWrap: true,
                    itemCount: TeacherList.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 150.0,
                          curve: Curves.decelerate,
                          duration: const Duration(milliseconds: 700),
                          child: FadeInAnimation(
                            child: CustomWidgetViewTeacher(
                              onTap: () {
                                Get.toNamed(AppRoute.myCourseSections);
                              },
                              name: TeacherList[index].textIcon!,
                              assetName: TeacherList[index].image!,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
