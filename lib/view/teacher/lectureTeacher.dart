import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/teacherController/lectureTeacherController.dart';
import '../../controller/teacherController/leesondespController.dart';
import '../../core/constant/color.dart';
import '../../linkapi.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/custombuttonbuy.dart';
import '../widget/customcard.dart';
import '../widget/customcardsections.dart';
import '../widget/loading.dart';

class LecutreTeacher extends GetView<TeacherLectureDespsContrlloer> {
  const LecutreTeacher({super.key});

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
        //       "الدروس",
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
            elevation: 0,
            backgroundColor: AppColor.PrimaryColor,
            title: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: AppColor.SecondryColor,
              child: Text(
                "الدروس",
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
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AnimationLimiter(
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: AppColor.SecondryColor,
              child: Obx(
                () => controller.isloded.value
                    ? controller.dataList.isNotEmpty
                          ? ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => SizedBox(
                                height: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 12,
                                  tablet: 25,
                                ),
                              ),
                              itemCount: controller.dataList.length,
                              itemBuilder: (context, index) {
                                final item = controller.dataList[index];
                                final name = item['name'] ?? '';
                                final image = item['image'];

                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    horizontalOffset: 200.0,
                                    curve: Curves.ease,
                                    duration: const Duration(milliseconds: 600),
                                    child: FadeInAnimation(
                                      child: Card(
                                        elevation: 6,
                                        shadowColor: AppColor.PrimaryColor,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,

                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    AppColor
                                                        .PrimaryColor.withOpacity(
                                                      0.3,
                                                    ),
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal:
                                                      getValueForScreenType<
                                                        double
                                                      >(
                                                        context: context,
                                                        mobile: 12,
                                                        tablet: 25,
                                                      ),
                                                  vertical:
                                                      getValueForScreenType<
                                                        double
                                                      >(
                                                        context: context,
                                                        mobile: 8,
                                                        tablet: 15,
                                                      ),
                                                ),
                                            onTap: () {
                                              Get.toNamed(
                                                '/videoLessonTeacher',
                                                arguments: {
                                                  'id': item['id'].toString(),
                                                  'name': name,
                                                },
                                              );
                                            },
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: image != null
                                                  ? CachedNetworkImage(
                                                      width:
                                                          getValueForScreenType<
                                                            double
                                                          >(
                                                            context: context,
                                                            mobile: 60,
                                                            tablet: 100,
                                                          ),
                                                      height:
                                                          getValueForScreenType<
                                                            double
                                                          >(
                                                            context: context,
                                                            mobile: 60,
                                                            tablet: 100,
                                                          ),
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "${AppLink.image}/$image",
                                                      placeholder:
                                                          (context, url) =>
                                                              LoadingImage(),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) => const Icon(
                                                            Icons.error,
                                                          ),
                                                    )
                                                  : Image.asset(
                                                      'assets/images/im4.png',
                                                      width:
                                                          getValueForScreenType<
                                                            double
                                                          >(
                                                            context: context,
                                                            mobile: 60,
                                                            tablet: 100,
                                                          ),
                                                      height:
                                                          getValueForScreenType<
                                                            double
                                                          >(
                                                            context: context,
                                                            mobile: 60,
                                                            tablet: 100,
                                                          ),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            title: Text(
                                              name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 15,
                                                      tablet: 20,
                                                    ),
                                                color: AppColor.PrimaryColor,
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5.0,
                                              ),
                                              child: Text(
                                                "اضغط لعرض تفاصيل الدرس",
                                                style: TextStyle(
                                                  color: AppColor.grey,
                                                  fontSize:
                                                      getValueForScreenType<
                                                        double
                                                      >(
                                                        context: context,
                                                        mobile: 12,
                                                        tablet: 16,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: AppColor.SecondryColor,
                                              size:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 18,
                                                    tablet: 25,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(child: Text("لا يوجد دروس"))
                    : const Loading(),
              ),
            ),
          ),
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.all(12.0),
      //   child: AnimationLimiter(
      //     child: GlowingOverscrollIndicator(
      //       axisDirection: AxisDirection.down,
      //       color: AppColor.SecondryColor,
      //       child: Obx(() => controller.isloded.value
      //           ? controller.dataList.isNotEmpty
      //               ? GridView.builder(
      //                   gridDelegate:
      //                       SliverGridDelegateWithMaxCrossAxisExtent(
      //                     maxCrossAxisExtent: getValueForScreenType<double>(
      //                       context: context,
      //                       mobile: 300,
      //                       tablet: 600,
      //                     ),
      //                     childAspectRatio: getValueForScreenType<double>(
      //                       context: context,
      //                       mobile: 8 / 8,
      //                       tablet: 8 / 5,
      //                     ),
      //                     crossAxisSpacing: getValueForScreenType<double>(
      //                       context: context,
      //                       mobile: 7,
      //                       tablet: 10,
      //                     ),
      //                     mainAxisSpacing: getValueForScreenType<double>(
      //                       context: context,
      //                       mobile: 15,
      //                       tablet: 30,
      //                     ),
      //                   ),
      //                   scrollDirection: Axis.vertical,
      //                   shrinkWrap: false,
      //                   itemCount: controller.dataList.length,
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
      //                             shape: RoundedRectangleBorder(
      //                                 borderRadius:
      //                                     BorderRadius.circular(25)),
      //                             color: AppColor.BackGround,
      //                             child: Container(
      //                               decoration: BoxDecoration(
      //                                 color:
      //                                     AppColor.DeepPurple.withOpacity(
      //                                         0.5),
      //                                 borderRadius:
      //                                     BorderRadius.circular(15),
      //                                 boxShadow: [
      //                                   BoxShadow(
      //                                     color: AppColor.PrimaryColor
      //                                         .withOpacity(0.5),
      //                                     blurRadius: 2,
      //                                     spreadRadius: 2,
      //                                   ),
      //                                 ],
      //                               ),
      //                               padding: EdgeInsets.all(
      //                                 getValueForScreenType<double>(
      //                                   context: context,
      //                                   mobile: 1,
      //                                   tablet: 1,
      //                                 ),
      //                               ),
      //                               child: InkWell(
      //                                 onTap: () {
      //                                   print('videoLessonTeacher');
      //                                   Get.toNamed('/videoLessonTeacher',
      //                                       arguments: {
      //                                         'id': controller
      //                                             .dataList[index]['id']
      //                                             .toString(),
      //                                         'name': controller
      //                                             .dataList[index]['name']
      //                                       });
      //                                 },
      //                                 child: Container(
      //                                   decoration: BoxDecoration(
      //                                     color: AppColor.BackGround,
      //                                     borderRadius:
      //                                         BorderRadius.circular(10),
      //                                   ),
      //                                   child: Column(
      //                                     mainAxisAlignment:
      //                                         MainAxisAlignment.spaceAround,
      //                                     children: [
      //                                       SizedBox(
      //                                           height:
      //                                               getValueForScreenType<
      //                                                   double>(
      //                                             context: context,
      //                                             mobile: 100,
      //                                             tablet: 80,
      //                                           ),
      //                                           width:
      //                                               getValueForScreenType<
      //                                                   double>(
      //                                             context: context,
      //                                             mobile: 150,
      //                                             tablet: 150,
      //                                           ),
      //                                           child: controller.dataList[
      //                                                           index]
      //                                                       ['image'] !=
      //                                                   null
      //                                               ? CachedNetworkImage(
      //                                                   width:
      //                                                       getValueForScreenType<
      //                                                           double>(
      //                                                     context: context,
      //                                                     mobile:
      //                                                         Get.width *
      //                                                             0.22,
      //                                                     tablet:
      //                                                         Get.width *
      //                                                             0.30,
      //                                                   ),
      //                                                   height:
      //                                                       getValueForScreenType<
      //                                                           double>(
      //                                                     context: context,
      //                                                     mobile:
      //                                                         Get.height *
      //                                                             0.11,
      //                                                     tablet:
      //                                                         Get.height *
      //                                                             0.17,
      //                                                   ),
      //                                                   fit: BoxFit.fill,
      //                                                   imageUrl: AppLink
      //                                                           .image +
      //                                                       "/" +
      //                                                       controller.dataList[
      //                                                               index]
      //                                                           ['image'],
      //                                                   placeholder: (context,
      //                                                           url) =>
      //                                                       LoadingImage(),
      //                                                   errorWidget:
      //                                                       (context, url,
      //                                                               error) =>
      //                                                           Icon(Icons
      //                                                               .error),
      //                                                 )
      //                                               : Image.asset(
      //                                                   'assets/images/im4.png')),
      //                                       SizedBox(
      //                                         height: getValueForScreenType<
      //                                             double>(
      //                                           context: context,
      //                                           mobile: 10,
      //                                           tablet: 20,
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         width: getValueForScreenType<
      //                                             double>(
      //                                           context: context,
      //                                           mobile: 200,
      //                                           tablet: 300,
      //                                         ),
      //                                         height: getValueForScreenType<
      //                                             double>(
      //                                           context: context,
      //                                           mobile: 40,
      //                                           tablet: 55,
      //                                         ),
      //                                         child: Text(
      //                                           controller.dataList[index]
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
      //                                           maxLines: 1,
      //                                           overflow:
      //                                               TextOverflow.ellipsis,
      //                                           textAlign: TextAlign.center,
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
      //               : Center(child: Text("لا يوجد دروس"))
      //           : Loading()),
      //     ),
      //   ),
      // )),
    );
  }
}
