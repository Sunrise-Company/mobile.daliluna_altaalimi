import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../controller/basket_controller.dart';
import '../../core/constant/color.dart';
import '../../core/constant/imageasset.dart';
import '../../core/constant/routes.dart';
import 'customiconbasket.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  late BasketController baskerc;

  final double appBarHeight = 150.0;

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    baskerc = Get.put(BasketController());
    return Container(
      height: getValueForScreenType<double>(
        context: context,
        mobile: 110,
        tablet: 100,
      ),
      decoration: BoxDecoration(
        color: AppColor
            .DeepPurple, // Customize the background color to your liking
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -65,
            left: -50,
            right: -50,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Image.asset(
                AppImageAsset.logo,
                width: getValueForScreenType<double>(
                  context: context,
                  mobile: 220,
                  tablet: 650,
                ),
                height: getValueForScreenType<double>(
                  context: context,
                  mobile: 85,
                  tablet: 100,
                ),
              ),
              centerTitle: true,
              leading: Stack(
                alignment: Alignment.topLeft,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(
                      right: getValueForScreenType<double>(
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
                      Get.toNamed(
                        AppRoute.notifications,
                        arguments: {'app_student_id': 555},
                      );
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: AppColor.PrimaryColor,
                      size: getValueForScreenType<double>(
                        context: context,
                        mobile: 30,
                        tablet: 50,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                Obx(
                  () => CustomIconBasket(
                    text: baskerc.mycart.length != 0
                        ? baskerc.mycart.length.toString()
                        : "0",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
