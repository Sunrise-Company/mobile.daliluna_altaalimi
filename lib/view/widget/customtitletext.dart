// import 'package:flutter/material.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:daliluna_altaalimi/core/constant/color.dart';
//
// class CustomTitleText extends StatelessWidget {
//   final String text;
//   const CustomTitleText({super.key, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//           fontSize: getValueForScreenType<double>(
//             context: context,
//             mobile: 15,
//             tablet: 20,
//           ),
//           fontWeight: FontWeight.bold,
//           color: AppColor.DeepPurple),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomTitleText extends StatelessWidget {
  final String text;
  const CustomTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double fontSize = getValueForScreenType<double>(
      context: context,
      mobile: 26,
      tablet: 32,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: AppColor.SecondryColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: fontSize * 4,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColor.SecondryColor,
          ),
        ),
      ],
    );
  }
}
