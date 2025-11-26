// ignore_for_file: must_be_iacademyv3utable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/ourcoursesselected_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/view/screen/ourcourseexams.dart';
import 'package:daliluna_altaalimi/view/screen/teacher.dart';

class OueCoursesSelected extends GetView<OurCoursesSelectedController> {
  OueCoursesSelected({super.key});
  late BasketController baskerc;

  @override
  Widget build(BuildContext context) {
    baskerc = Get.put(BasketController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.BackGround2,
        appBar: AppBar(
          actions: [
            Stack(
              children: [
                IconButton(
                  padding: EdgeInsets.only(left: 20),
                  onPressed: () {
                    Get.toNamed(AppRoute.basket);
                  },
                  icon: Icon(
                    Icons.shopping_cart_rounded,
                    color: AppColor.PrimaryColor,
                    size: 30,
                  ),
                ),
                Obx(() {
                  return baskerc.mycart.length != 0
                      ? Text(baskerc.mycart.length.toString())
                      : Text('');
                }),
              ],
            ),
          ],
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topCenter,
                colors: <Color>[AppColor.SecondryColor2, AppColor.DeepPurple],
              ),
            ),
          ),
          title: const Text("دوراتنا"),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                padding: const EdgeInsets.all(10),
                indicatorColor: AppColor.DeepPurple,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "الأساتذة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.PrimaryColor,
                            fontSize: 17,
                          ),
                        ),
                        Icon(
                          Icons.diversity_1_sharp,
                          color: AppColor.SecondryColor,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "المذاكرات",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.PrimaryColor,
                            fontSize: 17,
                          ),
                        ),
                        Icon(
                          Icons.assessment,
                          color: AppColor.SecondryColor,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ],
                onTap: (index) {
                  controller.changeTabIndex(index);
                },
              ),
              Expanded(
                child: GetBuilder<OurCoursesSelectedController>(
                  builder: (controller) {
                    return TabBarView(
                      children: [Teacher(), OurCourseExams()],
                      // controller: .of(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
