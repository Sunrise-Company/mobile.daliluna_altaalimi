import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/notifications_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcontainernotification.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/GetValueForScreen.dart';

// ignore: must_be_immutable
class Notifications extends GetView<NotificationsController> {
  late NotificationsController controller = Get.put(NotificationsController());
  Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    controller = Get.put(NotificationsController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
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
        //     title: Text(
        //       "الإشعارات",
        //       style: TextStyle(
        //         color: AppColor.White,
        //         fontSize: getValueForScreenType<double>(
        //           context: context,
        //           mobile: 20,
        //           tablet: 30,
        //         ),
        //       ),
        //     ),
        //     backgroundColor: AppColor.DeepPurple,
        //     elevation: 0.0,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.vertical(
        //         bottom: Radius.circular(
        //           getValueForScreenType<double>(
        //             context: context,
        //             mobile: 30,
        //             tablet: 60,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
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
                "الاشعارات",
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
        body: GetX<NotificationsController>(
          builder: (NotificationsController) => Container(
            padding: EdgeInsets.all(
              getValueForScreenType<double>(
                context: context,
                mobile: 20,
                tablet: 40,
              ),
            ),
            child: Center(
              child: controller.isLoading.value
                  ? controller.notfs.length != 0
                        ? ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: getValueForScreenType<double>(
                                context: context,
                                mobile: 20,
                                tablet: 40,
                              ),
                            ),
                            itemCount: controller.notfs.length,
                            itemBuilder: (BuildContext context, index) {
                              return controller.notfs[index]['link'] != null
                                  ? InkWell(
                                      child: CustomContainerNotification(
                                        text:
                                            controller.notfs[index]['message'],
                                        // color: AppColor.SecondryColor2
                                        //     .withOpacity(0.3),
                                      ),
                                      onTap: () {
                                        launchUrl(
                                          Uri.parse(
                                            controller.notfs[index]['link'],
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      child: CustomContainerNotification(
                                        text: controller.notfs[index],
                                        //     ['message'],
                                        // color: AppColor.BackGround,
                                      ),
                                    );
                            },
                          )
                        : Center(child: Text("لا يوجد إشعارات"))
                  : Loading(),
            ),
          ),
        ),
      ),
    );
  }
}
