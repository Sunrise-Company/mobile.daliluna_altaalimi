import 'package:daliluna_altaalimi/controller/chatStudnet/chat.dart';
import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/widget/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/color.dart';

import '../../widget/GetValueForScreen.dart';
import 'chatStudent.dart';

// ignore: must_be_immutable
class TeacherListPage extends StatelessWidget {
  ChatStudentMessageController chatController = ChatStudentMessageController();
  @override
  Widget build(BuildContext context) {
    chatController.cancelAllNotifications();
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
      drawer: customDrawer(context),
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
      body: GetBuilder<ChatStudentListTeacherController>(
        builder: (controller) {
          if (controller.dataList.isEmpty) {
            return Center(child: Text("لا يوجد"));
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
                            // Get.to(ChatStudent(), arguments: {
                            //   'name': student['name'],
                            //   'id': student['id'].toString()
                            // });
                            Get.to(() {
                              final chatController = Get.put(
                                ChatStudentMessageController(),
                              );
                              chatController.receiverId.value = student['id']
                                  .toString();
                              chatController.studentName.value =
                                  student['name'];

                              chatController.markChatAsRead(
                                student['id'].toString(),
                              );
                              return ChatStudent();
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
                                                student['name'][0]
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
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student['name'],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // HomePageController controller = Get.find();
          // controller.changePage(5);
          Get.toNamed('/GroupChatListPageStudent');
        },
        child: Icon(Icons.groups, color: Colors.white),
        backgroundColor: AppColor.SecondryColor,
        tooltip: 'My group',
      ),
    );
  }
}
