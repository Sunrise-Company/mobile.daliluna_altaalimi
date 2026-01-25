// ignore_for_file: must_be_iacademyv3utable

import 'package:daliluna_altaalimi/view/widget/customDrawer.dart';
import 'package:daliluna_altaalimi/view/widget/customcardhome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/home_controller.dart';

import 'package:daliluna_altaalimi/controller/ourcourses_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/imageasset.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/function/alertexitapp.dart';
import 'package:daliluna_altaalimi/core/function/alertinfocompany.dart';
import 'package:daliluna_altaalimi/view/widget/customcarousels.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import '../widget/basketWidget.dart';

class Home extends GetView<HomeController> {
  Home({super.key});

  final OurCoursesController ourcoursecontroller = Get.put(
    OurCoursesController(),
  );
  final BasketController baskerc = Get.put(BasketController());

  @override
  Widget build(BuildContext context) {
    // Ensure HomeController is available (in case widget is loaded without route binding)
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }

    return WillPopScope(
      onWillPop: alertExitApp,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: customDrawer(context),
          backgroundColor: Colors.white,
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(
          //     getValueForScreenType<double>(
          //       context: context,
          //       mobile: 85,
          //       tablet: 100,
          //     ),
          //   ),
          //   child: AppBar(
          //     // toolbarHeight: getValueForScreenType<double>(
          //     //   context: context,
          //     //   mobile: 160, // العرض على الموبايل
          //     //   tablet: 140, // العرض على التابلت
          //     // ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.vertical(
          //         bottom: Radius.circular(
          //           getValueForScreenType<double>(
          //             context: context,
          //             mobile: 40,
          //             tablet: 60,
          //           ),
          //         ),
          //       ),
          //     ),
          //     backgroundColor: AppColor.DeepPurple,
          //     elevation: 0.0,
          //     // leadingWidth: 100,
          //     leading:      Column(
          //         children:[
          //           Text("مرحباً, رغد",
          //             style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.white,
          //             ),
          //           ),
          //           Text("هيا نبدأ",
          //             style: TextStyle(
          //               fontSize: 10,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.white,
          //             ),
          //           ),
          //
          //         ] ),
          //
          //     title: Image.asset(
          //       AppImageAsset.newLogo,
          //       width: getValueForScreenType<double>(
          //         context: context,
          //         mobile: 220,
          //         tablet: 650,
          //       ),
          //       height: getValueForScreenType<double>(
          //         context: context,
          //         mobile: 100,
          //         tablet: 100,
          //       ),
          //     ),
          //     actions: [
          //       Stack(
          //         alignment: Alignment.topLeft,
          //         children: [
          //           IconButton(
          //               padding: EdgeInsets.only(
          //                 right: getValueForScreenType<double>(
          //                   context: context,
          //                   mobile: 20,
          //                   tablet: 40,
          //                 ),
          //                 top: getValueForScreenType<double>(
          //                   context: context,
          //                   mobile: 4,
          //                   tablet: 8,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 Get.toNamed(AppRoute.notifications,
          //                     arguments: {'app_student_id': 555});
          //               },
          //               icon: Icon(
          //                 Icons.notifications,
          //                 color: AppColor.PrimaryColor,
          //                 size: getValueForScreenType<double>(
          //                   context: context,
          //                   mobile: 30,
          //                   tablet: 50,
          //                 ),
          //               )),
          //         ],
          //       ),
          //
          //
          //     ],
          //     // actions: [
          //     //   Obx(
          //     //     () => CustomIconBasket(
          //     //         text: baskerc.mycart.length != 0
          //     //             ? baskerc.mycart.length.toString()
          //     //             : "0"),
          //     //   ),
          //     // ],
          //   ),
          // ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              getValueForScreenType<double>(
                context: context,
                mobile: 60,
                tablet: 100,
              ),
            ),
            child: AppBar(
              backgroundColor: AppColor.PrimaryColor,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(
                    getValueForScreenType<double>(
                      context: context,
                      mobile: 40,
                      tablet: 60,
                    ),
                  ),
                ),
              ),
              title: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getValueForScreenType<double>(
                    context: context,
                    mobile: 2,
                    tablet: 30,
                  ),
                  vertical: getValueForScreenType<double>(
                    context: context,
                    mobile: 4,
                    tablet: 10,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
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

                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "مرحباً, رغد",
                    //       style: TextStyle(
                    //         fontSize: getValueForScreenType<double>(
                    //           context: context,
                    //           mobile: 22,
                    //           tablet: 28,
                    //         ),
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //     const SizedBox(height: 4),
                    //     Text(
                    //       "هيا نبدأ ✨",
                    //       style: TextStyle(
                    //         fontSize: getValueForScreenType<double>(
                    //           context: context,
                    //           mobile: 16,
                    //           tablet: 22,
                    //         ),
                    //         fontWeight: FontWeight.w400,
                    //         color: Colors.white70,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        ClipRect(
                          child: Image.asset(
                            AppImageAsset.newLogoWithoutBackground,
                            width: getValueForScreenType<double>(
                              context: context,
                              mobile: 65,
                              tablet: 75,
                            ),
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 75,
                              tablet: 85,
                            ),
                            // fit: BoxFit.scaleDown,
                          ),
                        ),

                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Get.toNamed(
                              AppRoute.notifications,
                              arguments: {'app_student_id': 555},
                            );
                          },
                          icon: Icon(
                            Icons.notifications,
                            color: AppColor.SecondryColor,
                            size: getValueForScreenType<double>(
                              context: context,
                              mobile: 30,
                              tablet: 50,
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

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Professional Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getValueForScreenType<double>(
                      context: context,
                      mobile: 16,
                      tablet: 30,
                    ),
                    vertical: getValueForScreenType<double>(
                      context: context,
                      mobile: 12,
                      tablet: 16,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoute.search);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: AppColor.DeepPurple2,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getValueForScreenType<double>(
                            context: context,
                            mobile: 12,
                            tablet: 16,
                          ),
                          vertical: getValueForScreenType<double>(
                            context: context,
                            mobile: 10,
                            tablet: 12,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: AppColor.DeepPurple,
                              size: getValueForScreenType<double>(
                                context: context,
                                mobile: 22,
                                tablet: 28,
                              ),
                            ),
                            SizedBox(
                              width: getValueForScreenType<double>(
                                context: context,
                                mobile: 10,
                                tablet: 12,
                              ),
                            ),
                            Text(
                              'ابحث عن الدروس والمعاهد والمعلمين...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 14,
                                  tablet: 16,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // GetBuilder<BasketController>(
                //   builder: (controller) => Center(
                //     child: InkWell(
                //       onTap: () {
                //         alertInfoCompany(
                //             baskerc
                //                 .companyInformations['app_company_informations']
                //                     ['description']
                //                 .toString(),
                //             baskerc
                //                 .companyInformations['app_company_informations']
                //                     ['title']
                //                 .toString(),
                //             baskerc
                //                 .companyInformations['app_company_informations']
                //                     ['facebook']
                //                 .toString(),
                //             baskerc
                //                 .companyInformations['app_company_informations']
                //                     ['website']
                //                 .toString());
                //       },
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Container(
                //             padding: EdgeInsets.only(
                //               top: getValueForScreenType<double>(
                //                 context: context,
                //                 mobile: 20,
                //                 tablet: 40,
                //               ),
                //               bottom: getValueForScreenType<double>(
                //                 context: context,
                //                 mobile: 20,
                //                 tablet: 40,
                //               ),
                //             ),
                //             child: Text(
                //               'By SunriseIt',
                //               style: TextStyle(
                //                 fontSize: getValueForScreenType<double>(
                //                   context: context,
                //                   mobile: 13,
                //                   tablet: 15,
                //                 ),
                //                 decoration: TextDecoration.underline,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // GetBuilder<BasketController>(
                //   builder: (controller) => Center(
                //     child: GestureDetector(
                //       onTap: () {
                //         alertInfoCompany(
                //           baskerc.companyInformations['app_company_informations']['description']
                //               .toString(),
                //           baskerc.companyInformations['app_company_informations']['title']
                //               .toString(),
                //           baskerc.companyInformations['app_company_informations']['facebook']
                //               .toString(),
                //           baskerc.companyInformations['app_company_informations']['website']
                //               .toString(),
                //         );
                //       },
                //       child: AnimatedContainer(
                //         duration: const Duration(milliseconds: 500),
                //         curve: Curves.easeOutBack,
                //         padding: EdgeInsets.symmetric(
                //           horizontal: getValueForScreenType<double>(
                //             context: context,
                //             mobile: 25,
                //             tablet: 40,
                //           ),
                //           vertical: getValueForScreenType<double>(
                //             context: context,
                //             mobile: 1,
                //             tablet: 20,
                //           ),
                //         ),
                //         decoration: BoxDecoration(
                //
                //           borderRadius: BorderRadius.circular(50),
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.teal.withOpacity(0.3),
                //               blurRadius: 10,
                //               offset: const Offset(0, 4),
                //             ),
                //           ],
                //         ),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             const Icon(
                //               Icons.info_outline,
                //               color: Colors.white,
                //               size: 18,
                //             ),
                //             const SizedBox(width: 8),
                //             Text(
                //               'By SunriseIt',
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.bold,
                //                 letterSpacing: 0.8,
                //                 fontSize: getValueForScreenType<double>(
                //                   context: context,
                //                   mobile: 13,
                //                   tablet: 15,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // Container(
                //     padding: EdgeInsets.only(
                //       right: getValueForScreenType<double>(
                //         context: context,
                //         mobile: 20,
                //         tablet: 40,
                //       ),
                //       left: getValueForScreenType<double>(
                //         context: context,
                //         mobile: 20,
                //         tablet: 40,
                //       ),
                //     ),
                //     child: CustomTitleText(text: "آخر العروض")),
                // Hero Section with Gradient Background
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getValueForScreenType<double>(
                      context: context,
                      mobile: 16,
                      tablet: 32,
                    ),
                    vertical: getValueForScreenType<double>(
                      context: context,
                      mobile: 12,
                      tablet: 20,
                    ),
                  ),
                  padding: EdgeInsets.all(
                    getValueForScreenType<double>(
                      context: context,
                      mobile: 16,
                      tablet: 24,
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.PrimaryColor.withOpacity(0.06),
                        AppColor.SecondryColor.withOpacity(0.03),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(
                      getValueForScreenType<double>(
                        context: context,
                        mobile: 24,
                        tablet: 32,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.PrimaryColor.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.PrimaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.location_city_rounded,
                              color: Colors.white,
                              size: getValueForScreenType<double>(
                                context: context,
                                mobile: 24,
                                tablet: 34,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'اختر محافظتك',
                                  style: TextStyle(
                                    fontSize: getValueForScreenType<double>(
                                      context: context,
                                      mobile: 16,
                                      tablet: 22,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.PrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'للعثور على المعاهد المتاحة',
                                  style: TextStyle(
                                    fontSize: getValueForScreenType<double>(
                                      context: context,
                                      mobile: 13,
                                      tablet: 16,
                                    ),
                                    color: AppColor.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Carousel Slider
                SizedBox(
                  height: getValueForScreenType<double>(
                    context: context,
                    mobile: 8,
                    tablet: 16,
                  ),
                ),
                Obx(() {
                  return ourcoursecontroller.slider.length != 0
                      ? Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: getValueForScreenType<double>(
                              context: context,
                              mobile: 16,
                              tablet: 32,
                            ),
                          ),
                          child: CustomCarouselslider(
                            items: ourcoursecontroller.slider,
                          ),
                        )
                      : const SizedBox.shrink();
                }),

                // Title Section with enhanced design
                SizedBox(
                  height: getValueForScreenType<double>(
                    context: context,
                    mobile: 20,
                    tablet: 32,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getValueForScreenType<double>(
                      context: context,
                      mobile: 20,
                      tablet: 40,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: getValueForScreenType<double>(
                          context: context,
                          mobile: 24,
                          tablet: 30,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.PrimaryColor,
                              AppColor.SecondryColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "المحافظات",
                        style: TextStyle(
                          fontSize: getValueForScreenType<double>(
                            context: context,
                            mobile: 20,
                            tablet: 26,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppColor.PrimaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      GetBuilder<HomeController>(
                        builder: (hc) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.SecondryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${hc.cities.length}',
                            style: TextStyle(
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 12,
                                tablet: 16,
                              ),
                              fontWeight: FontWeight.bold,
                              color: AppColor.PrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getValueForScreenType<double>(
                    context: context,
                    mobile: 12,
                    tablet: 16,
                  ),
                ),
                GetBuilder<HomeController>(
                  builder: (homeController) {
                    if (homeController.isLoadingCities) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getValueForScreenType<double>(
                            context: context,
                            mobile: 16,
                            tablet: 36,
                          ),
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.9,
                              ),
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    if (homeController.citiesError != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 40,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.wifi_off_rounded,
                                  size: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 40,
                                    tablet: 60,
                                  ),
                                  color: Colors.red.shade400,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "عذراً، حدث خطأ ما",
                                style: TextStyle(
                                  fontSize: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 18,
                                    tablet: 24,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.PrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                homeController.citiesError!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 14,
                                    tablet: 18,
                                  ),
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 200,
                                  tablet: 300,
                                ),
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: homeController.fetchCities,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.PrimaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "إعادة المحاولة",
                                        style: TextStyle(
                                          fontSize:
                                              getValueForScreenType<double>(
                                                context: context,
                                                mobile: 16,
                                                tablet: 20,
                                              ),
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (homeController.cities.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 60,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_city_rounded,
                                  size: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 60,
                                    tablet: 80,
                                  ),
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد محافظات متاحة حالياً',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 16,
                                    tablet: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return AnimationLimiter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getValueForScreenType<double>(
                            context: context,
                            mobile: 16,
                            tablet: 36,
                          ),
                          vertical: 10,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeController.cities.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.95,
                              ),
                          itemBuilder: (context, index) {
                            final city = homeController.cities[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: 3,
                              child: ScaleAnimation(
                                scale: 0.5,
                                child: FadeInAnimation(
                                  child: _CityCard(
                                    city: city,
                                    controller: Get.find<HomeController>(),
                                    onTap: () {},
                                    //     homeController.goToInstitutes(
                                    //   Map<String, dynamic>.from(city),
                                    // ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: getValueForScreenType<double>(
                    context: context,
                    mobile: 55,
                    tablet: 60,
                  ),
                ),
                GetBuilder<BasketController>(
                  builder: (controller) => Center(
                    child: GestureDetector(
                      onTap: () {
                        alertInfoCompany(
                          baskerc
                              .companyInformations['app_company_informations']['description']
                              .toString(),
                          baskerc
                              .companyInformations['app_company_informations']['title']
                              .toString(),
                          baskerc
                              .companyInformations['app_company_informations']['facebook']
                              .toString(),
                          baskerc
                              .companyInformations['app_company_informations']['website']
                              .toString(),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            'By SunriseIt',
                            style: TextStyle(
                              color: AppColor.PrimaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 13,
                                tablet: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: SizedBox(
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
            child: BasketWidget(
              heroTag: 'one',
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced City Card Widget
class _CityCard extends StatelessWidget {
  final Map<String, dynamic> city;
  final VoidCallback onTap;
  final HomeController controller;
  const _CityCard({
    required this.city,
    required this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardHome(
      name: city['name'] ?? '',
      image: city['image'],
      onTap: () => controller.goToInstitutes(Map<String, dynamic>.from(city)),
      // onTap: () => Get.find<HomeController>().goToInstitutes(
      //   Map<String, dynamic>.from(city),
      // ),
    );
  }
}
