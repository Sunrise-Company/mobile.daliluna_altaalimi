import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/auth/login_controller.dart';
import '../../../controller/exam/mainEamController.dart';
import '../../../core/constant/color.dart';
import '../../../core/constant/imageasset.dart';
import '../../widget/GetValueForScreen.dart';
import '../../widget/customDrawer.dart';
import '../../widget/loading.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';

class QuizScreen extends StatelessWidget {
  MainExamControllerss controller = Get.put(MainExamControllerss());
  QuizScreen({super.key});
  LoginController logincontroller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: customDrawer(context),
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
                "الامتحانات",
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
        //       "الامتحانات",
        //       style: TextStyle(color: AppColor.White),
        //     ),
        //   ),
        // ),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.4,
              child: Image.asset(
                height: double.infinity,
                width: double.infinity,
                AppImageAsset.backgroundExam,
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.all(20.0),
            //     child: Obx(() => logincontroller.isLoginsuccess == true
            //         ? controller.isloded.value
            //         ? controller.dataListExam.value.isNotEmpty
            //         ? AnimationLimiter(
            //         child: GlowingOverscrollIndicator(
            //           axisDirection: AxisDirection.down,
            //           color: Color.fromARGB(255, 214, 208, 189),
            //           child: ListView.separated(
            //             itemCount: controller.dataListExam.length,
            //             separatorBuilder: (context, index) => SizedBox(
            //               height: getValueForScreenType<double>(
            //                 context: context,
            //                 mobile: 30,
            //                 tablet: 50,
            //               ),
            //             ),
            //             itemBuilder: (context, courseIndex) {
            //               print(controller.dataListExam.length);
            //
            //               final course =
            //               controller.dataListExam[courseIndex];
            //               return AnimationConfiguration.staggeredList(
            //                   position: courseIndex,
            //                   duration: const Duration(milliseconds: 500),
            //                   child: SlideAnimation(
            //                       horizontalOffset: 150.0,
            //                       curve: Curves.decelerate,
            //                       duration:
            //                       const Duration(milliseconds: 700),
            //                       child: FadeInAnimation(
            //                           child: Padding(
            //                             padding: const EdgeInsets.all(0.0),
            //                             child: InkWell(
            //                               onTap: () {},
            //                               child: Container(
            //                                 width: double.infinity,
            //                                 decoration: BoxDecoration(
            //                                     border: Border.all(
            //                                       color: Color.fromARGB(
            //                                           255, 178, 139, 218),
            //                                       width:
            //                                       getValueForScreenType<
            //                                           double>(
            //                                         context: context,
            //                                         mobile: 1,
            //                                         tablet: 2,
            //                                       ),
            //                                     ),
            //                                     borderRadius:
            //                                     BorderRadius.circular(20),
            //                                     gradient: LinearGradient(
            //                                       begin: Alignment.topRight,
            //                                       end: Alignment.topCenter,
            //                                       colors: <Color>[
            //                                         Color.fromARGB(
            //                                             255, 238, 238, 238),
            //                                         AppColor.BackGround
            //                                       ],
            //                                     )),
            //                                 child: Column(
            //                                   mainAxisAlignment:
            //                                   MainAxisAlignment.center,
            //                                   children: [
            //                                     SizedBox(
            //                                       height: 20,
            //                                     ),
            //                                     Row(
            //                                       textDirection:
            //                                       TextDirection.rtl,
            //                                       mainAxisAlignment:
            //                                       MainAxisAlignment
            //                                           .center,
            //                                       children: [
            //                                         Flexible(
            //                                           child: Text(
            //                                             "  ${course['name']} ",
            //                                             style: TextStyle(
            //                                                 fontSize:
            //                                                 getValueForScreenType<
            //                                                     double>(
            //                                                   context:
            //                                                   context,
            //                                                   mobile: 17,
            //                                                   tablet: 20,
            //                                                 ),
            //                                                 fontWeight:
            //                                                 FontWeight
            //                                                     .bold),
            //                                           ),
            //                                         ),
            //                                       ],
            //                                     ),
            //                                     SizedBox(
            //                                       height: 10,
            //                                     ),
            //                                     Row(
            //                                       textDirection:
            //                                       TextDirection.rtl,
            //                                       mainAxisAlignment:
            //                                       MainAxisAlignment
            //                                           .center,
            //                                       children: [
            //                                         Flexible(
            //                                           child: Text(
            //                                             "  ${course['lesson']['name']} ",
            //                                             style: TextStyle(
            //                                                 fontSize:
            //                                                 getValueForScreenType<
            //                                                     double>(
            //                                                   context:
            //                                                   context,
            //                                                   mobile: 17,
            //                                                   tablet: 20,
            //                                                 ),
            //                                                 fontWeight:
            //                                                 FontWeight
            //                                                     .normal),
            //                                           ),
            //                                         ),
            //                                       ],
            //                                     ),
            //                                     SizedBox(
            //                                       height: 10,
            //                                     ),
            //                                     controller.dataListExam[
            //                                     courseIndex]
            //                                     ['result'] ==
            //                                         '-1' ||
            //                                         controller.dataListExam[
            //                                         courseIndex]
            //                                         ['result'] ==
            //                                             '-9'
            //                                         ? SizedBox()
            //                                         : Container(
            //                                       height: 45,
            //                                       width: MediaQuery.of(
            //                                           context)
            //                                           .size
            //                                           .width *
            //                                           0.3,
            //                                       decoration: BoxDecoration(
            //                                           color: AppColor
            //                                               .BackGround2,
            //                                           borderRadius:
            //                                           BorderRadius
            //                                               .circular(
            //                                               15)),
            //                                       child: Center(
            //                                         child: Text(
            //                                           course['result'] +
            //                                               ' / ' +
            //                                               course['mark']
            //                                                   .toString(),
            //                                           style: TextStyle(
            //                                             fontSize: 17,
            //                                             fontWeight:
            //                                             FontWeight
            //                                                 .normal,
            //                                             color: Color
            //                                                 .fromARGB(
            //                                                 255,
            //                                                 102,
            //                                                 98,
            //                                                 98),
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     SizedBox(
            //                                       height: 5,
            //                                     ),
            //                                     if (course['start_exam'] == 0)
            //                                       ElevatedButton(
            //                                         onPressed: () {},
            //                                         style: ElevatedButton
            //                                             .styleFrom(
            //                                           foregroundColor:
            //                                           Colors.white,
            //                                           backgroundColor:
            //                                           AppColor
            //                                               .BackGround2,
            //                                           shape:
            //                                           RoundedRectangleBorder(
            //                                             borderRadius:
            //                                             BorderRadius
            //                                                 .circular(10),
            //                                           ),
            //                                         ),
            //                                         child: Text(
            //                                           "انتهى",
            //                                           style: TextStyle(
            //                                             fontSize: 16,
            //                                             fontWeight:
            //                                             FontWeight.normal,
            //                                             color: AppColor
            //                                                 .DeepPurple,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     if (course['start_exam'] ==
            //                                         3 &&
            //                                         course['result'] == "-9")
            //                                       ElevatedButton(
            //                                         onPressed: () {
            //                                           print("معاينةةةةةةةةة");
            //                                           print(controller
            //                                               .dataListExam[
            //                                           courseIndex]['id']);
            //                                         },
            //                                         style: ElevatedButton
            //                                             .styleFrom(
            //                                           foregroundColor:
            //                                           Colors.white,
            //                                           backgroundColor:
            //                                           AppColor
            //                                               .BackGround2,
            //                                           shape:
            //                                           RoundedRectangleBorder(
            //                                             borderRadius:
            //                                             BorderRadius
            //                                                 .circular(10),
            //                                           ),
            //                                         ),
            //                                         child: Text(
            //                                           " الامتحان قيد التصحيح",
            //                                           style: TextStyle(
            //                                             fontSize: 16,
            //                                             fontWeight:
            //                                             FontWeight.normal,
            //                                             color: AppColor
            //                                                 .DeepPurple,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     if (course['start_exam'] ==
            //                                         1 &&
            //                                         course['is_file'] == 0)
            //                                       ElevatedButton(
            //                                         onPressed: () {
            //                                           print(
            //                                               "jjjjjjjjjjjjjjjdjjdjdj");
            //                                           print(controller
            //                                               .dataListExam[
            //                                           courseIndex]['id']);
            //                                           Get.toNamed(
            //                                             '/test',
            //                                             arguments: {
            //                                               "id": controller
            //                                                   .dataListExam[
            //                                               courseIndex]
            //                                               ['id']
            //                                                   .toString(),
            //                                             },
            //                                           );
            //                                         },
            //                                         style: ElevatedButton
            //                                             .styleFrom(
            //                                           foregroundColor:
            //                                           Colors.white,
            //                                           backgroundColor:
            //                                           AppColor
            //                                               .BackGround2,
            //                                           shape:
            //                                           RoundedRectangleBorder(
            //                                             borderRadius:
            //                                             BorderRadius
            //                                                 .circular(10),
            //                                           ),
            //                                         ),
            //                                         child: Text(
            //                                           "متاح",
            //                                           style: TextStyle(
            //                                             fontSize: 16,
            //                                             fontWeight:
            //                                             FontWeight.normal,
            //                                             color: AppColor
            //                                                 .DeepPurple,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     if (course['start_exam'] == 2)
            //                                       ElevatedButton(
            //                                         onPressed: () {},
            //                                         style: ElevatedButton
            //                                             .styleFrom(
            //                                           foregroundColor:
            //                                           Colors.white,
            //                                           backgroundColor:
            //                                           AppColor
            //                                               .BackGround2,
            //                                           shape:
            //                                           RoundedRectangleBorder(
            //                                             borderRadius:
            //                                             BorderRadius
            //                                                 .circular(10),
            //                                           ),
            //                                         ),
            //                                         child: Text(
            //                                           "لم يحين وقت الامتحان",
            //                                           style: TextStyle(
            //                                             fontSize: 17,
            //                                             fontWeight:
            //                                             FontWeight.normal,
            //                                             color: AppColor
            //                                                 .DeepPurple,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     if (course['start_exam'] ==
            //                                         3 &&
            //                                         course['result'] != "-9")
            //                                       ElevatedButton(
            //                                         onPressed: () {
            //                                           controller.goToSoltions(
            //                                               controller.dataListExam[
            //                                               courseIndex]
            //                                               ['id']);
            //
            //                                           print("معاينةةةةةةةةة");
            //                                         },
            //                                         style: ElevatedButton
            //                                             .styleFrom(
            //                                           foregroundColor:
            //                                           Colors.white,
            //                                           backgroundColor:
            //                                           AppColor
            //                                               .BackGround2,
            //                                           shape:
            //                                           RoundedRectangleBorder(
            //                                             borderRadius:
            //                                             BorderRadius
            //                                                 .circular(10),
            //                                           ),
            //                                         ),
            //                                         child: Text(
            //                                           "معاينة الامتحان",
            //                                           style: TextStyle(
            //                                             fontSize: 17,
            //                                             fontWeight:
            //                                             FontWeight.normal,
            //                                             color: AppColor
            //                                                 .DeepPurple,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     SizedBox(
            //                                       height: 10,
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ),
            //                             ),
            //                           ))));
            //             },
            //           ),
            //         ))
            //         : Center(child: Text("لا يوجد امتحانات"))
            //         : Loading()
            //         : Center(child: Text("لا يوجد امتحانات")))),
            GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: AppColor.SecondryColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Obx(
                  () => logincontroller.isLoginsuccess == true
                      ? controller.isloded.value
                            ? controller.dataListExam.isNotEmpty
                                  ? AnimationLimiter(
                                      child: ListView.separated(
                                        itemCount:
                                            controller.dataListExam.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 15),
                                        itemBuilder: (context, courseIndex) {
                                          final course = controller
                                              .dataListExam[courseIndex];

                                          // حالة الامتحان
                                          String statusText = "";
                                          Color statusColor = Colors.grey;
                                          VoidCallback? onPressed;

                                          if (course['start_exam'] == 0) {
                                            statusText = "انتهى";
                                            statusColor = Colors.grey;
                                          } else if (course['start_exam'] ==
                                                  1 &&
                                              course['is_file'] == 0) {
                                            statusText = "متاح";
                                            statusColor = Colors.green;
                                            onPressed = () {
                                              Get.toNamed(
                                                '/test',
                                                arguments: {
                                                  "id": course['id'].toString(),
                                                },
                                              );
                                            };
                                          } else if (course['start_exam'] ==
                                              2) {
                                            statusText = "لم يحين الوقت";
                                            statusColor = Colors.orange;
                                          } else if (course['start_exam'] ==
                                                  3 &&
                                              course['result'] == "-9") {
                                            statusText = "قيد التصحيح";
                                            statusColor = Colors.amber.shade700;
                                          } else if (course['start_exam'] ==
                                                  3 &&
                                              course['result'] != "-9") {
                                            statusText = "معاينة";
                                            statusColor = AppColor.DeepPurple;
                                            onPressed = () {
                                              controller.goToSoltions(
                                                course['id'],
                                              ); // المعاينة
                                            };
                                          }

                                          return AnimationConfiguration.staggeredList(
                                            position: courseIndex,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            child: SlideAnimation(
                                              horizontalOffset: 100.0,
                                              child: FadeInAnimation(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                  ),
                                                  shadowColor:
                                                      AppColor.PrimaryColor,
                                                  elevation: 3,
                                                  color: Colors.white,
                                                  child: ListTile(
                                                    onTap: onPressed,
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 12,
                                                        ),
                                                    leading: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: AppColor
                                                          .SecondryColor2,

                                                      child: const Icon(
                                                        Icons.assignment,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    title: Text(
                                                      course['name'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            getValueForScreenType<
                                                              double
                                                            >(
                                                              context: context,
                                                              mobile: 15,
                                                              tablet: 18,
                                                            ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColor
                                                            .PrimaryColor,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      course['lesson']['name'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            getValueForScreenType<
                                                              double
                                                            >(
                                                              context: context,
                                                              mobile: 13,
                                                              tablet: 16,
                                                            ),
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                    trailing: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 6,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: statusColor
                                                                .withOpacity(
                                                                  0.15,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            border: Border.all(
                                                              color: statusColor
                                                                  .withOpacity(
                                                                    0.4,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(
                                                                Icons.circle,
                                                                color:
                                                                    statusColor,
                                                                size: 10,
                                                              ),
                                                              const SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                statusText,
                                                                style: TextStyle(
                                                                  color:
                                                                      statusColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (course['result'] !=
                                                                "-1" &&
                                                            course['result'] !=
                                                                "-9")
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 1,
                                                                ),
                                                            child: Text(
                                                              "${course['result']} / ${course['mark']}",
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color: AppColor
                                                                    .DeepPurple,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const Center(
                                      child: Text("لا يوجد امتحانات"),
                                    )
                            : const Center(child: Loading())
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 80,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "عذراً، يجب عليك تسجيل الدخول أولاً",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "قم بتسجيل الدخول لعرض الامتحانات المتاحة لك",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Get.toNamed(AppRoute.login);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.PrimaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                icon: const Icon(
                                  Icons.login_rounded,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
