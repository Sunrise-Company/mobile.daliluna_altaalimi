// ignore_for_file: must_be_iacademyv3utable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daliluna_altaalimi/controller/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/ourcourses_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:daliluna_altaalimi/view/widget/breadcrumb_widget.dart';

import '../../linkapi.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/basketWidget.dart';
import '../widget/customDrawer.dart';
import '../widget/loadingimage.dart';

class OurCoursesPage extends GetView<OurCoursesController> {
  OurCoursesPage({super.key});
  final BasketController baskerc = Get.put(BasketController());

  @override
  Widget build(BuildContext context) {
    Get.put(OurCoursesController());
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
                // "دوراتنا",
                'الصفوف الدراسية',
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
        // body: GetBuilder<OurCoursesController>(
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
        //                         mobile: 8 / 8,
        //                         tablet: 8 / 5,
        //                       ),
        //                       crossAxisSpacing: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 7,
        //                         tablet: 10,
        //                       ),
        //                       mainAxisSpacing: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 15,
        //                         tablet: 30,
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
        //                           curve: Curves.ease,
        //                           duration: const Duration(milliseconds: 600),
        //                           child: FadeInAnimation(
        //                             child: CustomCard(
        //                               text: controller.dataList[index]['name'],
        //                               onTap: () {
        //                                 baskerc.updateclassName(controller
        //                                     .dataList[index]['name']
        //                                     .toString());
        //
        //                                 baskerc.updateclassId(controller
        //                                     .dataList[index]['id']
        //                                     .toString());
        //
        //                                 controller.goToSubjects(
        //                                     controller.dataList[index]['id']);
        //                               },
        //                               nameImage: controller.dataList[index]
        //                                           ['image'] !=
        //                                       null
        //                                   ? controller.dataList[index]['image']
        //                                   : "-",
        //                             ),
        //                           ),
        //                         ),
        //                       );
        //                     },
        //                   ),
        //                 ),
        //               )
        //             : Center(child: Text("لا يوجد دورات"))
        //         : Loading()),
        body: Column(
          children: [
            const BreadcrumbWidget(),
            Expanded(
              child: GetBuilder<OurCoursesController>(
                builder: (controller) {
                  if (!controller.hasSelectedInstitute) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_city,
                              color: AppColor.PrimaryColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "اختر المحافظة ثم المعهد لعرض البرامج المتاحة",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColor.PrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Get.find<HomePageController>().changePage(2);
                              },
                              child: const Text('الذهاب إلى المحافظات'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!controller.isLoading) {
                    return const Loading();
                  }

                  if (controller.dataList.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد برامج متاحة في ${controller.selectedInstituteName ?? 'هذا المعهد'} حالياً",
                        style: TextStyle(
                          color: AppColor.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return Column(
                    children: [
                      if (controller.selectedInstituteName != null)
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.SecondryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.school, color: AppColor.PrimaryColor),
                              const SizedBox(width: 8),
                              Text(
                                controller.selectedInstituteName!,
                                style: TextStyle(
                                  color: AppColor.PrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: AnimationLimiter(
                          child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            color: AppColor.SecondryColor,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 8,
                              ),
                              itemCount: controller.dataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = controller.dataList[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    verticalOffset: 80.0,
                                    curve: Curves.easeOut,
                                    child: FadeInAnimation(
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 5,
                                        ),
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        shadowColor: AppColor.PrimaryColor,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal:
                                                getValueForScreenType<double>(
                                                  context: context,
                                                  mobile: 14,
                                                  tablet: 28,
                                                ),
                                            vertical:
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
                                                    mobile: 60,
                                                    tablet: 100,
                                                  ),
                                              height:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 60,
                                                    tablet: 100,
                                                  ),
                                              fit: BoxFit.cover,
                                              imageUrl: item['image'] != null
                                                  ? AppLink.image +
                                                        "/" +
                                                        item['image']
                                                  : 'https://placehold.co/150x150',
                                              placeholder: (context, url) =>
                                                  LoadingImage(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          title: Text(
                                            item['name'] ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  getValueForScreenType<double>(
                                                    context: context,
                                                    mobile: 15,
                                                    tablet: 22,
                                                  ),
                                              color: AppColor.PrimaryColor,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 6.0,
                                            ),
                                            child: Text(
                                              "عرض التفاصيل",
                                              style: TextStyle(
                                                color:
                                                    AppColor
                                                        .SecondryColor.withOpacity(
                                                      0.8,
                                                    ),
                                                fontSize:
                                                    getValueForScreenType<
                                                      double
                                                    >(
                                                      context: context,
                                                      mobile: 12,
                                                      tablet: 18,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: AppColor.SecondryColor,
                                            size: getValueForScreenType<double>(
                                              context: context,
                                              mobile: 18,
                                              tablet: 26,
                                            ),
                                          ),
                                          onTap: () {
                                            baskerc.updateclassName(
                                              item['name'].toString(),
                                            );
                                            baskerc.updateclassId(
                                              item['id'].toString(),
                                            );
                                            controller.goToSubjects(item['id']);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Obx(
          () => SizedBox(
            width: getValueForScreenType<double>(
              context: context,
              mobile: 56, // العرض على الموبايل
              tablet: 80, // العرض على التابلت
            ),
            height: getValueForScreenType<double>(
              context: context,
              mobile: 56, // الارتفاع على الموبايل
              tablet: 80, // الارتفاع على التابلت
            ),
            child: BasketWidget(heroTag: "eight"),
          ),
        ),
      ),
    );
  }
}
