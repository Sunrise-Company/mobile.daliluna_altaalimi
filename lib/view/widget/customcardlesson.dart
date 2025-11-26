import 'package:daliluna_altaalimi/controller/lesson_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/custombuttonbuy.dart';

class CustomCardLesson extends StatelessWidget {
  final String lesson;
  final String price;
  final void Function() onTapShop;
  final void Function()? onTap;
  final String count;
  final bool isChecking;
  final item;

  const CustomCardLesson({
    super.key,
    required this.count,
    this.isChecking = false,
    required this.lesson,
    required this.price,
    required this.onTapShop,
    this.onTap,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    LessonsController controller = Get.find();
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          getValueForScreenType<double>(
            context: context,
            mobile: 20,
            tablet: 30,
          ),
        ),
        child: InkWell(
          onTap: isChecking ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.White,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.SecondryColor2.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: getValueForScreenType<double>(
                      context: context,
                      mobile: 180,
                      tablet: 250,
                    ),
                    width: getValueForScreenType<double>(
                      context: context,
                      mobile: 180,
                      tablet: 220,
                    ),
                    child: Card(
                      color: AppColor.BackGround,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Icon(
                                Icons.play_circle_fill,
                                color: AppColor.grey,
                                size: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 59,
                                  tablet: 59,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.PrimaryColor,
                                  ),
                                  child: Text(
                                    count,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            lesson,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 13,
                                tablet: 17,
                              ),
                            ),
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              color: AppColor.grey,
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 13,
                                tablet: 17,
                              ),
                            ),
                          ),
                          Obx(() {
                            final isInMySections = controller.mylectures.any((
                              section,
                            ) {
                              final dep = section;

                              if (dep != null) {
                                return dep['app_unit_id'].toString() ==
                                        item['app_unit_id'].toString() &&
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "تم الاشتراك",
                                        style: TextStyle(
                                          fontSize:
                                              getValueForScreenType<double>(
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

                            return CustomButtonBuy(onTap: onTapShop);
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isChecking)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
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
