
import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/view/teacher/sutedntTeacher/subjectTeacher.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../controller/teacherController/homeTeacherController.dart';
import 'chatTeacher/groupChat/listgroupChat.dart';
import 'chatTeacher/listTeacherChat.dart';
import 'homeTeacher.dart';

class HomePageTeacher extends GetView<HomePageTeacherController> {
  HomePageTeacher({super.key});

  ChatStudentListTeacherController chatStudentListTeacherController =
      ChatStudentListTeacherController();
  ListStudentChatController listStudentChatController =
      ListStudentChatController();

  @override
  Widget build(BuildContext context) {
    listStudentChatController = Get.put(ListStudentChatController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Obx(() => _buildPage(controller.selectedPage.value)),
        bottomNavigationBar: Obx(() => _buildBottomNavigationBar(controller)),
      ),
    );
  }

  Widget _buildPage(int index) {
    final List<Widget> screens = [
      StudentListPage(),
      HomeTeacher(),
      if (controller.isDeployed.value != 0) SubjectTeacher(),
      GroupChatListPage(),
    ];

    return IndexedStack(index: index, children: screens);
  }

  Widget _buildBottomNavigationBar(HomePageTeacherController controller) {
    final List<IconData> icons = [
      Icons.chat_bubble_outline_sharp,
      Icons.home,
      if (controller.isDeployed.value != 0) Icons.person,
      Icons.group_add,
    ];

    final List<String> labels = [
      'المحادثات',
      'الرئيسية',
      if (controller.isDeployed.value != 0) 'مشتريات الطلاب',
      'المجموعات',
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColor.PrimaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: getValueForScreenType<double>(
          context: Get.context!,
          mobile: 10,
          tablet: 15,
        ),
        horizontal: getValueForScreenType<double>(
          context: Get.context!,
          mobile: 10,
          tablet: 20,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final bool isSelected = controller.selectedPage.value == index;

          final double iconSize = getValueForScreenType<double>(
            context: Get.context!,
            mobile: isSelected ? 25 : 20,
            tablet: isSelected ? 40 : 32,
          );

          final double fontSize = getValueForScreenType<double>(
            context: Get.context!,
            mobile: isSelected ? 10 : 8,
            tablet: isSelected ? 16 : 14,
          );

          return GestureDetector(
            onTap: () {
              controller.changePage(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                vertical: isSelected ? 8 : 5,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.SecondryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[index],
                    size: iconSize,
                    color: isSelected ? AppColor.PrimaryColor : Colors.white,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: fontSize,
                      color: isSelected ? AppColor.PrimaryColor : Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
