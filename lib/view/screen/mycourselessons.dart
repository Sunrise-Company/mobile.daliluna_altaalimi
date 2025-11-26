import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/data/datasource/static/static.dart';
import 'package:daliluna_altaalimi/view/widget/customcardmycouselesson.dart';

class MyCourseLessons extends StatelessWidget {
  const MyCourseLessons({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.BackGround2,
        appBar: AppBar(
          title: Text(" الدروس"),
          backgroundColor: AppColor.DeepPurple,
          elevation: 0.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        body: SingleChildScrollView(
          child: AnimationLimiter(
            child: Column(
              children: [
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: LessonList.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        horizontalOffset: 150.0,
                        curve: Curves.easeOutBack,
                        duration: const Duration(milliseconds: 700),
                        child: FadeInAnimation(
                          child: CustomCardMyCourseLesson(
                            onTap: () {
                              Get.toNamed(AppRoute.vedios);
                            },
                            lesson: LessonList[index].lesson!,
                            detailsLesson: LessonList[index].detailsLesson!,
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
    );
  }
}
