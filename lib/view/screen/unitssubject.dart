// ignore_for_file: must_be_iacademyv3utable
import 'package:daliluna_altaalimi/view/widget/breadcrumb_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/unitssubject_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/home_controller.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';
import 'package:daliluna_altaalimi/core/constant/cart_keys.dart';
import 'package:daliluna_altaalimi/view/widget/custombuttonbuy.dart';

class UnitsSubject extends GetView<UnitsSubjectController> {
  UnitsSubject({super.key});
  late BasketController baskerc;
  final homeController = Get.put(HomeController());

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
                "وحدات المادة",
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
        //     backgroundColor: AppColor.DeepPurple,
        //     elevation: 0.0,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.vertical(
        //         bottom: Radius.circular(
        //           getValueForScreenType<double>(
        //             context: context,
        //             mobile: 30,
        //             tablet: 60,
        //           ),
        //         ),
        //       ),
        //     ),
        //     title: Text(
        //       "وحدات المادة",
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
        // body: GetBuilder<UnitsSubjectController>(
        //     builder: (controller) => controller.isLoading
        //         ? controller.dataList.isNotEmpty
        //             ? AnimationLimiter(
        //                 child: GlowingOverscrollIndicator(
        //                   axisDirection: AxisDirection.down,
        //                   color: AppColor.SecondryColor,
        //                   child: GridView.builder(
        //                     gridDelegate:
        //                         SliverGridDelegateWithMaxCrossAxisExtent(
        //                       maxCrossAxisExtent: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 300,
        //                         tablet: 600,
        //                       ),
        //                       childAspectRatio: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 8 / 9.8,
        //                         tablet: 8 / 5.8,
        //                       ),
        //                       crossAxisSpacing: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 7,
        //                         tablet: 14,
        //                       ),
        //                       mainAxisSpacing: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 5,
        //                         tablet: 10,
        //                       ),
        //                     ),
        //                     scrollDirection: Axis.vertical,
        //                     shrinkWrap: false,
        //                     itemCount: controller.dataList.length,
        //                     itemBuilder: (BuildContext context, int index) {
        //                       return AnimationConfiguration.staggeredList(
        //                         position: index,
        //                         duration: const Duration(milliseconds: 500),
        //                         child: SlideAnimation(
        //                           horizontalOffset: 200.0,
        //                           curve: Curves.easeInOutBack,
        //                           duration: const Duration(milliseconds: 600),
        //                           child: FadeInAnimation(
        //                             child: CustomCardSectionSelected(
        //                                 item: controller.dataList[index],
        //                                 price: controller.dataList[index]
        //                                         ['price']
        //                                     .toString(),
        //                                 onTapShop: () {
        //                                   baskerc.updateBasket(
        //                                     controller.dataList[index]['id']
        //                                         .toString(),
        //                                     'unit',
        //                                     controller.dataList[index]['name'],
        //                                     controller.dataList[index]['price'],
        //                                     baskerc.teacherName.toString(),
        //                                     baskerc.className.toString(),
        //                                     baskerc.subjectName.toString(),
        //                                     baskerc.teacherId.toString(),
        //                                     baskerc.classId.toString(),
        //                                     baskerc.subjectId.toString(),
        //                                     baskerc.maindepId.toString(),
        //                                   );
        //
        //                                   print('add success');
        //                                 },
        //                                 onTap: () {
        //                                   controller.goToLesson(
        //                                       controller.dataList[index]['id'],
        //                                       controller.dataList[index]
        //                                           ['app_lesson_id']);
        //                                 },
        //                                 textIcon: controller.dataList[index]
        //                                     ['name']),
        //                           ),
        //                         ),
        //                       );
        //                     },
        //                   ),
        //                 ),
        //               )
        //             : Center(child: Text("لا يوجد وحدات "))
        //         : Loading()),
        body: Column(
          children: [
            const BreadcrumbWidget(),
            Expanded(
              child: GetBuilder<UnitsSubjectController>(
                builder: (controller) => controller.isLoading
                    ? controller.dataList.isNotEmpty
                          ? AnimationLimiter(
                              child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color: AppColor.SecondryColor,
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: getValueForScreenType<double>(
                                      context: context,
                                      mobile: 10,
                                      tablet: 30,
                                    ),
                                    vertical: getValueForScreenType<double>(
                                      context: context,
                                      mobile: 15,
                                      tablet: 30,
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: getValueForScreenType<double>(
                                          context: context,
                                          mobile: 10,
                                          tablet: 20,
                                        ),
                                      ),
                                  itemCount: controller.dataList.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.dataList[index];
                                    final name = item['name'] ?? '';
                                    final price = item['price'].toString();

                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      child: SlideAnimation(
                                        horizontalOffset: 200.0,
                                        curve: Curves.easeInOutBack,
                                        duration: const Duration(
                                          milliseconds: 600,
                                        ),
                                        child: FadeInAnimation(
                                          child: Card(
                                            elevation: 6,
                                            shadowColor: AppColor.PrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            color: Colors.white,
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
                                                controller.goToLesson(
                                                  item['id'],
                                                  item['app_lesson_id'],
                                                );
                                              },
                                              leading: CircleAvatar(
                                                radius:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 25,
                                                      tablet: 40,
                                                    ),
                                                backgroundColor:
                                                    AppColor
                                                        .SecondryColor.withOpacity(
                                                      0.5,
                                                    ),
                                                child: Icon(
                                                  Icons.menu_book_rounded,
                                                  color: AppColor.PrimaryColor,
                                                  size:
                                                      getValueForScreenType<
                                                        double
                                                      >(
                                                        context: context,
                                                        mobile: 22,
                                                        tablet: 35,
                                                      ),
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
                                                        tablet: 22,
                                                      ),
                                                  color: AppColor.PrimaryColor,
                                                ),
                                              ),
                                              subtitle:(homeController.isDeployed!=0)? Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5.0,
                                                ),
                                                child: Text(
                                                  "السعر: $price ",
                                                  style: TextStyle(
                                                    color: AppColor.grey,
                                                    fontSize:
                                                        getValueForScreenType<
                                                          double
                                                        >(
                                                          context: context,
                                                          mobile: 13,
                                                          tablet: 18,
                                                        ),
                                                  ),
                                                ),
                                              ):SizedBox(),
                                              trailing: Obx(() {
                                                final currentUnitId = item['id']
                                                    ?.toString();

                                                // نتحقق من أن الوحدة موجودة في myunits
                                                // نفترض أن myunits تحتوي فقط على الوحدات المشتراة ككل
                                                final isUnitPurchased =
                                                    controller.myunits.any((
                                                      unit,
                                                    ) {
                                                      if (unit != null) {
                                                        return unit['id']
                                                                ?.toString() ==
                                                            currentUnitId;
                                                      }
                                                      return false;
                                                    });

                                                if (isUnitPurchased) {
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: AppColor
                                                            .SecondryColor,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "تم الاشتراك",
                                                        style: TextStyle(
                                                          color: AppColor
                                                              .DeepPurple,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              getValueForScreenType<
                                                                double
                                                              >(
                                                                context:
                                                                    context,
                                                                mobile: 11,
                                                                tablet: 17,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }

                                                return (homeController.isDeployed!=0)? CustomButtonBuy(
                                                  onTap: () async {
                                                    return await baskerc
                                                        .updateBasket(
                                                          item['id'].toString(),
                                                          'unit',
                                                          item['name'],
                                                          item['price'],
                                                          baskerc.teacherName
                                                              .toString(),
                                                          baskerc.className
                                                              .toString(),
                                                          baskerc.subjectName
                                                              .toString(),
                                                          baskerc.teacherId
                                                              .toString(),
                                                          baskerc.classId
                                                              .toString(),
                                                          baskerc.subjectId
                                                              .toString(),
                                                          baskerc.maindepId
                                                              .toString(),
                                                          baskerc.instituteId
                                                              .toString(),
                                                        );
                                                  },
                                                  targetCartKey:
                                                      CartAnimationKeys
                                                          .unitsSubject,
                                                ):SizedBox();
                                              }),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : const Center(child: Text("لا يوجد وحدات"))
                    : const Loading(),
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
            heroTag: "thirteen",
            customKey: CartAnimationKeys.unitsSubject,
          ),
        ),
      ),
    );
  }
}
