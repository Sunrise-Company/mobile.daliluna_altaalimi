import 'dart:developer';

import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/homepage_controller.dart';
import 'package:daliluna_altaalimi/view/screen/chatstudent/chatlist.dart';
import 'package:daliluna_altaalimi/view/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_builder/responsive_builder.dart';
// import 'package:gradients/gradients.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/color.dart';
import '../../widget/GetValueForScreen.dart';

class GroupChatListPageStudent extends StatelessWidget {
  ChatStudentListTeacherController chatController = Get.put(
    ChatStudentListTeacherController(),
  );

  @override
  Widget build(BuildContext context) {
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
        //     titleSpacing: getValueForScreenType<double>(
        //       context: context,
        //       mobile: 30,
        //       tablet: 50,
        //     ),
        //     elevation: 0,
        //     flexibleSpace: Container(
        //       decoration: BoxDecoration(
        //         gradient: LinearGradientPainter(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomRight,
        //           colors: <Color>[AppColor.DeepPurple, AppColor.PrimaryColor],
        //         ),
        //       ),
        //     ),
        //     title: const Text(
        //       "مجموعات الدردشة",
        //       style: TextStyle(color: AppColor.White),
        //     ),
        //     leading: IconButton(
        //         onPressed: () {
        //           Get.offNamed('/homepage');
        //         },
        //         icon: Icon(Icons.arrow_back)),
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
                "مجموعات الدردشة",
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
          () => chatController.roomlist.isNotEmpty
              ? AnimationLimiter(
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: AppColor.SecondryColor,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: getValueForScreenType<double>(
                          context: context,
                          mobile: 15,
                          tablet: 40,
                        ),
                      ),
                      itemCount: chatController.roomlist.length,
                      itemBuilder: (context, index) {
                        final group = chatController.roomlist[index];

                        final unreadCount = group['pivot']['count_view'] ?? 0;

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            horizontalOffset: 150.0,
                            curve: Curves.decelerate,
                            duration: const Duration(milliseconds: 700),
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    '/gorupchatStudent',
                                    arguments: {
                                      'idRoom': group['id'].toString(),
                                      'name': group['name'],
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              child: Text(
                                                group['name'][0].toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              radius: responsiveValue(
                                                context: context,
                                                mobile: 30,
                                                tablet: 50,
                                              ),
                                              backgroundColor:
                                                  AppColor.DeepPurple2,
                                            ),
                                          ),
                                          SizedBox(width: 16.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  group['name'],
                                                  style: TextStyle(
                                                    fontSize: responsiveValue(
                                                      context: context,
                                                      mobile: 15,
                                                      tablet: 20,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  group['last_message'] != null
                                                      ? group['last_message']['msg'] !=
                                                                null
                                                            ? '${group['last_message']['msg']}'
                                                            : "مرفق "
                                                      : " ",
                                                  style: TextStyle(
                                                    fontSize: responsiveValue(
                                                      context: context,
                                                      mobile: 12,
                                                      tablet: 20,
                                                    ),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  group['last_message'] != null
                                                      ? '${(DateTime.parse(group['last_message']['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(group['last_message']['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(group['last_message']['created_at']).hour >= 12 ? 'م' : 'ص'}'
                                                      : '',
                                                  style: TextStyle(
                                                    fontSize: responsiveValue(
                                                      context: context,
                                                      mobile: 13,
                                                      tablet: 20,
                                                    ),
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                if (unreadCount > 0)
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: AppColor
                                                          .SecondryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      unreadCount.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            responsiveValue(
                                                              context: context,
                                                              mobile: 12,
                                                              tablet: 20,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 10,
                                      thickness: 1.5,
                                      color: AppColor.SecondaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Center(child: Text("لا يوجد")),
        ),
      ),
    );
  }
}
