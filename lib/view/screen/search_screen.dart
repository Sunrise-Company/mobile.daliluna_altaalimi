import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daliluna_altaalimi/controller/search_controller.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/controller/ourcourses_controller.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:daliluna_altaalimi/linkapi.dart';

class SearchScreen extends StatelessWidget {
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          getValueForScreenType<double>(
            context: context,
            mobile: 70,
            tablet: 90,
          ),
        ),
        child: AppBar(
          backgroundColor: AppColor.PrimaryColor,
          elevation: 2,
          automaticallyImplyLeading: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(
                getValueForScreenType<double>(
                  context: context,
                  mobile: 20,
                  tablet: 30,
                ),
              ),
            ),
          ),
          title: Text(
            'البحث',
            style: TextStyle(
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 22,
                tablet: 28,
              ),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildTabs(context),
          ),
          Expanded(
            child: Obx(() {
              if (searchController.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColor.PrimaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'جاري البحث...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (searchController.searchQuery.value.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text(
                        'ابحث عن معاهد، مدرسين، أو دروس',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (!searchController.hasResults) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد نتائج',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'حاول البحث بكلمات مختلفة',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }
              return _buildResultsList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getValueForScreenType<double>(
          context: context,
          mobile: 16,
          tablet: 24,
        ),
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 16,
          tablet: 20,
        ),
      ),
      child: TextField(
        onChanged: (value) {
          searchController.searchQuery.value = value;
          searchController.search(value);
        },
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: 'ابحث عن معاهد أو مدرسين أو دروس...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: getValueForScreenType<double>(
              context: context,
              mobile: 14,
              tablet: 16,
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Icon(
              Icons.search,
              color: AppColor.PrimaryColor,
              size: getValueForScreenType<double>(
                context: context,
                mobile: 24,
                tablet: 28,
              ),
            ),
          ),
          suffixIcon: Obx(() {
            if (searchController.searchQuery.value.isNotEmpty) {
              return GestureDetector(
                onTap: () {
                  searchController.searchQuery.value = '';
                  searchController.search('');
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(
                    Icons.close,
                    color: AppColor.PrimaryColor,
                    size: getValueForScreenType<double>(
                      context: context,
                      mobile: 22,
                      tablet: 26,
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: getValueForScreenType<double>(
              context: context,
              mobile: 16,
              tablet: 20,
            ),
            vertical: getValueForScreenType<double>(
              context: context,
              mobile: 14,
              tablet: 16,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              getValueForScreenType<double>(
                context: context,
                mobile: 12,
                tablet: 16,
              ),
            ),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              getValueForScreenType<double>(
                context: context,
                mobile: 12,
                tablet: 16,
              ),
            ),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              getValueForScreenType<double>(
                context: context,
                mobile: 12,
                tablet: 16,
              ),
            ),
            borderSide: BorderSide(color: AppColor.PrimaryColor, width: 2.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      height: getValueForScreenType<double>(
        context: context,
        mobile: 60,
        tablet: 70,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: getValueForScreenType<double>(
          context: context,
          mobile: 8,
          tablet: 12,
        ),
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 8,
          tablet: 10,
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: searchController.tabs.length,
        itemBuilder: (context, index) {
          return Obx(
            () => GestureDetector(
              onTap: () => searchController.changeTab(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  horizontal: getValueForScreenType<double>(
                    context: context,
                    mobile: 20,
                    tablet: 24,
                  ),
                  vertical: getValueForScreenType<double>(
                    context: context,
                    mobile: 10,
                    tablet: 12,
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: getValueForScreenType<double>(
                    context: context,
                    mobile: 6,
                    tablet: 8,
                  ),
                  vertical: getValueForScreenType<double>(
                    context: context,
                    mobile: 2,
                    tablet: 4,
                  ),
                ),
                decoration: BoxDecoration(
                  color: searchController.currentTabIndex.value == index
                      ? AppColor.PrimaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(
                    getValueForScreenType<double>(
                      context: context,
                      mobile: 20,
                      tablet: 24,
                    ),
                  ),
                  border: Border.all(
                    color: searchController.currentTabIndex.value == index
                        ? AppColor.PrimaryColor
                        : Colors.grey[300]!,
                    width: 1.5,
                  ),
                  boxShadow: searchController.currentTabIndex.value == index
                      ? [
                          BoxShadow(
                            color: AppColor.PrimaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    searchController.tabs[index],
                    style: TextStyle(
                      color: searchController.currentTabIndex.value == index
                          ? Colors.white
                          : Colors.black87,
                      fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 12,
                        tablet: 14,
                      ),
                      fontWeight:
                          searchController.currentTabIndex.value == index
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsList() {
    return Obx(() {
      final results = searchController.currentResults;
      if (results.isEmpty) {
        return Center(child: Text('لا توجد نتائج'));
      }

      return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];
          return _buildResultItem(item);
        },
      );
    });
  }

  Widget _buildResultItem(dynamic item) {
    switch (searchController.currentTabIndex.value) {
      case 0: // Institutes
        return _buildInstituteItem(item);
      case 1: // Teachers
        return _buildTeacherItem(item);
      case 2: // Lessons
        return _buildLessonItem(item);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildInstituteItem(Map<String, dynamic> institute) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToInstituteClasses(institute);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: '${AppLink.image}/${institute['image']}',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: Icon(Icons.school, size: 35, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: Icon(Icons.school, size: 35, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        institute['name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColor.PrimaryColor,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              institute['city']?['name'] ?? 'غير محدد',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColor.PrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToInstituteClasses(Map<String, dynamic> institute) {
    if (institute['id'] == null) return;

    final coursesController = Get.find<OurCoursesController>();
    coursesController.loadClassesForInstitute(
      institute['id'],
      instituteName: institute['name'],
    );
    Get.toNamed(AppRoute.ourCourses);
  }

  void _navigateToTeacherCourses(Map<String, dynamic> teacher) {
    if (teacher['id'] == null) return;

    // Navigate to SectionSelected with teacher's sections
    Get.toNamed(
      AppRoute.sectionSelected,
      arguments: {
        'teacher_id': teacher['id'],
        'teacher_name': teacher['name'],
        'teacher_image': teacher['image'],
        'subjetcsid': teacher['subject_id'] ?? 0,
        'classid': teacher['class_id'] ?? 0,
      },
    );
  }

  Widget _buildTeacherItem(Map<String, dynamic> teacher) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToTeacherCourses(teacher);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                teacher['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: CachedNetworkImage(
                          imageUrl: '${AppLink.image}/${teacher['image']}',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, size: 35, color: Colors.grey),
                      ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        teacher['name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.school,
                            size: 14,
                            color: AppColor.PrimaryColor,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              teacher['education'] ?? 'معلم',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColor.PrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonItem(Map<String, dynamic> lesson) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToLessonDetails(lesson);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: lesson['image'] != null
                      ? CachedNetworkImage(
                          imageUrl: '${AppLink.image}/${lesson['image']}',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.menu_book,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.menu_book,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.menu_book,
                            size: 35,
                            color: Colors.grey,
                          ),
                        ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lesson['name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.book,
                            size: 14,
                            color: AppColor.PrimaryColor,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'درس تعليمي',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColor.PrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToLessonDetails(Map<String, dynamic> lesson) async {
    if (lesson['id'] == null) return;

    try {
      // Check if user is logged in
      final prefs = await SharedPreferences.getInstance();
      final studentId = prefs.getString('student_id');

      // Determine lesson type (lecture or lesson)
      final lessonType = lesson['type'] ?? 'lesson'; // 'lecture' or 'lesson'
      final isFree = lesson['free_status'] == '1' || lesson['free_status'] == 1;

      // If it's free, navigate directly
      if (isFree) {
        _navigateToVideoPage(lesson, lessonType);
        return;
      }

      // If not logged in, show login message
      if (studentId == null || studentId.isEmpty) {
        Get.snackbar(
          'تسجيل الدخول مطلوب',
          'يجب تسجيل الدخول لعرض هذا المحتوى',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade800,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return;
      }

      // Check if user has purchased this lesson
      final hasPurchased = await _checkIfPurchased(lesson['id'], lessonType);

      if (hasPurchased) {
        _navigateToVideoPage(lesson, lessonType);
      } else {
        Get.snackbar(
          'محتوى مقفل',
          'يجب شراء هذا المحتوى لعرضه',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade800,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء معالجة الطلب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
      );
      print('Error in _navigateToLessonDetails: $e');
    }
  }

  void _navigateToVideoPage(Map<String, dynamic> lesson, String lessonType) {
    if (lessonType == 'lecture') {
      // Navigate to lecture/video page
      Get.toNamed(
        AppRoute.vedios,
        arguments: {
          'lectureid': lesson['id'],
          'lecture_name': lesson['name'],
          'lecture_image': lesson['image'],
          'isPurchase': true,
          'isFreePreview':
              lesson['free_status'] == '1' || lesson['free_status'] == 1,
        },
      );
    } else {
      // Navigate to lesson details page
      Get.toNamed(
        AppRoute.lessonDetails,
        arguments: {
          'lesson_id': lesson['id'],
          'lesson_name': lesson['name'],
          'lesson_image': lesson['image'],
          'isPurchase': true,
          'isFreePreview':
              lesson['free_status'] == '1' || lesson['free_status'] == 1,
        },
      );
    }
  }

  Future<bool> _checkIfPurchased(dynamic lessonId, String lessonType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final studentId = prefs.getString('student_id');

      if (studentId == null || studentId.isEmpty) {
        return false;
      }

      if (lessonType == 'lecture') {
        // Check if lecture is purchased
        final myLectures = await ApiService.fetchMyLectures(studentId);
        return myLectures.any((lecture) => lecture['id'] == lessonId);
      } else {
        // Check if lesson is purchased
        final myLessons = await ApiService.fetchMyLessonSections(studentId);
        return myLessons.any((lesson) => lesson['id'] == lessonId);
      }
    } catch (e) {
      print('Error checking purchase: $e');
      return false;
    }
  }
}
