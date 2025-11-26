import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/imageasset.dart';

class TeacherLoad extends StatelessWidget {
  const TeacherLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getValueForScreenType<double>(
        context: context,
        mobile: 300,
        tablet: 600,
      ),
      child: Container(
        decoration: BoxDecoration(color: AppColor.White),
        child: Center(child: Lottie.asset(AppImageAsset.teacherload)),
      ),
    );
  }
}
