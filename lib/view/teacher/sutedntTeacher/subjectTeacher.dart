import 'package:daliluna_altaalimi/view/widget/customDrawerTeacher.dart';
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

import '../../../controller/teacherController/appteahcerlessonController.dart';
import '../../../core/constant/color.dart';
import '../../../linkapi.dart';
import '../../widget/GetValueForScreen.dart';
import '../../widget/loading.dart';

class SubjectTeacher extends StatelessWidget {
  TeacherLessonContrlloer controler = Get.put(TeacherLessonContrlloer());
  SubjectTeacher({super.key});
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
        //       "مشتريات الطلاب",
        //       style: TextStyle(color: AppColor.White),
        //     ),
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
                "مشتريات الطلاب",
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
        // body: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: AnimationLimiter(
        //     child: GlowingOverscrollIndicator(
        //       axisDirection: AxisDirection.down,
        //       color: AppColor.SecondryColor,
        //       child: Obx(() => controler.isloded.value
        //           ? controler.dataList.isNotEmpty
        //               ? ListView.builder(
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
        //                                   child: Row(
        //                                     // mainAxisAlignment:
        //                                     //     MainAxisAlignment.start,
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
        //                                         width: 8,
        //                                       ),
        //                                       Expanded(
        //                                         child: Text(
        //                                           controler.dataList[index]
        //                                               ['name'],
        //                                           style: TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                               fontSize:
        //                                                   getValueForScreenType<
        //                                                       double>(
        //                                                 context: context,
        //                                                 mobile: 15,
        //                                                 tablet: 17,
        //                                               ),
        //                                               color: AppColor
        //                                                   .PrimaryColor),
        //                                           maxLines: 2,
        //                                           overflow:
        //                                               TextOverflow.ellipsis,
        //                                         ),
        //                                       ),
        //                                       Padding(
        //                                         padding:
        //                                             const EdgeInsets.all(8.0),
        //                                         child: InkWell(
        //                                           onTap: () {
        //                                             Get.toNamed(
        //                                                 '/listStudentForTeacher',
        //                                                 arguments: {
        //                                                   'id': controler
        //                                                       .dataList[index]
        //                                                           ['id']
        //                                                       .toString()
        //                                                 });
        //                                           },
        //                                           child: Container(
        //                                             decoration: BoxDecoration(
        //                                                 color: AppColor
        //                                                     .DeepPurple,
        //                                                 borderRadius:
        //                                                     BorderRadius
        //                                                         .circular(
        //                                                             10)),
        //                                             height:
        //                                                 getValueForScreenType<
        //                                                     double>(
        //                                               context: context,
        //                                               mobile: 40,
        //                                               tablet: 45,
        //                                             ),
        //                                             width:
        //                                                 getValueForScreenType<
        //                                                     double>(
        //                                               context: context,
        //                                               mobile: 75,
        //                                               tablet: 75,
        //                                             ),
        //                                             child: Center(
        //                                                 child: Text(
        //                                               "الطلاب",
        //                                               style: TextStyle(
        //                                                   color: AppColor
        //                                                       .BackGround2,
        //                                                   fontSize: 15),
        //                                             )),
        //                                           ),
        //                                         ),
        //                                       ),
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
        // )
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimationLimiter(
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Colors.white,
              child: Obx(
                () => controler.isloded.value
                    ? controler.dataList.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: controler.dataList.length,
                              itemBuilder: (BuildContext context, int index) {
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
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 4,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(
                                            getValueForScreenType<double>(
                                              context: context,
                                              mobile: 10,
                                              tablet: 20,
                                            ),
                                          ),
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: CachedNetworkImage(
                                              width:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 70,
                                                    tablet: 100,
                                                  ),
                                              height:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 70,
                                                    tablet: 100,
                                                  ),
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  AppLink.image +
                                                  "/" +
                                                  item['image'],
                                              placeholder: (context, url) =>
                                                  LoadingImage(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                            ),
                                          ),
                                          title: Text(
                                            item['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 15,
                                                    tablet: 17,
                                                  ),
                                              color: AppColor.PrimaryColor,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: ElevatedButton.icon(
                                            onPressed: () {
                                              Get.toNamed(
                                                '/listStudentForTeacher',
                                                arguments: {
                                                  'id': item['id'].toString(),
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColor.SecondryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 10,
                                                      tablet: 12,
                                                    ),
                                                horizontal:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 12,
                                                      tablet: 16,
                                                    ),
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.group,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              "الطلاب",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(child: Text("لا يوجد مواد"))
                    : Loading(),
              ),
            ),
          ),
        ),
        drawer: customDrawerTeacher(context),
      ),
    );
  }
}
