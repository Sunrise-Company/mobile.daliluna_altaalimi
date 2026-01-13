import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/exam/startExamController.dart';
import '../../../core/constant/color.dart';
import '../../widget/GetValueForScreen.dart';

class testPage extends GetView<StartExamControllerss> {
  @override
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
                "أسئلة الامتحان",
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
        body: Obx(
          () => controller.isloded.value
              ? Directionality(
                  textDirection: TextDirection.rtl,
                  child: Stack(
                    children: [
                      // the page view
                      PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: (int page) {
                          controller.isplaying[page](false);
                          controller.player.stop();
                          controller.positions.refresh();
                          controller.positions[page] = 0;
                          controller.activePage(page);
                        },
                        itemCount: controller.pages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return controller.pages[index %
                              controller.pages.length];
                        },
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
