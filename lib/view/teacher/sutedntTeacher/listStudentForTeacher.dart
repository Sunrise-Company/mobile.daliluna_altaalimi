import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/teacherController/teacherStudentController.dart/teacherstudent.dart';
import '../../../core/constant/color.dart';
import '../../widget/GetValueForScreen.dart';
import '../../widget/custombuttonbuy.dart';
import '../../widget/customcard.dart';
import '../../widget/customcardsections.dart';
import '../../widget/customwidgetviewteacher.dart';
import '../../widget/loading.dart';

class ListStudentTeacher extends GetView<TeacherListStudentContrlloer> {
  const ListStudentTeacher({super.key});

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
        //       "الطلاب",
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
                "الطلاب",
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
        //   padding: const EdgeInsets.all(35.0),
        //   child: AnimationLimiter(
        //       child: GlowingOverscrollIndicator(
        //           axisDirection: AxisDirection.down,
        //           color: Color.fromARGB(255, 214, 208, 189),
        //           child: Obx(() => controller.isloded.value
        //               ? controller.dataList.isNotEmpty
        //                   ? ListView.separated(
        //                       // physics: NeverScrollableScrollPhysics(),
        //                       separatorBuilder: (context, index) => SizedBox(
        //                         height: getValueForScreenType<double>(
        //                           context: context,
        //                           mobile: 30,
        //                           tablet: 50,
        //                         ),
        //                       ),
        //                       shrinkWrap: true,
        //                       itemCount: controller.dataList.length,
        //                       itemBuilder: (context, index) {
        //                         return AnimationConfiguration.staggeredList(
        //                           position: index,
        //                           duration: const Duration(milliseconds: 500),
        //                           child: SlideAnimation(
        //                             horizontalOffset: 150.0,
        //                             curve: Curves.decelerate,
        //                             duration:
        //                                 const Duration(milliseconds: 700),
        //                             child: FadeInAnimation(
        //                                 child: InkWell(
        //                               onTap: () {},
        //                               child: Container(
        //                                 decoration: BoxDecoration(
        //                                     border: Border.all(
        //                                       color: Color.fromARGB(
        //                                           255, 178, 139, 218),
        //                                       width: getValueForScreenType<
        //                                           double>(
        //                                         context: context,
        //                                         mobile: 1,
        //                                         tablet: 2,
        //                                       ),
        //                                     ),
        //                                     borderRadius:
        //                                         BorderRadius.circular(20),
        //                                     gradient: LinearGradient(
        //                                       begin: Alignment.topRight,
        //                                       end: Alignment.topCenter,
        //                                       colors: <Color>[
        //                                         Color.fromARGB(
        //                                             255, 238, 238, 238),
        //                                         AppColor.BackGround
        //                                       ],
        //                                     )),
        //                                 padding: EdgeInsets.all(
        //                                   getValueForScreenType<double>(
        //                                     context: context,
        //                                     mobile: 10,
        //                                     tablet: 20,
        //                                   ),
        //                                 ),
        //                                 child: Column(
        //                                   children: [
        //                                     Row(
        //                                       mainAxisAlignment:
        //                                           MainAxisAlignment.start,
        //                                       children: [
        //                                         Flexible(
        //                                           child: Text(
        //                                             'الاسم:  ',
        //                                             style: TextStyle(
        //                                                 fontSize:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 15,
        //                                                   tablet: 20,
        //                                                 ),
        //                                                 color: AppColor
        //                                                     .DeepPurple,
        //                                                 fontWeight:
        //                                                     FontWeight.bold),
        //                                           ),
        //                                         ),
        //                                         Flexible(
        //                                           child: Text(
        //                                             controller.dataList[index]
        //                                                 ['arabic_name'],
        //                                             style: TextStyle(
        //                                                 fontSize:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 15,
        //                                                   tablet: 20,
        //                                                 ),
        //                                                 fontWeight:
        //                                                     FontWeight.bold),
        //                                           ),
        //                                         )
        //                                       ],
        //                                     ),
        //                                     Row(
        //                                       children: [
        //                                         Flexible(
        //                                           child: Text(
        //                                             'اسم القسم:  ',
        //                                             style: TextStyle(
        //                                                 fontSize:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 15,
        //                                                   tablet: 20,
        //                                                 ),
        //                                                 color: AppColor
        //                                                     .DeepPurple,
        //                                                 fontWeight:
        //                                                     FontWeight.bold),
        //                                           ),
        //                                         ),
        //                                         Flexible(
        //                                           child: Text(
        //                                             controller.dataList[index]
        //                                                 ['name'],
        //                                             style: TextStyle(
        //                                                 fontSize:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 15,
        //                                                   tablet: 20,
        //                                                 ),
        //                                                 fontWeight:
        //                                                     FontWeight.bold),
        //                                           ),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                     Row(
        //                                       children: [
        //                                         Flexible(
        //                                           child: Text(
        //                                             'النوع:  ',
        //                                             style: TextStyle(
        //                                                 fontSize:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 15,
        //                                                   tablet: 20,
        //                                                 ),
        //                                                 color: AppColor
        //                                                     .DeepPurple,
        //                                                 fontWeight:
        //                                                     FontWeight.bold),
        //                                           ),
        //                                         ),
        //                                         Flexible(
        //                                           child: Text(
        //                                             controller.dataList[index]
        //                                                 ['type'],
        //                                             style: TextStyle(
        //                                                 fontSize:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 15,
        //                                                   tablet: 20,
        //                                                 ),
        //                                                 fontWeight:
        //                                                     FontWeight.bold),
        //                                           ),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                     Row(
        //                                       children: [
        //                                         Flexible(
        //                                           child: Text(
        //                                             'المبلغ:  ',
        //                                             style: TextStyle(
        //                                                 fontSize:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 15,
        //                                                   tablet: 20,
        //                                                 ),
        //                                                 color: AppColor
        //                                                     .DeepPurple,
        //                                                 fontWeight:
        //                                                     FontWeight.bold),
        //                                           ),
        //                                         ),
        //                                         Flexible(
        //                                           child: Text(
        //                                             controller.dataList[index]
        //                                                         ['price']
        //                                                     .toString() +
        //                                                 'ل.س',
        //                                             style: TextStyle(
        //                                                 fontSize:
        //                                                     getValueForScreenType<
        //                                                         double>(
        //                                                   context: context,
        //                                                   mobile: 15,
        //                                                   tablet: 20,
        //                                                 ),
        //                                                 fontWeight:
        //                                                     FontWeight.bold),
        //                                           ),
        //                                         ),
        //                                       ],
        //                                     )
        //                                   ],
        //                                 ),
        //                               ),
        //                             )),
        //                           ),
        //                         );
        //                       },
        //                     )
        //                   : Center(child: Text("لا يوجد 'طلاب'"))
        //               : Loading()))),
        // ),
        body: AnimationLimiter(
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: const Color.fromARGB(255, 214, 208, 189),
            child: Obx(
              () => controller.isloded.value
                  ? controller.dataList.isNotEmpty
                        ? ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: getValueForScreenType<double>(
                                context: context,
                                mobile: 20,
                                tablet: 40,
                              ),
                            ),
                            itemCount: controller.dataList.length,
                            itemBuilder: (context, index) {
                              final item = controller.dataList[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  horizontalOffset: 150.0,
                                  curve: Curves.decelerate,
                                  duration: const Duration(milliseconds: 700),
                                  child: FadeInAnimation(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        left: 8,
                                        right: 8,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColor.PrimaryColor,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                          ),
                                          child: ExpansionTile(
                                            tilePadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 12,
                                                    tablet: 20,
                                                  ),
                                              vertical:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 4,
                                                    tablet: 8,
                                                  ),
                                            ),
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  AppColor.DeepPurple2,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                            ),
                                            title: Text(
                                              item['arabic_name'],
                                              style: TextStyle(
                                                fontSize:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 16,
                                                      tablet: 20,
                                                    ),
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.PrimaryColor,
                                              ),
                                            ),
                                            trailing: Container(
                                              decoration: BoxDecoration(
                                                color: AppColor.SecondryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 6,
                                                    horizontal: 12,
                                                  ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "عرض التفاصيل",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            childrenPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                ),
                                            children: [
                                              const Divider(),
                                              _buildDetailRow(
                                                context,
                                                "اسم القسم",
                                                item['name'],
                                              ),
                                              _buildDetailRow(
                                                context,
                                                "النوع",
                                                item['type'],
                                              ),
                                              _buildDetailRow(
                                                context,
                                                "المبلغ",
                                                "${item['price']} ل.س",
                                              ),
                                              const SizedBox(height: 12),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "لا يوجد طلاب",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                  : Loading(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title: ",
              style: TextStyle(
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 14,
                  tablet: 18,
                ),
                fontWeight: FontWeight.bold,
                color: AppColor.DeepPurple,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 14,
                  tablet: 18,
                ),
                color: AppColor.PrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
