import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/exam/startExamController.dart';
import '../../../core/constant/color.dart';
import '../../widget/GetValueForScreen.dart';

class testPage extends StatelessWidget {
  testPage({Key? key}) : super(key: key);

  StartExamControllerss get controller => Get.find<StartExamControllerss>();

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
                  child: Column(
                    children: [
                      // Progress Bar
                      Obx(() => LinearProgressIndicator(
                            value: controller.questionlist.isEmpty 
                                ? 0 
                                : (controller.activePage.value + 1) / controller.questionlist.length,
                            backgroundColor: Colors.grey[100],
                            minHeight: 6,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColor.SecondryColor),
                          )),
                      
                      // the page view
                      Expanded(
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(), // Prevent swiping if we want to enforce button navigation
                          controller: controller.pageController,
                          onPageChanged: (int page) {
                            controller.isplaying[page](false);
                            controller.player.stop();
                            controller.positions.refresh();
                            controller.positions[page] = 0;
                            // Update activePage when page changes
                            controller.activePage(page);
                          },
                          itemCount: controller.pages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return controller.pages[index % controller.pages.length];
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: Loading()),
        ),
      ),
    );
  }
}
