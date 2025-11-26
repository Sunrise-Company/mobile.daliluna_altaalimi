import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/controller/unitssubject_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcardmysection.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';
import 'package:daliluna_altaalimi/view/widget/customiconbasket.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';

class MyUnitsSubject extends GetView<UnitsSubjectController> {
  MyUnitsSubject({super.key});

  @override
  Widget build(BuildContext context) {
    BasketController baskerc = Get.put(BasketController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.BackGround,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            getValueForScreenType<double>(
              context: context,
              mobile: 55,
              tablet: 100,
            ),
          ),
          child: AppBar(
            leading: CustomIconAppBar(),
            actions: [
              Obx(
                () => CustomIconBasket(
                  text: baskerc.mycart.length != 0
                      ? baskerc.mycart.length.toString()
                      : "0",
                ),
              ),
            ],
            backgroundColor: AppColor.DeepPurple,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(
                  getValueForScreenType<double>(
                    context: context,
                    mobile: 30,
                    tablet: 60,
                  ),
                ),
              ),
            ),
            title: Text(
              "وحدات المادة",
              style: TextStyle(
                color: AppColor.White,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 20,
                  tablet: 30,
                ),
              ),
            ),
          ),
        ),
        body: GetBuilder<UnitsSubjectController>(
          builder: (controller) => controller.isLoadingtow
              ? controller.myunits.isNotEmpty
                    ? AnimationLimiter(
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: AppColor.SecondryColor,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      getValueForScreenType<double>(
                                        context: context,
                                        mobile: 300,
                                        tablet: 600,
                                      ),
                                  childAspectRatio:
                                      getValueForScreenType<double>(
                                        context: context,
                                        mobile: 8 / 9.8,
                                        tablet: 8 / 5.8,
                                      ),
                                  crossAxisSpacing:
                                      getValueForScreenType<double>(
                                        context: context,
                                        mobile: 7,
                                        tablet: 14,
                                      ),
                                  mainAxisSpacing:
                                      getValueForScreenType<double>(
                                        context: context,
                                        mobile: 5,
                                        tablet: 10,
                                      ),
                                ),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: false,
                            itemCount: controller.myunits.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  horizontalOffset: 200.0,
                                  curve: Curves.easeInOutBack,
                                  duration: const Duration(milliseconds: 600),
                                  child: FadeInAnimation(
                                    child: CustomCardmySectionSelected(
                                      price: controller.myunits[index]['price']
                                          .toString(),
                                      onTapShop: () {
                                        print('00');
                                        // Get.toNamed(AppRoute.login);
                                      },
                                      onTap: () {
                                        controller.goToMyLesson(
                                          controller.myunits[index]['id'],
                                          controller
                                              .myunits[index]['app_lesson_id'],
                                        );
                                      },
                                      textIcon:
                                          controller.myunits[index]['name'],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Center(child: Text("لا يوجد وحدات"))
              : Loading(),
        ),
      ),
    );
  }
}
