import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomIconAppBar extends StatelessWidget {
  const CustomIconAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Icon(
        Icons.arrow_circle_right_outlined,
        color: AppColor.White,
        size: getValueForScreenType<double>(
          context: context,
          mobile: 30,
          tablet: 50,
        ),
      ),
    );
  }
}
