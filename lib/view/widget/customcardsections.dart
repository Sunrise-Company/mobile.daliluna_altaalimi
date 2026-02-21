import 'package:daliluna_altaalimi/controller/sectionssubject_controller.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/custombuttonbuy.dart';

import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/view/widget/animated_cart_icon.dart';

import '../../controller/home_controller.dart';

class CustomCardSections extends StatelessWidget {
  final String section;
  final String price;
  final String countVideos;
  final Future<bool> Function()? onTapShop;
  final void Function()? onTap;
  final String sectionId;
  final String teacherId;
  final String subjectId;
  final String classId;
  final Map<String, dynamic> item;
  final bool isChecking;
  final GlobalKey? targetCartKey;

  const CustomCardSections({
    super.key,
    required this.section,
    required this.price,
    required this.countVideos,
    this.onTapShop,
    required this.sectionId,
    required this.teacherId,
    required this.subjectId,
    required this.classId,
    required this.item,
    this.onTap,
    this.isChecking = false,
    this.targetCartKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        getValueForScreenType<double>(context: context, mobile: 15, tablet: 30),
      ),
      child: InkWell(
        onTap: isChecking ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.PrimaryColor,
                      blurRadius: 8,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Card(
                  color: AppColor.BackGround,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          section,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getValueForScreenType<double>(
                              context: context,
                              mobile: 14,
                              tablet: 18,
                            ),
                            color: AppColor.PrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "السعر: $price",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getValueForScreenType<double>(
                              context: context,
                              mobile: 13,
                              tablet: 16,
                            ),
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_collection,
                              color: AppColor.PrimaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "عدد الفيديوهات: $countVideos",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 12,
                                  tablet: 15,
                                ),
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          final controller =
                              Get.find<SectionsSubjectController>();
                          final isInMySections = controller.mysection.any(
                            (s) => s['id'].toString() == item['id'].toString(),
                          );

                          if (isInMySections) {
                            return SizedBox(
                              width: getValueForScreenType<double>(
                                context: context,
                                mobile: 90,
                                tablet: 150,
                              ),
                              height: getValueForScreenType<double>(
                                context: context,
                                mobile: 40,
                                tablet: 50,
                              ),
                              child: Card(
                                elevation: 3,
                                color: AppColor.SecondryColor2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "تم الاشتراك",
                                      style: TextStyle(
                                        fontSize: getValueForScreenType<double>(
                                          context: context,
                                          mobile: 10,
                                          tablet: 17,
                                        ),
                                        color: AppColor.DeepPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_circle,
                                      size: getValueForScreenType<double>(
                                        context: context,
                                        mobile: 17,
                                        tablet: 22,
                                      ),
                                      color: AppColor.SecondryColor,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return CustomButtonBuy(onTap: onTapShop);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              if (isChecking)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
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

class CustomListTileSectionWidget extends StatelessWidget {
  final homeController = Get.put(HomeController());
  final Map<String, dynamic> item;
  final bool isChecking;
  final Future<bool> Function()? onTapShop;
  final void Function()? onTap;
  final Widget? trailing;
  final String? province;

  final GlobalKey? targetCartKey;

   CustomListTileSectionWidget({
    super.key,
    required this.item,
    required this.isChecking,
    this.onTapShop,
    this.onTap,
    this.trailing,
    this.province,
    this.targetCartKey,
  });

  @override
  Widget build(BuildContext context) {
    final baskerc = Get.find<BasketController>();
    final controller = Get.find<SectionsSubjectController>();
    final String section = item['name'];
    final String price = item['price'].toString();
    final String countVideos =
        item['lesson_dep_files_count']?.toString() ?? '0';

    return Stack(
      children: [
        Card(
          color: Colors.white,
          shadowColor: AppColor.PrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            onTap: isChecking ? null : onTap,
            leading: CircleAvatar(
              backgroundColor: AppColor.PrimaryColor,
              child: const Icon(Icons.video_library, color: Colors.white),
            ),
            title: Text(
              section,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.PrimaryColor,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 14,
                  tablet: 17,
                ),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (homeController.isDeployed!=0)?
                  Text(
                    "السعر: $price",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 12,
                        tablet: 14,
                      ),
                    ),
                  ):SizedBox(),
                  Text(
                    "عدد الفيديوهات: $countVideos",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 12,
                        tablet: 14,
                      ),
                    ),
                  ),
                  if (province != null) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColor.PrimaryColor,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            province!,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 12,
                                tablet: 14,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            trailing:
                trailing ??
                Obx(() {
                  final isInMySections = controller.mysection.any(
                    (s) => s['id'].toString() == item['id'].toString(),
                  );

                  if (isInMySections) {
                    return const Icon(Icons.check_circle, color: Colors.green);
                  } else {
                    return AnimatedCartIcon(
                      color: AppColor.SecondryColor,
                      onPressed: onTapShop,
                      targetCartKey: targetCartKey,
                    );
                  }
                }),
          ),
        ),
        if (isChecking)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.PrimaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
