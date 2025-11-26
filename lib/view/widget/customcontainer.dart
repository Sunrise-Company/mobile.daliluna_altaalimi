import 'package:flutter/widgets.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.SecondryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 15,
      height: 15,
    );
  }
}
