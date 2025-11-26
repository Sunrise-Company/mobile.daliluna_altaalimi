import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/controller/auth/register_controller.dart';

class CitySelector extends StatelessWidget {
  const CitySelector({super.key});

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
            "المدينة",
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
          Obx(() {
            final controller = Get.find<RegisterController>();
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: getValueForScreenType<double>(
                  context: context,
                  mobile: 12,
                  tablet: 18,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColor.PrimaryColor.withOpacity(0.5),
                  width: 1.2,
                ),
                color: AppColor.BackGround3,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.countryselectedValue.value.isNotEmpty
                      ? controller.countryselectedValue.value
                      : null,
                  hint: Text(
                    "اختر المدينة",
                    style: TextStyle(
                      color: AppColor.PrimaryColor.withOpacity(0.7),
                      fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 13,
                        tablet: 17,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  icon: Icon(Icons.location_city, color: AppColor.PrimaryColor),
                  dropdownColor: Colors.white,
                  items:
                      [
                            'دمشق',
                            'ريف دمشق',
                            'اللاذقية',
                            'السويداء',
                            'حمص',
                            'حلب',
                            'درعا',
                            'دير الزور',
                            'حماة',
                            'الحسكة',
                            'ادلب',
                            'القنيطرة',
                            'الرقة',
                            'طرطوس',
                          ]
                          .map(
                            (city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(
                                city,
                                style: TextStyle(
                                  color: AppColor.PrimaryColor,
                                  fontSize: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 13,
                                    tablet: 17,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (newValue) {
                    controller.updateSelectedValue(newValue!);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
