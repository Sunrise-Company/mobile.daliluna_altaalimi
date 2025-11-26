import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:shimmer/shimmer.dart';

class CustomButtomAuth extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const CustomButtomAuth({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: getValueForScreenType<double>(
            context: context,
            mobile: 20,
            tablet: 40,
          ),
        ),
        child: Container(
          height: getValueForScreenType<double>(
            context: context,
            mobile: 60,
            tablet: 100,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.White,
            boxShadow: [
              BoxShadow(
                color: AppColor.SecondryColor2.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColor.SecondryColor, width: 1),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 15,
                  tablet: 20,
                ),
                color: AppColor.DeepPurple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget defaultButton({
  bool isEnabled = true,
  double? width = double.infinity,
  // double? height = 50,
  required BuildContext context,
  Color? background = AppColor.PrimaryColor,
  required String text,
  required Function? fun,
}) => Container(
  height: getValueForScreenType<double>(
    context: context,
    mobile: 50,
    tablet: 80,
  ),
  width: width,
  decoration: BoxDecoration(
    color: isEnabled ? background : Colors.grey.shade400,
    borderRadius: BorderRadius.circular(25),
  ),
  child: TextButton(
    onPressed: () {
      fun!();
    },
    child: Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey,
      child: Text(
        '$text',
        style: const TextStyle(
          color: Colors.white,

          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
);
