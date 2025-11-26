import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:shimmer/shimmer.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColor.PrimaryColor),
      ),
      onPressed: onPressed,
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: AppColor.SecondryColor,
        child: Text(text, style: TextStyle(color: AppColor.White)),
      ),
    );
  }
}
