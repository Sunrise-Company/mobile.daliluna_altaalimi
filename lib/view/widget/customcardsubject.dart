
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

import '../../controller/teacherController/homeTeacherController.dart';

class CustomCardSubject extends StatelessWidget {
  final String text;
  final int?  isFree;
  final void Function() onTap;
  final void Function() onTapShop;

   CustomCardSubject({
    super.key,
    this.isFree,
    required this.text,
    required this.onTap,
    required this.onTapShop,
  });
  final homeTeacherController = Get.put(HomePageTeacherController());
  @override
  Widget build(BuildContext context) {
    final double iconSize = getValueForScreenType<double>(
      context: context,
      mobile: 25,
      tablet: 40,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getValueForScreenType<double>(
          context: context,
          mobile: 20,
          tablet: 40,
        ),
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 10,
          tablet: 15,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColor.PrimaryColor,
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: AppColor.PrimaryColor.withOpacity(0.5),
                width: getValueForScreenType<double>(
                  context: context,
                  mobile: 1,
                  tablet: 2,
                ),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(

                horizontal: getValueForScreenType<double>(
                  context: context,
                  mobile: 15,
                  tablet: 30,
                ),
                vertical: getValueForScreenType<double>(
                  context: context,
                  mobile: 8,
                  tablet: 15,
                ),
              ),
              title: Text(
                text,
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
              leading: badges.Badge(
                showBadge: true,
                position: badges.BadgePosition.topEnd(top: -5, end: -5),
                badgeContent: const SizedBox.shrink(), // فقط لإبقاء التنسيق
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.transparent),
                child: CircleAvatar(
                  backgroundColor: AppColor.PrimaryColor.withOpacity(0.15),
                  radius: iconSize / 1.8,
                  child: Icon(
                    Icons.book_rounded,
                    color: AppColor.PrimaryColor,
                    size: iconSize,
                  ),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: onTapShop,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: EdgeInsets.all(
                      getValueForScreenType<double>(
                        context: context,
                        mobile: 8,
                        tablet: 12,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.SecondryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.white,
                      size: getValueForScreenType<double>(
                        context: context,
                        mobile: 18,
                        tablet: 28,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: onTap,
            ),
          ),
          if (isFree == 1 && homeTeacherController.isDeployed!=0)
            Positioned(
              top: 0,
              left: 0, // أقصى اليسار
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.PrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'مجاني',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

      ],
      ),
    );
  }
}
