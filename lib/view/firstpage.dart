// import 'package:flutter/material.dart';
// import '../controller/inialController.dart';
// import '../core/constant/color.dart';
// import 'package:get/get.dart';
//
// import '../core/constant/imageasset.dart';
//
// class FirstPageTeacher extends GetView<InialController> {
//   // OurCoursesController ourcontroller = OurCoursesController();
//
//   @override
//   Widget build(BuildContext context) {
//     // ourcontroller = Get.put(OurCoursesController());
//     return Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//             backgroundColor: AppColor.BackGround2,
//             body: Obx(() => controller.isLoading.value
//                 ? Center(
//                     child:Container(
//                       color: AppColor.BackGround2,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ClipOval(
//                             child: Image.asset(
//                               AppImageAsset.newLogo,
//                               width: 200,
//                               height: 200,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           const SizedBox(height: 10), // مسافة بين الصورة والنص
//                           const Text(
//                             "منصة الأكاديمية\nالعربية الذكية",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: AppColor.PrimaryColor,
//                               height: 1.4,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//
// // Show loading spinner
//                   )
//                 : Center(
//               child:   Container(
//                   color: AppColor.BackGround2,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ClipOval(
//                         child: Image.asset(
//                           AppImageAsset.newLogo,
//                           width: 200,
//                           height: 200,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(height: 10), // مسافة بين الصورة والنص
//                       const Text(
//                         "منصة الأكاديمية\nالعربية الذكية",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: AppColor.PrimaryColor,
//                           height: 1.4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ) // Show loading spinner
//                   ))));
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/SplashController.dart';
import '../controller/inialController.dart';
import '../core/constant/color.dart';
import '../core/constant/imageasset.dart';

class FirstPageTeacher extends GetView<InialController> {
  const FirstPageTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    final splashController = Get.put(SplashController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.PrimaryColor,
                AppColor.DeepPurple,
                AppColor.DeepPurple2,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Center(
            child: Obx(
              () => controller.isLoading.value
                  ? _buildAnimatedContent(splashController)
                  : _buildAnimatedContent(splashController),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContent(SplashController splashController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: splashController.scaleAnimation,
          child: FadeTransition(
            opacity: splashController.fadeAnimation,
            child: ClipOval(
              child: Image.asset(
                AppImageAsset.newLogo,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: splashController.fadeAnimation,
          child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: AppColor.SecondryColor,
            child: Text(
              "دليلنا التعليمي",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,

                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
