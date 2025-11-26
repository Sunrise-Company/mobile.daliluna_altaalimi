import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomCardSectionsMyCourses extends StatelessWidget {
  final String? section;
  final void Function()? onTap;
  const CustomCardSectionsMyCourses({
    super.key,
    required this.onTap,
    this.section,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          getValueForScreenType<double>(
            context: context,
            mobile: 20,
            tablet: 40,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.DeepPurple.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColor.PrimaryColor.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SizedBox(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 150,
              tablet: 200,
            ),
            width: getValueForScreenType<double>(
              context: context,
              mobile: 100,
              tablet: 150,
            ),
            child: Card(
              color: AppColor.BackGround,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    section!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 13,
                        tablet: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
