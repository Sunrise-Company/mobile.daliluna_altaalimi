import 'package:daliluna_altaalimi/controller/chatStudnet/chatStudentListTeacherController.dart';
import 'package:daliluna_altaalimi/controller/teacherController/chat/listchatStudentForteacherController.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/homepage_controller.dart';
import 'package:daliluna_altaalimi/controller/ourcourses_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/screen/home.dart';
import 'package:daliluna_altaalimi/view/screen/mycourses.dart';
import 'package:daliluna_altaalimi/view/screen/ourcourses.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'chatstudent/chatlist.dart';
import 'exam/examList.dart';

class HomePage extends GetView<HomePageController> {
  HomePage({super.key});

  OurCoursesController ourcontroller = OurCoursesController();
  ChatStudentListTeacherController chatStudentListTeacherController =
      ChatStudentListTeacherController();
  ListStudentChatController listStudentChatController =
      ListStudentChatController();
  // late MainExamControllerss mainExam;

  @override
  Widget build(BuildContext context) {
    // mainExam= Get.put(MainExamControllerss());
    ourcontroller = Get.put(OurCoursesController());
    chatStudentListTeacherController = Get.put(
      ChatStudentListTeacherController(),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Obx(() => _buildPage(controller.selectedPage.value)),
        bottomNavigationBar: Obx(
          () => Visibility(child: _buildBottomNavigationBar(controller)),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    final List<Widget> screens = [
      OurCoursesPage(),
      TeacherListPage(),
      Home(),
      MyCourses(),
      QuizScreen(),
    ];

    return IndexedStack(index: index, children: screens);
  }

  Widget _buildBottomNavigationBar(HomePageController controller) {
    final List<IconData> icons = [
      Icons.menu_book_outlined,
      Icons.message,
      Icons.home,
      Icons.assignment_ind,
      Icons.assignment,
    ];

    final List<String> labels = [
      'الصفوف الدراسية',
      'المحادثات',
      'الرئيسية',
      'دوراتي',
      'الاختبارات',
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
              ourcontroller.fetchmyClassess();
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
