import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';

class CustomIconBasket extends StatelessWidget {
  final String text;
  const CustomIconBasket({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeStyle: badges.BadgeStyle(badgeColor: AppColor.BackGround),
      position: badges.BadgePosition.topStart(
        top: getValueForScreenType<double>(
          context: context,
          mobile: -1,
          tablet: -3,
        ),
        start: getValueForScreenType<double>(
          context: context,
          mobile: -10,
          tablet: -10,
        ),
      ),
      badgeContent: Text(
        text,
        style: TextStyle(
          color: AppColor.PrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 8,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.only(
          left: getValueForScreenType<double>(
            context: context,
            mobile: 20,
            tablet: 40,
          ),
          top: getValueForScreenType<double>(
            context: context,
            mobile: 4,
            tablet: 8,
          ),
        ),
        onPressed: () {
          Get.toNamed(AppRoute.basket);
        },
        icon: Icon(
          Icons.shopping_cart_rounded,
          color: AppColor.PrimaryColor,
          size: getValueForScreenType<double>(
            context: context,
            mobile: 30,
            tablet: 50,
          ),
        ),
      ),
    );
  }
}
