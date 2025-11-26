import 'dart:developer';

import 'package:daliluna_altaalimi/controller/chatStudnet/chat.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/teacherController/chat/chatTeacherController.dart';
import '../../../core/constant/color.dart';
import '../../widget/GetValueForScreen.dart';
import '../../widget/customDrawerTeacher.dart';
import 'chatTeacher.dart';

class StudentListPage extends StatelessWidget {
  final ListStudentChatController controller = Get.put(
    ListStudentChatController(),
  );

  @override
  Widget build(BuildContext context) {
    controller.cancelAllNotifications();
    return Scaffold(
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
      //       "المحادثات",
      //       style: TextStyle(color: AppColor.White),
      //     ),
      //   ),
      // ),
      drawer: customDrawerTeacher(context),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          getValueForScreenType<double>(
            context: context,
            mobile: 55,
            tablet: 100,
          ),
        ),
        child: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                size: getValueForScreenType<double>(
                  context: context,
                  mobile: 25,
                  tablet: 40,
                ),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          elevation: 0,
          backgroundColor: AppColor.PrimaryColor,
          title: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: AppColor.SecondryColor,
            child: Text(
              "المحادثات",
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
      body: GetBuilder<ListStudentChatController>(
        builder: (controller) {
          if (controller.dataList.isEmpty) {
            return const Center(child: Text("لا يوجد"));
          }

          return AnimationLimiter(
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: AppColor.SecondryColor,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: getValueForScreenType<double>(
                    context: context,
                    mobile: 10,
                    tablet: 15,
                  ),
                ),
                itemCount: controller.dataList.length,
                itemBuilder: (context, index) {
                  final student = controller.dataList[index];
                  final unreadCount = student['unread_messages_count'] ?? 0;

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
                            Get.to(() {
                              final chatController = Get.put(
                                ChatTeacherController(),
                              );
                              chatController.receiverId.value = student['id']
                                  .toString();
                              chatController.name.value =
                                  student['arabic_name'];
                              chatController.markChatAsRead(
                                student['id'].toString(),
                              );
                              return ChatPage();
                            });
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
                                        backgroundColor: AppColor.DeepPurple2,
                                        backgroundImage:
                                            student['image'] != null
                                            ? NetworkImage(
                                                '${AppLink.image}/${student['image']}',
                                              )
                                            : null,
                                        child: student['image'] == null
                                            ? Text(
                                                student['arabic_name'][0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.DeepPurple,
                                                ),
                                              )
                                            : null,
                                        radius: responsiveValue(
                                          context: context,
                                          mobile: 30,
                                          tablet: 50,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student['arabic_name'],
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
                                            student['last_message'] != null
                                                ? student['last_message']['msg'] !=
                                                          null
                                                      ? '${student['last_message']['msg']}'
                                                      : "مرفق "
                                                : "",
                                            style: TextStyle(
                                              fontSize: responsiveValue(
                                                context: context,
                                                mobile: 12,
                                                tablet: 20,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            student['last_message'] != null &&
                                                    student['last_message']['created_at'] !=
                                                        null
                                                ? '${(DateTime.parse(student['last_message']['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(student['last_message']['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(student['last_message']['created_at']).hour >= 12 ? 'م' : 'ص'}'
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
                                        ),
                                        if (unreadCount > 0)
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: AppColor.SecondryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              unreadCount.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: responsiveValue(
                                                  context: context,
                                                  mobile: 12,
                                                  tablet: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 5,
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
          );
        },
      ),

      ////////هون عدلتي ميارح تأكدي انو الشغل ما انتزع فكي تعليقي
      // body: GetBuilder<ListStudentChatController>(
      //   builder: (controller) {
      //     if (controller.dataList.isEmpty) {
      //       return Center(child: Text("لا يوجد"));
      //     }
      //     return AnimationLimiter(
      //       child: GlowingOverscrollIndicator(
      //         axisDirection: AxisDirection.down,
      //         color: AppColor.SecondryColor,
      //         child: ListView.separated(
      //           separatorBuilder: (context, index) => SizedBox(
      //             height: getValueForScreenType<double>(
      //               context: context,
      //               mobile: 15,
      //               tablet: 40,
      //             ),
      //           ),
      //           itemCount: controller.dataList.length,
      //           itemBuilder: (context, index) {
      //             final student = controller.dataList[index];
      //             final unreadCount = student['unread_messages_count'] ?? 0;
      //
      //             return AnimationConfiguration.staggeredList(
      //               position: index,
      //               duration: const Duration(milliseconds: 500),
      //               child: SlideAnimation(
      //                 horizontalOffset: 150.0,
      //                 curve: Curves.decelerate,
      //                 duration: const Duration(milliseconds: 700),
      //                 child: FadeInAnimation(
      //                   child: GestureDetector(
      //                     onTap: () {
      //                       Get.to(() {
      //                         final chatController =
      //                             Get.put(ChatTeacherController());
      //                         chatController.receiverId.value =
      //                             student['id'].toString();
      //                         chatController.name.value =
      //                             student['arabic_name'];
      //                         chatController
      //                             .markChatAsRead(student['id'].toString());
      //                         return ChatPage();
      //                       });
      //                     },
      //                     child: Column(
      //                       children: [
      //                         Container(
      //                           decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(5),
      //                           ),
      //                           child: Row(
      //                             children: [
      //                               Padding(
      //                                 padding: const EdgeInsets.all(8.0),
      //                                 child: CircleAvatar(
      //                                   backgroundColor: AppColor.DeepPurple2,
      //                                   child: Text(
      //                                     student['arabic_name'][0]
      //                                         .toUpperCase(),
      //                                     style: TextStyle(
      //                                         fontWeight: FontWeight.bold,
      //                                         color: AppColor.DeepPurple),
      //                                   ),
      //                                   radius: 35,
      //                                 ),
      //                               ),
      //                               SizedBox(width: 16.0),
      //                               Expanded(
      //                                 child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.start,
      //                                   children: [
      //                                     Text(
      //                                       student['arabic_name'],
      //                                       style: TextStyle(
      //                                         fontSize: 15.0,
      //                                         fontWeight: FontWeight.bold,
      //                                       ),
      //                                     ),
      //                                     Text(
      //                                       student['last_message'] != null
      //                                           ? student['last_message']
      //                                                   ['msg'] ??
      //                                               "مرفق "
      //                                           : "",
      //                                       style: TextStyle(
      //                                         fontSize: 12.0,
      //                                         overflow: TextOverflow.ellipsis,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                               Column(
      //                                 children: [
      //                                   Padding(
      //                                     padding: const EdgeInsets.all(5.0),
      //                                     child: Text(
      //                                       student['last_message'] != null &&
      //                                               student['last_message']
      //                                                       ['created_at'] !=
      //                                                   null
      //                                           ? '${(DateTime.parse(student['last_message']['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(student['last_message']['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(student['last_message']['created_at']).hour >= 12 ? 'م' : 'ص'}'
      //                                           : '',
      //                                       style: const TextStyle(
      //                                           fontSize: 13,
      //                                           color: Colors.black54),
      //                                     ),
      //                                   ),
      //                                   if (unreadCount > 0)
      //                                     Container(
      //                                       padding: EdgeInsets.all(6),
      //                                       decoration: BoxDecoration(
      //                                         color: AppColor.PrimaryColor,
      //                                         borderRadius:
      //                                             BorderRadius.circular(12),
      //                                       ),
      //                                       child: Text(
      //                                         unreadCount.toString(),
      //                                         style: TextStyle(
      //                                           color: Colors.white,
      //                                           fontWeight: FontWeight.bold,
      //                                         ),
      //                                       ),
      //                                     ),
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                         Divider(
      //                           height: 10,
      //                           thickness: 1.5,
      //                           color: AppColor.SecondaryColor,
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
