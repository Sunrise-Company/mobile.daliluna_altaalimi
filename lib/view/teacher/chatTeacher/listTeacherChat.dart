import 'package:daliluna_altaalimi/controller/chatStudnet/chat.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
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
      backgroundColor: Color(0xFFF5F7FA),
      drawer: customDrawerTeacher(context),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          getValueForScreenType<double>(
            context: context,
            mobile: 70,
            tablet: 100,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.DeepPurple, AppColor.PrimaryColor],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.DeepPurple.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
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
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: responsiveValue(
                    context: context,
                    mobile: 22,
                    tablet: 35,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "المحادثات",
                  style: TextStyle(
                    fontSize: responsiveValue(
                      context: context,
                      mobile: 20,
                      tablet: 35,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GetBuilder<ListStudentChatController>(
        builder: (controller) {
          if (controller.dataList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "لا توجد محادثات",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "ابدأ محادثة جديدة مع طلابك",
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }

          return AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: controller.dataList.length,
              itemBuilder: (context, index) {
                final student = controller.dataList[index];
                final unreadCount = student['unread_messages_count'] ?? 0;

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    horizontalOffset: 100.0,
                    curve: Curves.easeOutCubic,
                    duration: const Duration(milliseconds: 500),
                    child: FadeInAnimation(
                      child: _buildChatCard(
                        context: context,
                        student: student,
                        unreadCount: unreadCount,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.DeepPurple, AppColor.PrimaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.DeepPurple.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.toNamed('/GroupChatListPageTeacher');
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.groups, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'المجموعات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatCard({
    required BuildContext context,
    required Map<String, dynamic> student,
    required int unreadCount,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() {
          final chatController = Get.put(ChatTeacherController());
          chatController.receiverId.value = student['id'].toString();
          chatController.name.value = student['arabic_name'];
          chatController.markChatAsRead(student['id'].toString());
          return ChatPage();
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: unreadCount > 0
                ? AppColor.DeepPurple.withOpacity(0.2)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: student['image'] == null
                        ? LinearGradient(
                            colors: [
                              AppColor.DeepPurple.withOpacity(0.2),
                              AppColor.PrimaryColor.withOpacity(0.2),
                            ],
                          )
                        : null,
                    border: Border.all(
                      color: unreadCount > 0
                          ? AppColor.DeepPurple
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: student['image'] != null
                        ? NetworkImage('${AppLink.image}/${student['image']}')
                        : null,
                    child: student['image'] == null
                        ? Text(
                            student['arabic_name'][0].toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.DeepPurple,
                              fontSize: responsiveValue(
                                context: context,
                                mobile: 20,
                                tablet: 30,
                              ),
                            ),
                          )
                        : null,
                    radius: responsiveValue(
                      context: context,
                      mobile: 28,
                      tablet: 48,
                    ),
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Color(0xFF4FFFB0),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          student['arabic_name'],
                          style: TextStyle(
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 16,
                              tablet: 24,
                            ),
                            fontWeight: unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (student['last_message'] != null &&
                          student['last_message']['created_at'] != null)
                        Text(
                          '${(DateTime.parse(student['last_message']['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(student['last_message']['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(student['last_message']['created_at']).hour >= 12 ? 'م' : 'ص'}',
                          style: TextStyle(
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 11,
                              tablet: 18,
                            ),
                            color: unreadCount > 0
                                ? AppColor.DeepPurple
                                : Colors.grey[500],
                            fontWeight: unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  if ((student['institutes'] != null &&
                          (student['institutes'] as List).isNotEmpty) ||
                      (student['subjects'] != null &&
                          (student['subjects'] as List).isNotEmpty)) ...[
                    SizedBox(height: 4),
                    Text(
                      '${student['institutes'] != null ? (student['institutes'] as List).join(' - ') : ''} ${(student['institutes'] != null && (student['institutes'] as List).isNotEmpty) && (student['subjects'] != null && (student['subjects'] as List).isNotEmpty) ? '-' : ''} ${student['subjects'] != null ? (student['subjects'] as List).join(' - ') : ''}',
                      style: TextStyle(
                        fontSize: responsiveValue(
                          context: context,
                          mobile: 11,
                          tablet: 16,
                        ),
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          student['last_message'] != null
                              ? student['last_message']['msg'] != null
                                    ? '${student['last_message']['msg']}'
                                    : "📎 مرفق"
                              : "لا توجد رسائل",
                          style: TextStyle(
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 13,
                              tablet: 20,
                            ),
                            color: unreadCount > 0
                                ? Colors.black87
                                : Colors.grey[600],
                            fontWeight: unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.DeepPurple,
                                AppColor.PrimaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.DeepPurple.withOpacity(0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: responsiveValue(
                                context: context,
                                mobile: 11,
                                tablet: 18,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
