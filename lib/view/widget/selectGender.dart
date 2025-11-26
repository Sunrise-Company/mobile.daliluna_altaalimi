import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/controller/auth/register_controller.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getValueForScreenType<double>(
          context: context,
          mobile: 15,
          tablet: 25,
        ),
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 12,
          tablet: 20,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColor.DeepPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColor.PrimaryColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الجنس",
            style: TextStyle(
              color: AppColor.PrimaryColor,
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 14,
                tablet: 18,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: getValueForScreenType<double>(
              context: context,
              mobile: 10,
              tablet: 15,
            ),
          ),
          GetBuilder<RegisterController>(
            builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenderOption(
                    context,
                    label: "ذكر",
                    isSelected: controller.gender == "ذكر",
                    onTap: () => controller.onClickRadioButton("ذكر"),
                    icon: Icons.male,
                  ),
                  _buildGenderOption(
                    context,
                    label: "أنثى",
                    isSelected: controller.gender == "أنثى",
                    onTap: () => controller.onClickRadioButton("أنثى"),
                    icon: Icons.female,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            vertical: getValueForScreenType<double>(
              context: context,
              mobile: 10,
              tablet: 15,
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isSelected
                ? AppColor.SecondryColor.withOpacity(0.8)
                : Colors.white,
            border: Border.all(
              color: isSelected
                  ? AppColor.PrimaryColor
                  : AppColor.PrimaryColor.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.SecondryColor.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColor.White : AppColor.PrimaryColor,
                size: getValueForScreenType<double>(
                  context: context,
                  mobile: 20,
                  tablet: 25,
                ),
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColor.White : AppColor.PrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: getValueForScreenType<double>(
                    context: context,
                    mobile: 13,
                    tablet: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
