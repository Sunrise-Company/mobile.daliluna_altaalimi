// ignore_for_file: must_be_iacademyv3utable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daliluna_altaalimi/view/widget/breadcrumb_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/sectionselected_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcard.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';
import 'package:daliluna_altaalimi/view/widget/customiconbasket.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';

import '../../linkapi.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';
import '../widget/loadingimage.dart';
import 'package:daliluna_altaalimi/view/widget/animated_cart_icon.dart';
import 'package:daliluna_altaalimi/core/constant/cart_keys.dart';

class SectionSelected extends GetView<SectionSelectedController> {
  SectionSelected({super.key});
  late BasketController baskerc;

  @override
  Widget build(BuildContext context) {
    baskerc = Get.put(BasketController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                "الدورات",
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
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(
        //     getValueForScreenType<double>(
        //       context: context,
        //       mobile: 55,
        //       tablet: 100,
        //     ),
        //   ),
        //   child: AppBar(
        //     leading: CustomIconAppBar(),
        //     actions: [
        //       Obx(
        //         () => CustomIconBasket(
        //             text: baskerc.mycart.length != 0
        //                 ? baskerc.mycart.length.toString()
        //                 : "0"),
        //       ),
        //     ],
        //     elevation: 0,
        //     flexibleSpace: Container(
        //       decoration: BoxDecoration(
        //         gradient: LinearGradientPainter(
        //           begin: Alignment.topRight,
        //           end: Alignment.topCenter,
        //           colors: <Color>[AppColor.DeepPurple, AppColor.DeepPurple],
        //         ),
        //       ),
        //     ),
        //     title: Text(
        //       "الدورات",
        //       style: TextStyle(
        //         color: AppColor.White,
        //         fontSize: getValueForScreenType<double>(
        //           context: context,
        //           mobile: 20,
        //           tablet: 30,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // backgroundColor: AppColor.BackGround2,
        // body: Padding(
        //   padding: const EdgeInsets.all(13.0),
        //   child: GetBuilder<SectionSelectedController>(
        //       builder: (controller) => controller.isLoadingtow
        //           ? controller.dataList.isNotEmpty
        //               ? AnimationLimiter(
        //                   child: GlowingOverscrollIndicator(
        //                       axisDirection: AxisDirection.down,
        //                       color: AppColor.SecondryColor,
        //                       child: GridView.builder(
        //                         gridDelegate:
        //                             SliverGridDelegateWithMaxCrossAxisExtent(
        //                           maxCrossAxisExtent:
        //                               getValueForScreenType<double>(
        //                             context: context,
        //                             mobile: 300,
        //                             tablet: 600,
        //                           ),
        //                           mainAxisExtent: 230,
        //                           childAspectRatio:
        //                               getValueForScreenType<double>(
        //                             context: context,
        //                             mobile: 8 / 8,
        //                             tablet: 8 / 5,
        //                           ),
        //                           crossAxisSpacing:
        //                               getValueForScreenType<double>(
        //                             context: context,
        //                             mobile: 7,
        //                             tablet: 10,
        //                           ),
        //                           mainAxisSpacing:
        //                               getValueForScreenType<double>(
        //                             context: context,
        //                             mobile: 15,
        //                             tablet: 30,
        //                           ),
        //                         ),
        //                         scrollDirection: Axis.vertical,
        //                         shrinkWrap: false,
        //                         itemCount: controller.dataList.length,
        //                         itemBuilder:
        //                             (BuildContext context, int index) {
        //                           final isSectionFree = controller
        //                                   .dataList[index]['type']
        //                                   .toString() ==
        //                               '4';
        //
        //                           return AnimationConfiguration.staggeredList(
        //                             position: index,
        //                             duration:
        //                                 const Duration(milliseconds: 500),
        //                             child: SlideAnimation(
        //                               horizontalOffset: 200.0,
        //                               curve: Curves.ease,
        //                               duration:
        //                                   const Duration(milliseconds: 600),
        //                               child: FadeInAnimation(
        //                                 child: Card(
        //                                   elevation: 5,
        //                                   shadowColor: AppColor.SecondryColor,
        //                                   shape: RoundedRectangleBorder(
        //                                       borderRadius:
        //                                           BorderRadius.circular(25)),
        //                                   color: AppColor.BackGround,
        //                                   child: Container(
        //                                     decoration: BoxDecoration(
        //                                       borderRadius:
        //                                           BorderRadius.circular(30),
        //                                       color: AppColor.BackGround,
        //                                     ),
        //                                     padding: EdgeInsets.all(
        //                                       getValueForScreenType<double>(
        //                                         context: context,
        //                                         mobile: 10,
        //                                         tablet: 20,
        //                                       ),
        //                                     ),
        //                                     child: InkWell(
        //                                       onTap: () {
        //                                         baskerc.updatemaindepId(
        //                                             controller.dataList[index]
        //                                                     ['id']
        //                                                 .toString());
        //
        //                                         print(controller
        //                                             .dataList[index]['id']);
        //                                         controller.goToSections(
        //                                             controller.dataList[index]
        //                                                     ['id']
        //                                                 .toString(),
        //                                             Get.arguments[
        //                                                     'subjetcsid']
        //                                                 .toString(),
        //                                             Get.arguments[
        //                                                     'teacher_id']
        //                                                 .toString(),
        //                                             controller.dataList[index]
        //                                                     ['type']
        //                                                 .toString());
        //                                         baskerc.updatemaindepId(
        //                                             controller.dataList[index]
        //                                                     ['id']
        //                                                 .toString());
        //
        //                                       },
        //                                       child: Container(
        //                                         decoration: BoxDecoration(
        //                                           color: AppColor.BackGround,
        //                                           borderRadius:
        //                                               BorderRadius.circular(
        //                                                   30),
        //                                         ),
        //                                         child: Column(
        //                                           mainAxisAlignment:
        //                                               MainAxisAlignment
        //                                                   .spaceAround,
        //                                           children: [
        //                                             SizedBox(
        //                                                 height:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 100,
        //                                                   tablet: 80,
        //                                                 ),
        //                                                 width:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 100,
        //                                                   tablet: 110,
        //                                                 ),
        //                                                 child: controller.dataList[index]['image'] !=
        //                                                         null
        //                                                     ? CachedNetworkImage(
        //                                                         fit:
        //                                                             BoxFit
        //                                                                 .fill,
        //                                                         placeholder:
        //                                                             (context, url) =>
        //                                                                 LoadingImage(),
        //                                                         errorWidget: (context,
        //                                                                 url,
        //                                                                 error) =>
        //                                                             Icon(Icons
        //                                                                 .error),
        //                                                         imageUrl: AppLink
        //                                                                 .image +
        //                                                             "/" +
        //                                                             controller.dataList[index]
        //                                                                 ['image']!)
        //                                                     : Text('')),
        //                                             SizedBox(
        //                                               height:
        //                                                   getValueForScreenType<
        //                                                       double>(
        //                                                 context: context,
        //                                                 mobile: 10,
        //                                                 tablet: 20,
        //                                               ),
        //                                             ),
        //                                             SizedBox(
        //                                               width:
        //                                                   getValueForScreenType<
        //                                                       double>(
        //                                                 context: context,
        //                                                 mobile: 200,
        //                                                 tablet: 300,
        //                                               ),
        //                                               height:
        //                                                   getValueForScreenType<
        //                                                       double>(
        //                                                 context: context,
        //                                                 mobile: 40,
        //                                                 tablet: 55,
        //                                               ),
        //                                               child: Center(
        //                                                 child: Text(
        //                                                   controller.dataList[
        //                                                       index]['name'],
        //                                                   style: TextStyle(
        //                                                       fontWeight:
        //                                                           FontWeight
        //                                                               .bold,
        //                                                       fontSize:
        //                                                           getValueForScreenType<
        //                                                               double>(
        //                                                         context:
        //                                                             context,
        //                                                         mobile: 15,
        //                                                         tablet: 17,
        //                                                       ),
        //                                                       color: AppColor
        //                                                           .PrimaryColor),
        //                                                 ),
        //                                               ),
        //                                             ),
        //                                             controller.dataList[index]
        //                                                             ['id']
        //                                                         .toString() !=
        //                                                     '5'
        //                                                 ? Container(
        //                                                     decoration: BoxDecoration(
        //                                                         color: Colors
        //                                                             .white,
        //                                                         borderRadius:
        //                                                             BorderRadius
        //                                                                 .circular(
        //                                                                     10)),
        //                                                     width:
        //                                                         getValueForScreenType<
        //                                                             double>(
        //                                                       context:
        //                                                           context,
        //                                                       mobile: 140,
        //                                                       tablet: 170,
        //                                                     ),
        //                                                     height:
        //                                                         getValueForScreenType<
        //                                                             double>(
        //                                                       context:
        //                                                           context,
        //                                                       mobile: 35,
        //                                                       tablet: 45,
        //                                                     ),
        //                                                     child: Center(
        //                                                       child: Row(
        //                                                         mainAxisAlignment:
        //                                                             MainAxisAlignment
        //                                                                 .spaceAround,
        //                                                         children: [
        //
        //                                                           Text(
        //                                                             controller.dataList[index]['app_classes_lessons_main_dep'] != null &&
        //                                                                     (controller.dataList[index]['app_classes_lessons_main_dep'] as List)
        //                                                                         .isNotEmpty
        //                                                                 ? controller.dataList[index]['app_classes_lessons_main_dep'][0]['main_price']?.toString() ??
        //                                                                     '0'
        //                                                                 : isSectionFree
        //                                                                     ? 'استعراض'
        //                                                                     : '0',
        //                                                             style:
        //                                                                 TextStyle(
        //                                                               fontWeight:
        //                                                                   FontWeight.bold,
        //                                                               fontSize:
        //                                                                   getValueForScreenType<double>(
        //                                                                 context:
        //                                                                     context,
        //                                                                 mobile:
        //                                                                     13,
        //                                                                 tablet:
        //                                                                     15,
        //                                                               ),
        //                                                               color: AppColor
        //                                                                   .PrimaryColor,
        //                                                             ),
        //                                                           ),
        //                                                           Obx(() {
        //                                                             // log('allll');
        //                                                             final allSectionItem =
        //                                                                 controller
        //                                                                     .dataList[index];
        //                                                             final itemId =
        //                                                                 allSectionItem['id']
        //                                                                     .toString();
        //                                                             final teacherId = baskerc
        //                                                                 .teacherId
        //                                                                 .value;
        //                                                             final subjectId = baskerc
        //                                                                 .subjectId
        //                                                                 .value;
        //                                                             final classId = baskerc
        //                                                                 .classId
        //                                                                 .value;
        //                                                             final mainDepId =
        //                                                                 itemId;
        //
        //                                                             final isInMySections = controller
        //                                                                 .mysection
        //                                                                 .any(
        //                                                                     (section) {
        //                                                               final departments =
        //                                                                   section
        //                                                                       as Map;
        //                                                               if (departments['app_classes_lessons_main_department'] !=
        //                                                                       null &&
        //                                                                   (departments['app_classes_lessons_main_department'] as List).isNotEmpty &&
        //                                                                   allSectionItem['app_classes_lessons_main_dep'] != null &&
        //                                                                   (allSectionItem['app_classes_lessons_main_dep'] as List).isNotEmpty) {
        //                                                                 return departments['app_classes_lessons_main_department'][0]['main_dep_id'].toString() == allSectionItem['app_classes_lessons_main_dep'][0]['main_dep_id'].toString() &&
        //                                                                     departments['app_classes_lessons_main_department'][0]['app_teacher_id'].toString() == allSectionItem['app_classes_lessons_main_dep'][0]['app_teacher_id'].toString() &&
        //                                                                     departments['app_classes_lessons_main_department'][0]['app_class_id'].toString() == allSectionItem['app_classes_lessons_main_dep'][0]['app_class_id'].toString();
        //                                                               }
        //                                                               return false;
        //                                                             });
        //
        //                                                             if (isInMySections) {
        //                                                               return Icon(
        //                                                                 Icons
        //                                                                     .check_circle,
        //                                                                 color:
        //                                                                     AppColor.PrimaryColor,
        //                                                               );
        //                                                             }
        //                                                             if (isSectionFree) {
        //                                                               return Icon(
        //                                                                 Icons
        //                                                                     .arrow_back,
        //                                                                 color:
        //                                                                     AppColor.PrimaryColor,
        //                                                               );
        //                                                             }
        //
        //                                                             return IconButton(
        //                                                               onPressed:
        //                                                                   () {
        //                                                                 baskerc
        //                                                                     .updatemaindepId(itemId);
        //                                                                 baskerc
        //                                                                     .updateBasket(
        //                                                                   itemId,
        //                                                                   'main_dep',
        //                                                                   allSectionItem['name'],
        //                                                                   allSectionItem['app_classes_lessons_main_dep'] != null && (allSectionItem['app_classes_lessons_main_dep'] as List).isNotEmpty
        //                                                                       ? allSectionItem['app_classes_lessons_main_dep'][0]['main_price']
        //                                                                       : 0,
        //                                                                   baskerc.teacherName.toString(),
        //                                                                   baskerc.className.toString(),
        //                                                                   baskerc.subjectName.toString(),
        //                                                                   teacherId,
        //                                                                   classId,
        //                                                                   subjectId,
        //                                                                   mainDepId,
        //                                                                 );
        //                                                               },
        //                                                               icon:
        //                                                                   Icon(
        //                                                                 Icons
        //                                                                     .shopping_cart_rounded,
        //                                                                 color:
        //                                                                     AppColor.PrimaryColor,
        //                                                               ),
        //                                                             );
        //                                                           }),
        //
        //                                                         ],
        //                                                       ),
        //                                                     ),
        //                                                   )
        //                                                 : Container(
        //                                                     decoration:
        //                                                         BoxDecoration(
        //                                                       color: Colors
        //                                                           .white,
        //                                                       borderRadius:
        //                                                           BorderRadius
        //                                                               .circular(
        //                                                         10,
        //                                                       ),
        //                                                     ),
        //                                                     width:
        //                                                         getValueForScreenType<
        //                                                             double>(
        //                                                       context:
        //                                                           context,
        //                                                       mobile: 140,
        //                                                       tablet: 170,
        //                                                     ),
        //                                                     height:
        //                                                         getValueForScreenType<
        //                                                             double>(
        //                                                       context:
        //                                                           context,
        //                                                       mobile: 35,
        //                                                       tablet: 45,
        //                                                     ),
        //                                                     child: Center(
        //                                                         child: Row(
        //                                                             mainAxisAlignment:
        //                                                                 MainAxisAlignment
        //                                                                     .spaceAround,
        //                                                             children: [
        //                                                           Text(
        //                                                             " الملف الشخصي",
        //                                                             style: TextStyle(
        //                                                                 fontWeight: FontWeight.bold,
        //                                                                 fontSize: getValueForScreenType<double>(
        //                                                                   context:
        //                                                                       context,
        //                                                                   mobile:
        //                                                                       15,
        //                                                                   tablet:
        //                                                                       17,
        //                                                                 ),
        //                                                                 color: AppColor.PrimaryColor),
        //                                                           )
        //                                                         ])))
        //                                           ],
        //                                         ),
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           );
        //                         },
        //                       )),
        //                 )
        //               : Center(child: Text("لا يوجد "))
        //           : Center(child: Loading())),
        // ),
        body: Column(
          children: [
            const BreadcrumbWidget(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: GetBuilder<SectionSelectedController>(
                  builder: (controller) => controller.isLoadingtow
                      ? controller.dataList.isNotEmpty
                            ? AnimationLimiter(
                                child: GlowingOverscrollIndicator(
                                  axisDirection: AxisDirection.down,
                                  color: AppColor.SecondryColor,
                                  child: ListView.separated(
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 10),
                                    itemCount: controller.dataList.length,
                                    itemBuilder: (context, index) {
                                      final item = controller.dataList[index];
                                      print(
                                        'sssssssssssssssssssssss${controller.dataList[index]}',
                                      );
                                      final isSectionFree =
                                          item['type'].toString() == '4';
                                      final itemId = item['id'].toString();

                                      return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        child: SlideAnimation(
                                          horizontalOffset: 200.0,
                                          curve: Curves.ease,
                                          duration: const Duration(
                                            milliseconds: 600,
                                          ),
                                          child: FadeInAnimation(
                                            child: Card(
                                              elevation: 6,

                                              shadowColor:
                                                  AppColor.PrimaryColor,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onTap: () {
                                                  baskerc.updatemaindepId(
                                                    itemId,
                                                  );
                                                  controller.goToSections(
                                                    itemId,
                                                    Get.arguments['subjetcsid']
                                                        .toString(),
                                                    Get.arguments['teacher_id']
                                                        .toString(),
                                                    item['type'].toString(),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 10,
                                                        ),
                                                    leading: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      child:
                                                          item['image'] !=
                                                                  null &&
                                                              item['image'] !=
                                                                  "-" &&
                                                              item['image']
                                                                  .toString()
                                                                  .isNotEmpty
                                                          ? CachedNetworkImage(
                                                              imageUrl:
                                                                  AppLink
                                                                      .image +
                                                                  "/" +
                                                                  item['image'],
                                                              width: 70,
                                                              height: 70,
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  (
                                                                    context,
                                                                    url,
                                                                  ) =>
                                                                      LoadingImage(),
                                                              errorWidget:
                                                                  (
                                                                    context,
                                                                    url,
                                                                    error,
                                                                  ) => Container(
                                                                    color: Colors
                                                                        .grey[200],
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Icon(
                                                                      Icons
                                                                          .image_not_supported,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                            )
                                                          : Container(
                                                              width: 70,
                                                              height: 70,
                                                              color: Colors
                                                                  .grey[200],
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Icon(
                                                                Icons
                                                                    .image_not_supported,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                    ),
                                                    title: Text(
                                                      item['name'] ?? '',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            getValueForScreenType<
                                                              double
                                                            >(
                                                              context: context,
                                                              mobile: 15,
                                                              tablet: 18,
                                                            ),
                                                        color: AppColor
                                                            .PrimaryColor,
                                                      ),
                                                    ),
                                                    subtitle: itemId != '5'
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 6,
                                                                ),
                                                            child: Text(
                                                              item['app_classes_lessons_main_dep'] !=
                                                                          null &&
                                                                      (item['app_classes_lessons_main_dep']
                                                                              as List)
                                                                          .isNotEmpty
                                                                  ? "السعر: ${item['app_classes_lessons_main_dep'][0]['main_price']?.toString() ?? '0'}"
                                                                  : isSectionFree
                                                                  ? 'استعراض مجاني'
                                                                  : 'السعر: 0',
                                                              style: TextStyle(
                                                                color: AppColor
                                                                    .DeepPurple,
                                                                fontSize:
                                                                    getValueForScreenType<
                                                                      double
                                                                    >(
                                                                      context:
                                                                          context,
                                                                      mobile:
                                                                          13,
                                                                      tablet:
                                                                          15,
                                                                    ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox.shrink(),
                                                    trailing: itemId != '5'
                                                        ? Obx(() {
                                                            final allSectionItem =
                                                                item;
                                                            final teacherId =
                                                                baskerc
                                                                    .teacherId
                                                                    .value;
                                                            final subjectId =
                                                                baskerc
                                                                    .subjectId
                                                                    .value;
                                                            final classId =
                                                                baskerc
                                                                    .classId
                                                                    .value;
                                                            final mainDepId =
                                                                itemId;

                                                            // نتحقق من أن القسم موجود في mysection
                                                            // نطابق بناءً على ID
                                                            final isInMySections = controller.mysection.any((
                                                              section,
                                                            ) {
                                                              final departments =
                                                                  section
                                                                      as Map;
                                                              final purchasedId =
                                                                  departments['id']
                                                                      ?.toString();
                                                              final currentId =
                                                                  allSectionItem['id']
                                                                      ?.toString();
                                                              return purchasedId ==
                                                                  currentId;
                                                            });

                                                            if (isInMySections) {
                                                              return Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: AppColor
                                                                    .SecondryColor,
                                                              );
                                                            }

                                                            if (isSectionFree) {
                                                              return Icon(
                                                                Icons
                                                                    .arrow_back,
                                                                color: AppColor
                                                                    .SecondryColor,
                                                              );
                                                            }

                                                            return AnimatedCartIcon(
                                                              targetCartKey:
                                                                  CartAnimationKeys
                                                                      .sectionSelected,
                                                              color: AppColor
                                                                  .PrimaryColor,
                                                              onPressed: () async {
                                                                baskerc
                                                                    .updatemaindepId(
                                                                      itemId,
                                                                    );
                                                                return await baskerc.updateBasket(
                                                                  itemId,
                                                                  'main_dep',
                                                                  allSectionItem['name'],
                                                                  allSectionItem['app_classes_lessons_main_dep'] !=
                                                                              null &&
                                                                          (allSectionItem['app_classes_lessons_main_dep']
                                                                                  as List)
                                                                              .isNotEmpty
                                                                      ? allSectionItem['app_classes_lessons_main_dep'][0]['main_price']
                                                                      : 0,
                                                                  baskerc
                                                                      .teacherName
                                                                      .toString(),
                                                                  baskerc
                                                                      .className
                                                                      .toString(),
                                                                  baskerc
                                                                      .subjectName
                                                                      .toString(),
                                                                  teacherId,
                                                                  classId,
                                                                  subjectId,
                                                                  mainDepId,
                                                                  baskerc
                                                                      .instituteId
                                                                      .toString(),
                                                                );
                                                              },
                                                            );
                                                          })
                                                        : Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5,
                                                                ),
                                                            child: Text(
                                                              "الملف الشخصي",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    getValueForScreenType<
                                                                      double
                                                                    >(
                                                                      context:
                                                                          context,
                                                                      mobile:
                                                                          14,
                                                                      tablet:
                                                                          16,
                                                                    ),
                                                                color: AppColor
                                                                    .PrimaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : const Center(child: Text("لا يوجد"))
                      : const Center(child: Loading()),
                ),
              ),
            ),
          ],
        ),

        floatingActionButton: SizedBox(
          width: getValueForScreenType<double>(
            context: context,
            mobile: 56,
            tablet: 80,
          ),
          height: getValueForScreenType<double>(
            context: context,
            mobile: 56,
            tablet: 80,
          ),
          child: BasketWidget(
            heroTag: "nine",
            customKey: CartAnimationKeys.sectionSelected,
          ),
        ),
      ),
    );
  }
}
