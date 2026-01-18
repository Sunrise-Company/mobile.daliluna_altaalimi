import 'dart:developer';

import 'package:daliluna_altaalimi/controller/sectionssubject_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daliluna_altaalimi/controller/search_controller.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/controller/unitssubject_controller.dart';
import 'package:daliluna_altaalimi/controller/ourcourses_controller.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/view/widget/basketWidget.dart';
import 'package:daliluna_altaalimi/view/widget/customcardsections.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:daliluna_altaalimi/linkapi.dart';

class SearchScreen extends StatelessWidget {
  final SearchController searchController = Get.put(SearchController());
  final SectionsSubjectController sectionsController = Get.put(
    SectionsSubjectController(),
  );
  final UnitsSubjectController unitsController = Get.put(
    UnitsSubjectController(),
  );

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
          _buildFilterDropdown(context),
          Expanded(
            child: Obx(() {
              if (searchController.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loading(),
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
      floatingActionButton:  BasketWidget(heroTag: 'search_basket'),
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
        controller: searchController.textController,
        autofocus: false, // إلغاء التركيز التلقائي
        onChanged: (value) {
          // استخدام debounce لتأخير البحث وتقليل طلبات API
          searchController.debouncedSearch(value);
        },
        textDirection: TextDirection.rtl,
        textInputAction: TextInputAction.search, // زر بحث في الكيبورد
        onSubmitted: (value) {
          // البحث فوراً عند الضغط على زر البحث
          searchController.search(value);
          FocusScope.of(context).unfocus();
        },
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
                  searchController.clearSearch();
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

  String? _getProvinceName(Map<String, dynamic> item) {
    // 1. Direct city/governorate field (String or Map)
    if (item['city'] != null) {
      if (item['city'] is String) return item['city'];
      if (item['city'] is Map && item['city']['name'] != null) {
        return item['city']['name'];
      }
    }
    if (item['governorate'] != null) {
      if (item['governorate'] is String) return item['governorate'];
      if (item['governorate'] is Map && item['governorate']['name'] != null) {
        return item['governorate']['name'];
      }
    }

    // 2. Nested in classes -> institute -> city
    if (item['classes'] != null &&
        item['classes']['institute'] != null &&
        item['classes']['institute']['city'] != null) {
      final city = item['classes']['institute']['city'];
      if (city is String) return city;
      if (city is Map && city['name'] != null) return city['name'];
    }

    // 3. Nested in lessons (for teachers)
    if (item['lessons'] != null && (item['lessons'] as List).isNotEmpty) {
      final firstLesson = item['lessons'][0];
      if (firstLesson['classes'] != null &&
          firstLesson['classes']['institute'] != null &&
          firstLesson['classes']['institute']['city'] != null) {
        final city = firstLesson['classes']['institute']['city'];
        if (city is String) return city;
        if (city is Map && city['name'] != null) return city['name'];
      }
    }

    // 4. Nested in app_classes_lessons_main_dep (for lesson_deps/sections)
    if (item['app_classes_lessons_main_dep'] != null &&
        (item['app_classes_lessons_main_dep'] as List).isNotEmpty) {
      final mainDep = item['app_classes_lessons_main_dep'][0];
      if (mainDep['app_class'] != null &&
          mainDep['app_class']['institute'] != null &&
          mainDep['app_class']['institute']['city'] != null) {
        final city = mainDep['app_class']['institute']['city'];
        if (city is String) return city;
        if (city is Map && city['name'] != null) return city['name'];
      }
    }

    return null;
  }

  Widget _buildResultItem(dynamic item) {
    switch (searchController.currentTabIndex.value) {
      case 0: // Institutes
        return _buildInstituteItem(item);
      case 1: // Teachers
        return _buildTeacherItem(item);
      case 2: // Lessons
        return _buildLessonItem(item);
      case 3: // Units or Lesson Deps
        if (searchController.selectedSearchType.value == 'منهاج') {
          return _buildUnitItem(item);
        } else {
          return _buildLessonDepItem(item);
        }
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
                              '${institute['city']?['name'] ?? 'غير محدد'} - ${institute['address'] ?? ''}',
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

    // Extract subject_id and class_id safely
    String subjectId = (teacher['subject_id'] ?? 0).toString();
    String classId = (teacher['class_id'] ?? 0).toString();

    // Fallback extraction from lessons if top-level is missing/zero
    if ((subjectId == '0' || classId == '0') &&
        teacher['lessons'] != null &&
        (teacher['lessons'] as List).isNotEmpty) {
      final firstLesson = teacher['lessons'][0];

      subjectId = firstLesson['id'].toString();

      if (firstLesson['class_id'] != null) {
        classId = firstLesson['class_id'].toString();
      } else if (firstLesson['classes'] != null &&
          firstLesson['classes']['id'] != null) {
        classId = firstLesson['classes']['id'].toString();
      }
    }

    // Navigate to SectionSelected with teacher's sections
    Get.toNamed(
      AppRoute.sectionSelected,
      arguments: {
        'teacher_id': teacher['id'],
        'teacher_name': teacher['name'],
        'teacher_image': teacher['image'],
        'subjetcsid': subjectId,
        'classid': classId,
      },
    );
  }

  Widget _buildTeacherItem(Map<String, dynamic> teacher) {
    final lessons = teacher['lessons'] as List<dynamic>? ?? [];
    String? instituteName;
    String? className;

    if (lessons.isNotEmpty) {
      final firstLesson = lessons[0];
      final classes = firstLesson['classes'];
      if (classes != null) {
        className = classes['name'];
        final institute = classes['institute'];
        if (institute != null) {
          instituteName = institute['name'];
        }
      }
    }

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
                      if (instituteName != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 14,
                              color: AppColor.PrimaryColor,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                instituteName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.PrimaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                      ],
                      if (_getProvinceName(teacher) != null) ...[
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
                                _getProvinceName(teacher)!,
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
                        SizedBox(height: 4),
                      ],
                      Row(
                        children: [
                          Icon(
                            Icons.school,
                            size: 14,
                            color: AppColor.PrimaryColor,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${teacher['education'] ?? 'معلم'}${className != null ? ' - $className' : ''}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (teacher['description'] != null)
                                  Text(
                                    teacher['description'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
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
            _navigateToTeacherSubject(lesson);
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lesson['classes']?['name'] ?? ''} - ${lesson['classes']?['institute']?['name'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (_getProvinceName(lesson) != null) ...[
                                  SizedBox(height: 4),
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
                                          _getProvinceName(lesson)!,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Obx(() {
                //   final isInMySections = sectionsController.mysection.any((
                //     section,
                //   ) {
                //     if (section != null) {
                //       return section['id'].toString() ==
                //           lesson['id'].toString();
                //     }
                //     return false;
                //   });

                //   if (isInMySections) {
                //     return Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(Icons.check_circle, color: AppColor.SecondryColor),
                //         SizedBox(width: 5),
                //         Text(
                //           "تم الاشتراك",
                //           style: TextStyle(
                //             color: AppColor.DeepPurple,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 12,
                //           ),
                //         ),
                //       ],
                //     );
                //   }

                //   return IconButton(
                //     icon: Icon(
                //       Icons.add_shopping_cart,
                //       color: AppColor.PrimaryColor,
                //       size: 24,
                //     ),
                //     onPressed: () {
                //       _addLessonToCart(lesson);
                //     },
                //   );
                // }),
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

  Widget _buildUnitItem(Map<String, dynamic> unit) {
    final teacher = unit['teacher'];
    final lesson = unit['lesson'];
    final price = unit['price'] ?? 0;

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
            _navigateToUnitDetails(unit);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: lesson != null && lesson['image'] != null
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
                              Icons.library_books,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.library_books,
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
                            Icons.library_books,
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
                        unit['name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      if (teacher != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 14,
                              color: AppColor.PrimaryColor,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                teacher['name'] ?? 'غير محدد',
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
                        SizedBox(height: 4),
                      ],
                      if (lesson != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              size: 14,
                              color: AppColor.PrimaryColor,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                lesson['name'] ?? '',
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
                        SizedBox(height: 4),
                      ],
                      if (_getProvinceName(unit) != null) ...[
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
                                _getProvinceName(unit)!,
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
                        SizedBox(height: 4),
                      ],
                      Text(
                        '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ل.س',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.PrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Obx(() {
                //   final isInMySections = unitsController.myunits.any((section) {
                //     if (section != null) {
                //       log(section['app_teacher_id'].toString());
                //       log(teacher!['id'].toString());
                //       log(section['app_lesson_id'].toString());
                //       log(lesson!['id'].toString());
                //       log(section['app_class_id'].toString());
                //       log(lesson!['app_class_id'].toString());
                //       return section['app_teacher_id'].toString() ==
                //               teacher?['id'].toString() &&
                //           section['app_lesson_id'].toString() ==
                //               lesson?['id'].toString() &&
                //           section['app_class_id'].toString() ==
                //               lesson?['app_class_id'].toString();
                //     }
                //     return false;
                //   });

                //   if (isInMySections) {
                //     return Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(Icons.check_circle, color: AppColor.SecondryColor),
                //         SizedBox(width: 5),
                //         Text(
                //           "تم الاشتراك",
                //           style: TextStyle(
                //             color: AppColor.DeepPurple,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 12,
                //           ),
                //         ),
                //       ],
                //     );
                //   }

                //   return IconButton(
                //     icon: Icon(
                //       Icons.add_shopping_cart,
                //       color: AppColor.PrimaryColor,
                //       size: 24,
                //     ),
                //     onPressed: () {
                //       _addUnitToCart(unit);
                //     },
                //   );
                // }),
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

  Widget _buildLessonDepItem(Map<String, dynamic> lessonDep) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomListTileSectionWidget(
        item: lessonDep,
        isChecking: false, // No need for checking state in search
        province: _getProvinceName(lessonDep),
        onTap: () {
          _navigateToLessonDepDetails(lessonDep);
        },
        onTapShop: () {
          _addLessonDepToCart(lessonDep);
        },
        trailing: Obx(() {
          final allSectionItem = lessonDep;
          final isInMySections = sectionsController.mysection.any((section) {
            final departments = section as Map;
            if (departments['app_classes_lessons_main_department'] != null &&
                (departments['app_classes_lessons_main_department'] as List)
                    .isNotEmpty &&
                allSectionItem['app_classes_lessons_main_dep'] != null &&
                (allSectionItem['app_classes_lessons_main_dep'] as List)
                    .isNotEmpty) {
              return departments['app_classes_lessons_main_department'][0]['main_dep_id']
                          .toString() ==
                      allSectionItem['app_classes_lessons_main_dep'][0]['main_dep_id']
                          .toString() &&
                  departments['app_classes_lessons_main_department'][0]['app_teacher_id']
                          .toString() ==
                      allSectionItem['app_classes_lessons_main_dep'][0]['app_teacher_id']
                          .toString() &&
                  departments['app_classes_lessons_main_department'][0]['app_class_id']
                          .toString() ==
                      allSectionItem['app_classes_lessons_main_dep'][0]['app_class_id']
                          .toString();
            }
            return false;
          });

          if (isInMySections) {
            return Icon(Icons.check_circle, color: AppColor.SecondryColor);
          }

          return SizedBox();
        }),
      ),
    );
  }

  void _navigateToUnitDetails(Map<String, dynamic> unit) {
    if (unit['id'] == null) return;

    final lesson = unit['lesson'];

    // Navigate to lessons within the unit
    Get.toNamed(
      AppRoute.lessons,
      arguments: {'unitsid': unit['id'], 'subject_id': lesson?['id'] ?? 0},
    );
  }

  void _navigateToLessonDepDetails(Map<String, dynamic> lessonDep) async {
    if (lessonDep['id'] == null) return;

    try {
      final videos = await ApiService.fetchSectionVideos(lessonDep['id']);
      final bool hasFreeVideos = videos.any(
        (video) => video['free_status'] == "1",
      );

      // Check if main_dep type is 4 (exam sessions - always accessible)
      if (lessonDep['main_dep']?['type']?.toString() == '4') {
        Get.toNamed(
          AppRoute.viewLessons,
          arguments: {
            "lessonsectionsid": lessonDep['id'],
            "lessonsectionsName": lessonDep['name'],
            'isPurchase': true,
            'isFreePreview': false,
          },
        );
      } else if (hasFreeVideos) {
        Get.toNamed(
          AppRoute.viewLessons,
          arguments: {
            "lessonsectionsid": lessonDep['id'],
            "lessonsectionsName": lessonDep['name'],
            'isPurchase': false,
            'isFreePreview': true,
          },
        );
      } else {
        Get.snackbar(
          "لا يوجد محتوى مجاني",
          "هذا القسم لا يحتوي على فيديوهات مجانية للمعاينة.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade800,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء التحقق من المحتوى.");
    }
  }

  void _navigateToTeacherSubject(Map<String, dynamic> lesson) {
    if (lesson['id'] == null) return;
    Get.toNamed(
      AppRoute.teacher,
      arguments: {
        "subjetcsid": lesson['id'].toString(),
        'classid': lesson['classes']?['id']?.toString() ?? '0',
      },
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
      return false;
    }
  }

  void _addLessonToCart(Map<String, dynamic> lesson) {
    final basketController = Get.find<BasketController>();

    // Extract lesson details
    final lessonId = lesson['id']?.toString() ?? '';
    final lessonName = lesson['name'] ?? '';
    final lessonPrice = 0; // Lessons might not have price in search results

    // Extract teacher, class, and institute info
    final classes = lesson['classes'];
    final className = classes?['name'] ?? '';
    final classId = classes?['id']?.toString() ?? '';

    final institute = classes?['institute'];
    final instituteName = institute?['name'] ?? '';

    // Add to basket
    basketController.updateBasket(
      lessonId,
      'lesson',
      lessonName,
      lessonPrice,
      '', // teacherName - not available in lesson object
      className,
      lessonName, // subjectName
      '', // teacherId
      classId,
      lessonId, // subjectId
      '',
      ///////////////
      '',
    );
  }

  void _addUnitToCart(Map<String, dynamic> unit) {
    final basketController = Get.find<BasketController>();

    // Extract unit details
    final unitId = unit['id']?.toString() ?? '';
    final unitName = unit['name'] ?? '';
    final unitPrice = unit['price'] ?? 0;

    // Extract teacher and lesson info
    final teacher = unit['teacher'];
    final lesson = unit['lesson'];

    final teacherName = teacher?['name'] ?? '';
    final teacherId = teacher?['id']?.toString() ?? '';
    final lessonName = lesson?['name'] ?? '';
    final lessonId = lesson?['id']?.toString() ?? '';
    final classId = lesson?['app_class_id']?.toString() ?? '';

    // Add to basket
    basketController.updateBasket(
      unitId,
      'unit', // item type
      unitName,
      unitPrice,
      teacherName,
      '', // className - not directly available for units
      lessonName, // subjectName
      teacherId,
      classId,
      lessonId, // subjectId
      '',
      ////////////////////,
      '',
      // maindepId
    );

    Get.snackbar(
      'تمت الإضافة',
      'تمت إضافة الوحدة إلى السلة',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.PrimaryColor,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void _addLessonDepToCart(Map<String, dynamic> lessonDep) {
    final basketController = Get.find<BasketController>();

    // Extract lesson_dep details
    final lessonDepId = lessonDep['id']?.toString() ?? '';
    final lessonDepName = lessonDep['name'] ?? '';
    final lessonDepPrice = lessonDep['price'] ?? 0;

    // Extract teacher, lesson, and main_dep info
    final teacher = lessonDep['teacher'];
    final lesson = lessonDep['lesson'];
    final mainDep = lessonDep['main_dep'];

    final teacherName = teacher?['name'] ?? '';
    final teacherId = teacher?['id']?.toString() ?? '';
    final lessonName = lesson?['name'] ?? '';
    final lessonId = lesson?['id']?.toString() ?? '';
    final classId = lesson?['app_class_id']?.toString() ?? '';
    final mainDepId = mainDep?['id']?.toString() ?? '';

    // Add to basket
    basketController.updateBasket(
      lessonDepId,
      'lesson_dep', // item type
      lessonDepName,
      lessonDepPrice,
      teacherName,
      '', // className - not directly available
      lessonName, // subjectName
      teacherId,
      classId,
      lessonId, // subjectId
      mainDepId, // maindepId
      ////////////////,
      '',
    );

    Get.snackbar(
      'تمت الإضافة',
      'تمت إضافة القسم إلى السلة',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.PrimaryColor,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  Widget _buildFilterDropdown(BuildContext context) {
    return Obx(() {
      // Only show dropdown if current tab is Units (index 3)
      if (searchController.currentTabIndex.value != 3) {
        return SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getValueForScreenType<double>(
            context: context,
            mobile: 20,
            tablet: 28,
          ),
          vertical: 8,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: searchController.selectedSearchType.value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppColor.PrimaryColor),
              items: searchController.searchTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  searchController.selectedSearchType.value = newValue;
                  // Trigger search again if there is a query
                  if (searchController.searchQuery.value.isNotEmpty) {
                    searchController.search(
                      searchController.searchQuery.value,
                      maintainTab: true,
                    );
                  }
                }
              },
            ),
          ),
        ),
      );
    });
  }
}
