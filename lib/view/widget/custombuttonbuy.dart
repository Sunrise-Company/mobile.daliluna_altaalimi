import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomButtonBuy extends StatelessWidget {
  final void Function()? onTap;
  const CustomButtonBuy({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "اشتراك",
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
                Icons.add_shopping_cart_rounded,
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
      ),
    );
  }
}
