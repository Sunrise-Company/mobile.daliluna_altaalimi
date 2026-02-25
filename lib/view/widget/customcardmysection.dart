import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/home_controller.dart';

class CustomCardmySectionSelected extends StatelessWidget {
  final Function() onTap;
  final void Function()? onTapShop;
  final String textIcon;
  final String price;
  const CustomCardmySectionSelected({
    super.key,
    required this.onTap,
    required this.textIcon,
    this.onTapShop,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
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
          tablet: 40,
        ),
        right: getValueForScreenType<double>(
          context: context,
          mobile: 20,
          tablet: 40,
        ),
        left: getValueForScreenType<double>(
          context: context,
          mobile: 20,
          tablet: 40,
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
                          mobile: 13,
                          tablet: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                // padding: EdgeInsets.only(bottom: 10),
                child: (Get.find<HomeController>().isDeployed == 1)
                    ? Text(
                        price,
                        style: TextStyle(
                          color: AppColor.grey,
                          fontSize: getValueForScreenType<double>(
                            context: context,
                            mobile: 13,
                            tablet: 15,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    backgroundColor: AppColor.SecondryColor,
                  ),
                  onPressed: onTap,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColor.BackGround3,
                  ),
                  label: Text(
                    'متاح',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 13,
                        tablet: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getValueForScreenType<double>(
                  context: context,
                  mobile: 10,
                  tablet: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
