import 'dart:developer';

import 'package:daliluna_altaalimi/controller/unitssubject_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/custombuttonbuy.dart';
import 'package:daliluna_altaalimi/controller/home_controller.dart';

class CustomCardSectionSelected extends StatelessWidget {
  final Function() onTap;
  final Future<bool> Function()? onTapShop;
  final String textIcon;
  final String price;
  final item;
  final GlobalKey? targetCartKey;

  const CustomCardSectionSelected({
    super.key,
    required this.onTap,
    required this.textIcon,
    this.onTapShop,
    required this.price,
    required this.item,
    this.targetCartKey,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UnitsSubjectController>();
    return Container(
      padding: EdgeInsets.only(
        top: getValueForScreenType<double>(
          context: context,
          mobile: 40,
          tablet: 60,
        ),
        bottom: getValueForScreenType<double>(
          context: context,
          mobile: 20,
          tablet: 30,
        ),
        right: getValueForScreenType<double>(
          context: context,
          mobile: 20,
          tablet: 30,
        ),
        left: getValueForScreenType<double>(
          context: context,
          mobile: 20,
          tablet: 30,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: AppColor.DeepPurple, blurRadius: 10.0),
          ],
          color: AppColor.BackGround2,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: AppColor.SecondryColor2,
            width: getValueForScreenType<double>(
              context: context,
              mobile: 2,
              tablet: 3,
            ),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(
                    getValueForScreenType<double>(
                      context: context,
                      mobile: 5,
                      tablet: 10,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      textIcon,
                      style: TextStyle(
                        color: AppColor.PrimaryColor,
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 10,
                          tablet: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: (Get.find<HomeController>().isDeployed == 1)
                    ? Text(
                        price,
                        style: TextStyle(
                          color: AppColor.grey,
                          fontSize: getValueForScreenType<double>(
                            context: context,
                            mobile: 12,
                            tablet: 17,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              Obx(() {
                final isInMySections = controller.myunits.any((section) {
                  final dep = section;

                  if (dep != null) {
                    return dep['app_teacher_id'].toString() ==
                            item['app_teacher_id'].toString() &&
                        dep['app_lesson_id'].toString() ==
                            item['app_lesson_id'].toString() &&
                        dep['app_class_id'].toString() ==
                            item['app_class_id'].toString();
                  }
                  return false;
                });

                if (isInMySections) {
                  return SizedBox(
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
                            "تم الاشتراك",
                            style: TextStyle(
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 10,
                                tablet: 17,
                              ),
                              color: AppColor.DeepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.check_circle,
                            size: getValueForScreenType<double>(
                              context: context,
                              mobile: 17,
                              tablet: 22,
                            ),
                            color: AppColor.SecondryColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return CustomButtonBuy(
                  onTap: onTapShop,
                  targetCartKey: targetCartKey,
                );
              }),
              SizedBox(
                height: getValueForScreenType<double>(
                  context: context,
                  mobile: 10,
                  tablet: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
