import 'package:daliluna_altaalimi/view/widget/customDrawer.dart';
import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:daliluna_altaalimi/view/teacher/teacherprofile.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/teacherController/appteahcerlessonController.dart';
import '../../controller/teacherController/loginTeacherController.dart';
import '../../core/constant/color.dart';
import '../../linkapi.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/customDrawerTeacher.dart';
import '../widget/customcard.dart';
import '../widget/loading.dart';
import 'lessonTeacher.dart';

class HomeTeacher extends StatelessWidget {
  TeacherLessonContrlloer controler = Get.put(TeacherLessonContrlloer());
  HomeTeacher({super.key});
  LoginControllerss loginControlle = Get.put(LoginControllerss());
  @override
  Widget build(BuildContext context) {
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
        //       "المواد",
        //       style: TextStyle(color: AppColor.White),
        //     ),
        //     actions: [
        //       IconButton(
        //           onPressed: () {
        //             Get.to(TeacherProfileWidget());
        //           },
        //           icon: Icon(Icons.person)),
        //       IconButton(
        //           onPressed: () {
        //             loginControlle.logoutTeacher();
        //           },
        //           icon: Icon(Icons.login))
        //     ],
        //     leading: Text(""),
        //   ),
        // ),
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
            backgroundColor: AppColor.PrimaryColor,
            title: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: AppColor.SecondryColor,
              child: Text(
                "المواد",
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
        drawer: customDrawerTeacher(context),
        // body: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: AnimationLimiter(
        //     child: GlowingOverscrollIndicator(
        //       axisDirection: AxisDirection.down,
        //       color: AppColor.SecondryColor,
        //       child: Obx(() => controler.isloded.value
        //           ? controler.dataList.isNotEmpty
        //               ? GridView.builder(
        //                   gridDelegate:
        //                       SliverGridDelegateWithMaxCrossAxisExtent(
        //                           maxCrossAxisExtent:
        //                               getValueForScreenType<double>(
        //                             context: context,
        //                             mobile: 300,
        //                             tablet: 600,
        //                           ),
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
        //                           mainAxisExtent: 270),
        //                   scrollDirection: Axis.vertical,
        //                   shrinkWrap: false,
        //                   itemCount: controler.dataList.length,
        //                   itemBuilder: (BuildContext context, int index) {
        //                     return AnimationConfiguration.staggeredList(
        //                       position: index,
        //                       duration: const Duration(milliseconds: 500),
        //                       child: SlideAnimation(
        //                         horizontalOffset: 200.0,
        //                         curve: Curves.ease,
        //                         duration: const Duration(milliseconds: 600),
        //                         child: FadeInAnimation(
        //                           child: Card(
        //                             elevation: 5,
        //                             shadowColor: AppColor.SecondryColor,
        //                             color: AppColor.BackGround,
        //                             child: Container(
        //                               padding: EdgeInsets.all(
        //                                 getValueForScreenType<double>(
        //                                   context: context,
        //                                   mobile: 10,
        //                                   tablet: 20,
        //                                 ),
        //                               ),
        //                               child: InkWell(
        //                                 onTap: () {
        //                                   print(controler.dataList[index]
        //                                           ['id']
        //                                       .toString());
        //                                 },
        //                                 child: Container(
        //                                   decoration: BoxDecoration(
        //                                     color: AppColor.BackGround2,
        //                                   ),
        //                                   child: Column(
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.spaceAround,
        //                                     children: [
        //                                       CachedNetworkImage(
        //                                         width: getValueForScreenType<
        //                                             double>(
        //                                           context: context,
        //                                           mobile: Get.width * 0.22,
        //                                           tablet: Get.width * 0.30,
        //                                         ),
        //                                         height: getValueForScreenType<
        //                                             double>(
        //                                           context: context,
        //                                           mobile: Get.height * 0.11,
        //                                           tablet: Get.height * 0.17,
        //                                         ),
        //                                         fit: BoxFit.fill,
        //                                         imageUrl: AppLink.image +
        //                                             "/" +
        //                                             controler.dataList[index]
        //                                                 ['image'],
        //                                         placeholder: (context, url) =>
        //                                             LoadingImage(),
        //                                         errorWidget:
        //                                             (context, url, error) =>
        //                                                 Icon(Icons.error),
        //                                       ),
        //                                       SizedBox(
        //                                         height: getValueForScreenType<
        //                                             double>(
        //                                           context: context,
        //                                           mobile: 10,
        //                                           tablet: 20,
        //                                         ),
        //                                       ),
        //                                       Center(
        //                                         child: Center(
        //                                           child: Text(
        //                                             controler.dataList[index]
        //                                                 ['name'],
        //                                             style: TextStyle(
        //                                                 fontWeight:
        //                                                     FontWeight.bold,
        //                                                 fontSize:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 15,
        //                                                   tablet: 17,
        //                                                 ),
        //                                                 color: AppColor
        //                                                     .PrimaryColor),
        //                                             textAlign:
        //                                                 TextAlign.center,
        //                                             maxLines: 2,
        //                                             overflow:
        //                                                 TextOverflow.ellipsis,
        //                                           ),
        //                                         ),
        //                                       ),
        //                                       Row(
        //                                         mainAxisAlignment:
        //                                             MainAxisAlignment
        //                                                 .spaceAround,
        //                                         children: [
        //                                           InkWell(
        //                                             onTap: () {
        //                                               Get.toNamed(
        //                                                   '/unitTeacher',
        //                                                   arguments: {
        //                                                     'id': controler
        //                                                         .dataList[
        //                                                             index]
        //                                                             ['id']
        //                                                         .toString()
        //                                                   });
        //                                             },
        //                                             child: Container(
        //                                               decoration: BoxDecoration(
        //                                                   color: AppColor
        //                                                       .DeepPurple,
        //                                                   borderRadius:
        //                                                       BorderRadius
        //                                                           .circular(
        //                                                               10)),
        //                                               height:
        //                                                   getValueForScreenType<
        //                                                       double>(
        //                                                 context: context,
        //                                                 mobile: 40,
        //                                                 tablet: 40,
        //                                               ),
        //                                               width:
        //                                                   getValueForScreenType<
        //                                                       double>(
        //                                                 context: context,
        //                                                 mobile: MediaQuery.of(
        //                                                             context)
        //                                                         .size
        //                                                         .width *
        //                                                     0.18,
        //                                                 tablet: 70,
        //                                               ),
        //                                               child: Center(
        //                                                   child: Text(
        //                                                 "الوحدات",
        //                                                 style: TextStyle(
        //                                                     color: AppColor
        //                                                         .BackGround2,
        //                                                     fontSize: 15),
        //                                               )),
        //                                             ),
        //                                           ),
        //                                           InkWell(
        //                                             onTap: () {
        //                                               Get.toNamed(
        //                                                   '/lessonTeacher',
        //                                                   arguments: {
        //                                                     'id': controler
        //                                                         .dataList[
        //                                                             index]
        //                                                             ['id']
        //                                                         .toString()
        //                                                   });
        //                                             },
        //                                             child: Container(
        //                                               decoration: BoxDecoration(
        //                                                   color: AppColor
        //                                                       .DeepPurple,
        //                                                   borderRadius:
        //                                                       BorderRadius
        //                                                           .circular(
        //                                                               10)),
        //                                               height:
        //                                                   getValueForScreenType<
        //                                                       double>(
        //                                                 context: context,
        //                                                 mobile: 40,
        //                                                 tablet: 40,
        //                                               ),
        //                                               width:
        //                                                   getValueForScreenType<
        //                                                       double>(
        //                                                 context: context,
        //                                                 mobile: MediaQuery.of(
        //                                                             context)
        //                                                         .size
        //                                                         .width *
        //                                                     0.18,
        //                                                 tablet: 70,
        //                                               ),
        //                                               child: Center(
        //                                                   child: Text(
        //                                                 "الأقسام",
        //                                                 style: TextStyle(
        //                                                     color: AppColor
        //                                                         .BackGround2,
        //                                                     fontSize: 15),
        //                                               )),
        //                                             ),
        //                                           ),
        //                                         ],
        //                                       )
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                 )
        //               : Center(child: Text("لا يوجد مواد"))
        //           : Loading()),
        //     ),
        //   ),
        // )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimationLimiter(
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: AppColor.SecondryColor,
              child: Obx(
                () => controler.isloded.value
                    ? controler.dataList.isNotEmpty
                          ? ListView.builder(
                              itemCount: controler.dataList.length,
                              itemBuilder: (context, index) {
                                final item = controler.dataList[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    horizontalOffset: 200.0,
                                    curve: Curves.ease,
                                    duration: const Duration(milliseconds: 600),
                                    child: FadeInAnimation(
                                      child: Card(
                                        elevation: 5,
                                        shadowColor: AppColor.PrimaryColor,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          vertical:
                                              getValueForScreenType<double>(
                                                context: context,
                                                mobile: 8,
                                                tablet: 12,
                                              ),
                                          horizontal:
                                              getValueForScreenType<double>(
                                                context: context,
                                                mobile: 5,
                                                tablet: 10,
                                              ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            getValueForScreenType<double>(
                                              context: context,
                                              mobile: 10,
                                              tablet: 20,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // الصورة
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  AppLink.image +
                                                      "/" +
                                                      item['image'],
                                                  width:
                                                      getValueForScreenType<
                                                        double
                                                      >(
                                                        context: context,
                                                        mobile: 70,
                                                        tablet: 100,
                                                      ),
                                                  height:
                                                      getValueForScreenType<
                                                        double
                                                      >(
                                                        context: context,
                                                        mobile: 70,
                                                        tablet: 100,
                                                      ),
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Icon(Icons.error),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              // الاسم
                                              Expanded(
                                                child: Text(
                                                  item['name'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        getValueForScreenType<
                                                          double
                                                        >(
                                                          context: context,
                                                          mobile: 20,
                                                          tablet: 28,
                                                        ),
                                                    color:
                                                        AppColor.PrimaryColor,
                                                  ),
                                                ),
                                              ),
                                              // الأزرار عمودياً
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Get.toNamed(
                                                        '/unitTeacher',
                                                        arguments: {
                                                          'id': item['id']
                                                              .toString(),
                                                        },
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColor
                                                          .SecondryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 15,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "الوحدات",
                                                      style: TextStyle(
                                                        color: AppColor
                                                            .BackGround2,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Get.toNamed(
                                                        '/lessonTeacher',
                                                        arguments: {
                                                          'id': item['id']
                                                              .toString(),
                                                        },
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColor
                                                          .SecondryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 15,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "الأقسام",
                                                      style: TextStyle(
                                                        color: AppColor
                                                            .BackGround2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(child: Text("لا يوجد مواد"))
                    : Loading(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
