import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomTextAuth extends StatelessWidget {
  final String details;
  final String auth;
  final void Function()? onTap;
  const CustomTextAuth({
    super.key,
    required this.details,
    required this.auth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          details,
          style: TextStyle(
            color: AppColor.PrimaryColor,
            fontSize: getValueForScreenType<double>(
              context: context,
              mobile: 13,
              tablet: 15,
            ),
          ),
        ),
        SizedBox(
          width: getValueForScreenType<double>(
            context: context,
            mobile: 5,
            tablet: 10,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            auth,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.PrimaryColor,
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 14,
                tablet: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
