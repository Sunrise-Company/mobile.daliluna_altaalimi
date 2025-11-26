import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomWidgetTeacher extends StatelessWidget {
  final String assetName;
  final String nameTeacher;
  final String aboutTeacher;
  const CustomWidgetTeacher({
    super.key,
    required this.assetName,
    required this.nameTeacher,
    required this.aboutTeacher,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: getValueForScreenType<double>(
              context: context,
              mobile: 10,
              tablet: 20,
            ),
            right: getValueForScreenType<double>(
              context: context,
              mobile: 10,
              tablet: 20,
            ),
            left: getValueForScreenType<double>(
              context: context,
              mobile: 10,
              tablet: 20,
            ),
          ),
          color: AppColor.BackGround3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundColor: AppColor.White,
                maxRadius: getValueForScreenType<double>(
                  context: context,
                  mobile: 75,
                  tablet: 125,
                ),
                backgroundImage: NetworkImage(assetName),
              ),
              Column(
                children: [
                  Text(
                    nameTeacher,
                    style: TextStyle(
                      fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 18,
                        tablet: 22,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: AppColor.BackGround3,
          padding: EdgeInsets.all(
            getValueForScreenType<double>(
              context: context,
              mobile: 10,
              tablet: 20,
            ),
          ),
          child: Text(
            aboutTeacher,
            style: TextStyle(
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 15,
                tablet: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
