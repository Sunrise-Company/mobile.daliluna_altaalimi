import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomTextOnTap extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const CustomTextOnTap({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: AppColor.PrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: getValueForScreenType<double>(
            context: context,
            mobile: 14,
            tablet: 17,
          ),
        ),
      ),
    );
  }
}
