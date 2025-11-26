import 'dart:developer';
import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:daliluna_altaalimi/view/widget/customDrawerTeacher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_builder/responsive_builder.dart';
// import 'package:gradients/gradients.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constant/color.dart';
import '../../../widget/GetValueForScreen.dart';
import 'groupChatTeacher.dart';

class GroupChatListPage extends StatelessWidget {
  final ListStudentChatController chatController = Get.put(
    ListStudentChatController(),
  );

  @override
  Widget build(BuildContext context) {
    chatController.cancelAllNotifications();
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
        // body: GetBuilder<ListStudentChatController>(
        //   builder: (controller) {
        //     // if (!controller.isloded.value) {
        //     //   return Center(child: CircularProgressIndicator());
        //     // }
        //     if (controller.roomlist.isEmpty) {
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
        //           itemCount: chatController.roomlist.length,
        //           itemBuilder: (context, index) {
        //             final group = chatController.roomlist[index];
        //
        //             final unreadCount = group['count_view'] ?? 0;
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
        //                       Get.toNamed('/groupChatTeacher', arguments: {
        //                         'name': group['name'],
        //                         'idRoom': group['id'].toString()
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
        //                                   child: Text(
        //                                     group['name'][0].toUpperCase(),
        //                                     style: TextStyle(
        //                                         fontSize: 18.0,
        //                                         fontWeight: FontWeight.bold,
        //                                         color: Colors.black),
        //                                   ),
        //                                   radius: 35,
        //                                   backgroundColor: AppColor.DeepPurple2,
        //                                 ),
        //                               ),
        //                               SizedBox(width: 16.0),
        //                               Expanded(
        //                                 child: Column(
        //                                   crossAxisAlignment:
        //                                       CrossAxisAlignment.start,
        //                                   children: [
        //                                     Text(
        //                                       group['name'],
        //                                       style: TextStyle(
        //                                         fontSize: 15.0,
        //                                         fontWeight: FontWeight.bold,
        //                                       ),
        //                                     ),
        //                                     Text(
        //                                       group['last_message'] != null
        //                                           ? group['last_message']
        //                                                       ['msg'] !=
        //                                                   null
        //                                               ? '${group['last_message']['msg']}'
        //                                               : "مرفق "
        //                                           : " ",
        //                                       style: TextStyle(
        //                                         fontSize: 12.0,
        //                                         overflow: TextOverflow.ellipsis,
        //                                       ),
        //                                     ),
        //                                     // Text(
        //                                     //   '${group['last_message']['msg']}',
        //                                     //   style: TextStyle(
        //                                     //       fontSize: 13.0),
        //                                     //   overflow:
        //                                     //       TextOverflow.ellipsis,
        //                                     // ),
        //                                   ],
        //                                 ),
        //                               ),
        //                               Padding(
        //                                 padding: const EdgeInsets.all(5.0),
        //                                 child: Column(
        //                                   children: [
        //                                     Text(
        //                                       group['last_message'] != null &&
        //                                               group['last_message']
        //                                                       ['created_at'] !=
        //                                                   null
        //                                           ? '${(DateTime.parse(group['last_message']['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(group['last_message']['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(group['last_message']['created_at']).hour >= 12 ? 'م' : 'ص'}'
        //                                           : ' ',
        //                                       style: TextStyle(
        //                                         fontSize: 13.0,
        //                                         color: Colors.black54,
        //                                       ),
        //                                     ),
        //                                     if (unreadCount > 0)
        //                                       Container(
        //                                         padding: EdgeInsets.all(6),
        //                                         decoration: BoxDecoration(
        //                                           color: AppColor.DeepPurple,
        //                                           borderRadius:
        //                                               BorderRadius.circular(12),
        //                                         ),
        //                                         child: Text(
        //                                           unreadCount.toString(),
        //                                           style: TextStyle(
        //                                             color: Colors.white,
        //                                             fontWeight: FontWeight.bold,
        //                                           ),
        //                                         ),
        //                                       ),
        //                                   ],
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                         Divider(
        //                           height: 10,
        //                           thickness: 1.5,
        //                           color: AppColor.DeepPurple,
        //                         ),
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
        body: GetBuilder<ListStudentChatController>(
          builder: (controller) {
            if (controller.roomlist.isEmpty) {
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
                      mobile: 15,
                      tablet: 40,
                    ),
                  ),
                  itemCount: controller.roomlist.length,
                  itemBuilder: (context, index) {
                    final group = controller.roomlist[index];
                    final unreadCount = group['count_view'] ?? 0;

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
                                '/groupChatTeacher',
                                arguments: {
                                  'name': group['name'],
                                  'idRoom': group['id'].toString(),
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      // صورة المجموعة أو الحرف الأول
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: getValueForScreenType<double>(
                                            context: context,
                                            mobile: 30,
                                            tablet: 45,
                                          ),
                                          backgroundColor: AppColor.DeepPurple2,
                                          child: Text(
                                            group['name'][0].toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 16.0),

                                      // اسم المجموعة والرسالة الأخيرة
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              group['name'],
                                              style: TextStyle(
                                                fontSize:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 15,
                                                      tablet: 20,
                                                    ),
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.PrimaryColor,
                                              ),
                                            ),
                                            Text(
                                              group['last_message'] != null
                                                  ? (group['last_message']['msg'] !=
                                                            null
                                                        ? '${group['last_message']['msg']}'
                                                        : "📎 مرفق")
                                                  : "",
                                              style: TextStyle(
                                                fontSize:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 12,
                                                      tablet: 18,
                                                    ),
                                                color: Colors.black87,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // الوقت وعدد الرسائل غير المقروءة
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              group['last_message'] != null &&
                                                      group['last_message']['created_at'] !=
                                                          null
                                                  ? '${(DateTime.parse(group['last_message']['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(group['last_message']['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(group['last_message']['created_at']).hour >= 12 ? 'م' : 'ص'}'
                                                  : '',
                                              style: TextStyle(
                                                fontSize:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 12,
                                                      tablet: 18,
                                                    ),
                                                color: Colors.black54,
                                              ),
                                            ),
                                            if (unreadCount > 0)
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColor.SecondryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  unreadCount.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        getValueForScreenType<
                                                          double
                                                        >(
                                                          context: context,
                                                          mobile: 12,
                                                          tablet: 18,
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
            );
          },
        ),
      ),
    );
  }
}
