import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/custombuttonbuy.dart';

class CustomCardTeacherSections extends StatelessWidget {
  final String section;
  final void Function()? onTapShop;
  const CustomCardTeacherSections({
    super.key,
    required this.section,
    this.onTapShop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        getValueForScreenType<double>(context: context, mobile: 20, tablet: 40),
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
                  section,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getValueForScreenType<double>(
                      context: context,
                      mobile: 15,
                      tablet: 15,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onTapShop,
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
                            "الدروس",
                            style: TextStyle(
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 13,
                                tablet: 17,
                              ),
                              color: AppColor.DeepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
