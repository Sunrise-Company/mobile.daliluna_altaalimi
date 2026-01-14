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
  // MainExamControllerss controller = Get.put(MainExamControllerss());
  final MainExamControllerss controller = Get.put(MainExamControllerss());

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

        body: RefreshIndicator(
          onRefresh: () async {
            await controller.MainExam(); // ✅ استدعاء API
          },
          child: Stack(
            children: [
              Opacity(
                opacity: 0.4,
                child: Image.asset(
                  height: double.infinity,
                  width: double.infinity,
                  AppImageAsset.backgroundExam,
                ),
              ),

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
                                                    "id": course['id']
                                                        .toString(),
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
                                              statusColor =
                                                  Colors.amber.shade700;
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
                                                        backgroundColor:
                                                            AppColor
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
                                                                context:
                                                                    context,
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
                                                                context:
                                                                    context,
                                                                mobile: 13,
                                                                tablet: 16,
                                                              ),
                                                          color:
                                                              Colors.grey[700],
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
                                                                  horizontal:
                                                                      10,
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
                                                                    fontSize:
                                                                        13,
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
                                              // <<<<<<< lib/view/screen/exam/examList.dart
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

                                  // =======
                                  //                                             ),
                                  //                                           );
                                  //                                         },
                                  //                                       ),
                                  //                                     )
                                  //                                   : const Center(
                                  //                                       child: Text("لا يوجد امتحانات"),
                                  //                                     )
                                  //                             : const Center(child: Loading())
                                  //                       : Center(
                                  //                           child: Column(
                                  //                             mainAxisAlignment: MainAxisAlignment.center,
                                  //                             children: [
                                  //                               Icon(
                                  //                                 Icons.lock_outline_rounded,
                                  //                                 size: 80,
                                  //                                 color: Colors.black.withOpacity(0.5),
                                  //                               ),
                                  //                               const SizedBox(height: 20),
                                  //                               Text(
                                  //                                 "عذراً، يجب عليك تسجيل الدخول أولاً",
                                  //                                 style: TextStyle(
                                  //                                   fontSize: 16,
                                  //                                   color: Colors.black,
                                  //                                   fontWeight: FontWeight.bold,
                                  // >>>>>>> lib/view/screen/exam/examList.dart
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
      ),
    );
  }
}
