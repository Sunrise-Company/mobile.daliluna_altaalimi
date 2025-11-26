import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/viewlesson_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/screen/pdfs.dart';
import 'package:daliluna_altaalimi/view/screen/vedioswithoutappbar.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/GetValueForScreen.dart';

class ViewLesson extends StatelessWidget {
  const ViewLesson({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewLessonController controller = Get.put(ViewLessonController());

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
                "تجريب",
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
        //     elevation: 0.0,
        //     flexibleSpace: Container(
        //       decoration: BoxDecoration(
        //         gradient: LinearGradientPainter(
        //           begin: Alignment.topRight,
        //           end: Alignment.centerLeft,
        //           colors: <Color>[AppColor.PrimaryColor, AppColor.DeepPurple],
        //         ),
        //       ),
        //     ),
        //     title: Text(
        //       controller.lessonsectionsName.toString(),
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
        body: GetBuilder<ViewLessonController>(
          builder: (controller) {
            if (controller.isLoadingvideo) {
              return Loading();
            }

            if (controller.isFreePreviewMode) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.PrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.PrimaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "✨ معاينة الفيديوهات المجانية",
                            style: TextStyle(
                              color: AppColor.PrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "للوصول إلى جميع فيديوهات وملفات هذا القسم، قم بالاشتراك.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.PrimaryColor.withOpacity(0.9),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: VediosWithoutAppBar(
                      controller.dataVideos,
                      controller.isLoadingvideo,
                      isFreePreview: controller.isFreePreviewMode,
                      isPurchased: controller.isSectionPurchased,
                    ),
                  ),
                ],
              );
            } else {
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getValueForScreenType<double>(
                          context: context,
                          mobile: 8,
                          tablet: 16,
                        ),
                        horizontal: getValueForScreenType<double>(
                          context: context,
                          mobile: 10,
                          tablet: 20,
                        ),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: AppColor.SecondryColor2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColor.PrimaryColor,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getValueForScreenType<double>(
                            context: context,
                            mobile: 13,
                            tablet: 17,
                          ),
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.video_collection_rounded,
                                  color: AppColor.PrimaryColor,
                                  size: 24,
                                ),
                                SizedBox(width: 6),
                                Text("الفيديوهات"),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.picture_as_pdf_rounded,
                                  color: AppColor.PrimaryColor,
                                  size: 24,
                                ),
                                SizedBox(width: 6),
                                Text("الملفات"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          VediosWithoutAppBar(
                            controller.dataVideos,
                            controller.isLoadingvideo,
                            isFreePreview: controller.isFreePreviewMode,
                            isPurchased: controller.isSectionPurchased,
                          ),
                          Pdfs(controller.dataFiles, controller.isLoadingfile),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // else {
            //   return DefaultTabController(
            //     length: 2,
            //     child: Column(
            //       children: [
            //         TabBar(
            //           padding: EdgeInsets.all(
            //             getValueForScreenType<double>(
            //               context: context,
            //               mobile: 10,
            //               tablet: 20,
            //             ),
            //           ),
            //           indicatorColor: AppColor.DeepPurple,
            //           tabs: [
            //             Tab(
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Text(
            //                     "الفيديوهات",
            //                     style: TextStyle(
            //                       color: AppColor.PrimaryColor,
            //                       fontSize: getValueForScreenType<double>(
            //                         context: context,
            //                         mobile: 13,
            //                         tablet: 17,
            //                       ),
            //                     ),
            //                   ),
            //                   SizedBox(width: 8),
            //                   Icon(Icons.video_collection_rounded,
            //                       color: AppColor.SecondryColor, size: 25)
            //                 ],
            //               ),
            //             ),
            //             Tab(
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Text(
            //                     "الملفات",
            //                     style: TextStyle(
            //                       color: AppColor.PrimaryColor,
            //                       fontSize: getValueForScreenType<double>(
            //                         context: context,
            //                         mobile: 13,
            //                         tablet: 17,
            //                       ),
            //                     ),
            //                   ),
            //                   SizedBox(width: 8),
            //                   Icon(Icons.picture_as_pdf_rounded,
            //                       color: AppColor.SecondryColor, size: 25)
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //         Expanded(
            //           child: TabBarView(
            //             children: [
            //               VediosWithoutAppBar(
            //                 controller.dataVideos,
            //                 controller.isLoadingvideo,
            //                 isFreePreview: controller.isFreePreviewMode,
            //                 isPurchased: controller.isSectionPurchased,
            //               ),
            //               Pdfs(controller.dataFiles, controller.isLoadingfile)
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   );
            // }
          },
        ),
      ),
    );
  }
}
