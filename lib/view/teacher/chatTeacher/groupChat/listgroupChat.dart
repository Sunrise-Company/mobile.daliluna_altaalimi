import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:daliluna_altaalimi/view/widget/customDrawerTeacher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constant/color.dart';
import '../../../widget/GetValueForScreen.dart';

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
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.groups,
                    color: Colors.white,
                    size: responsiveValue(
                      context: context,
                      mobile: 24,
                      tablet: 35,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "مجموعات الدردشة",
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
            if (controller.roomlist.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_off_outlined,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "لا توجد مجموعات",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "أنشئ مجموعة جديدة لبدء المحادثة",
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                  ],
                ),
              );
            }

            return AnimationLimiter(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemCount: controller.roomlist.length,
                itemBuilder: (context, index) {
                  final group = controller.roomlist[index];
                  final unreadCount = group['count_view'] ?? 0;

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      horizontalOffset: 100.0,
                      curve: Curves.easeOutCubic,
                      duration: const Duration(milliseconds: 600),
                      child: FadeInAnimation(
                        child: _buildGroupChatCard(
                          context,
                          group,
                          unreadCount,
                          index,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGroupChatCard(
    BuildContext context,
    dynamic group,
    int unreadCount,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/groupChatTeacher',
          arguments: {'name': group['name'], 'idRoom': group['id'].toString()},
        );
      },
      child: Container(
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
                    gradient: LinearGradient(
                      colors: [
                        AppColor.DeepPurple.withOpacity(0.2),
                        AppColor.PrimaryColor.withOpacity(0.2),
                      ],
                    ),
                    border: Border.all(
                      color: unreadCount > 0
                          ? AppColor.DeepPurple
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: responsiveValue(
                      context: context,
                      mobile: 28,
                      tablet: 48,
                    ),
                    child: Text(
                      group['name'][0].toUpperCase(),
                      style: TextStyle(
                        fontSize: responsiveValue(
                          context: context,
                          mobile: 22,
                          tablet: 32,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppColor.DeepPurple,
                      ),
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
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group['name'],
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (group['last_message'] != null &&
                          group['last_message']['created_at'] != null)
                        Text(
                          '${(DateTime.parse(group['last_message']['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(group['last_message']['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(group['last_message']['created_at']).hour >= 12 ? 'م' : 'ص'}',
                          style: TextStyle(
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 11,
                              tablet: 16,
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
                  if (group['institute_name'] != null ||
                      group['class_name'] != null) ...[
                    SizedBox(height: 4),
                    Text(
                      '${group['institute_name'] ?? ''} ${group['institute_name'] != null && group['class_name'] != null ? '-' : ''} ${group['class_name'] ?? ''}',
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
                          group['last_message'] != null
                              ? (group['last_message']['msg'] != null &&
                                        group['last_message']['msg']
                                            .toString()
                                            .isNotEmpty
                                    ? '${group['last_message']['msg']}'
                                    : "📎 مرفق")
                              : "ابدأ المحادثة...",
                          style: TextStyle(
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 13,
                              tablet: 18,
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
                            unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveValue(
                                context: context,
                                mobile: 10,
                                tablet: 14,
                              ),
                              fontWeight: FontWeight.bold,
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
