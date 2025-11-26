import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/data/datasource/static/static.dart';
import 'package:daliluna_altaalimi/view/widget/customcardlesson.dart';

class Foundation extends StatelessWidget {
  const Foundation({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.BackGround2,
        appBar: AppBar(
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.centerLeft,
                colors: <Color>[AppColor.PrimaryColor, AppColor.DeepPurple],
              ),
            ),
          ),
          title: Text("التأسيس"),
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
                          child: CustomCardLesson(
                            item: LessonList[index],
                            onTap: () {
                              Get.toNamed(AppRoute.viewLessons);
                            },
                            lesson: LessonList[index].lesson!,
                            // detailsLesson: LessonList[index].detailsLesson!,
                            price: LessonList[index].price!,
                            onTapShop: () {
                              Get.toNamed(AppRoute.login);
                            },
                            count: '',
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
