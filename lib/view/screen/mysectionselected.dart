import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/sectionselected_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcard.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';

class MySectionSelected extends GetView<SectionSelectedController> {
  MySectionSelected({super.key});

  @override
  Widget build(BuildContext context) {
    BasketController baskerc = Get.put(BasketController());
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
            elevation: 0,
            backgroundColor: AppColor.PrimaryColor,
            title: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: AppColor.SecondryColor,
              child: Text(
                "الدورات",
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
        //     actions: [
        //       Obx(
        //         () => CustomIconBasket(
        //             text: baskerc.mycart.length != 0
        //                 ? baskerc.mycart.length.toString()
        //                 : "0"),
        //       ),
        //     ],
        //     elevation: 0,
        //     flexibleSpace: Container(
        //       decoration: BoxDecoration(
        //         gradient: LinearGradientPainter(
        //           begin: Alignment.topRight,
        //           end: Alignment.topCenter,
        //           colors: <Color>[AppColor.DeepPurple, AppColor.DeepPurple],
        //         ),
        //       ),
        //     ),
        //     title: Text(
        //       "الدورات",
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
        backgroundColor: Colors.white,
        body: GetBuilder<SectionSelectedController>(
          builder: (controller) => controller.isLoading
              ? controller.mysection.isNotEmpty
                    ? AnimationLimiter(
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: AppColor.SecondryColor,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            itemCount: controller.mysection.length,
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
                                        controller.goToMySections(
                                          controller.mysection[index]['id'],
                                          int.parse(
                                            Get.arguments['subjetcsid'],
                                          ),
                                          int.parse(
                                            Get.arguments['teacher_id'],
                                          ),
                                          int.parse(Get.arguments['classid']),
                                          controller.mysection[index]['type']
                                              .toString(),
                                        );
                                      },
                                      nameImage:
                                          controller
                                                  .mysection[index]['image'] !=
                                              null
                                          ? controller.mysection[index]['image']
                                          : "-",
                                      text: controller.mysection[index]['name'],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Center(child: Text("لا يوجد"))
              : Loading(),
        ),
        floatingActionButton: SizedBox(
          width: getValueForScreenType<double>(
            context: context,
            mobile: 56,
            tablet: 80,
          ),
          height: getValueForScreenType<double>(
            context: context,
            mobile: 56,
            tablet: 80,
          ),
          child: BasketWidget(heroTag: "four"),
        ),
      ),
    );
  }
}
