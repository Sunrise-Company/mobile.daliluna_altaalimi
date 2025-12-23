import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/view/widget/customelevatedbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> alertPaidMethod(String message) async {
  late BasketController baskerc;
  baskerc = Get.put(BasketController());
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "آلية تسديد المبغ",
    titleStyle: const TextStyle(color: AppColor.PrimaryColor, fontSize: 17),
    middleText: message,
    middleTextStyle: TextStyle(color: Colors.black, fontSize: 15),
    actions: [
      CustomElevatedButton(
        onPressed: (() async {
          if (prefs.getBool('isLogin') == false ||
              prefs.getBool('isLogin') == null) {
            baskerc.app_basket_student_store();
            Get.offNamed(AppRoute.login);
          } else if (prefs.getBool('isLogin') == true) {
            baskerc.isload(true);
            Get.back();
            String res = await baskerc.app_basket_student_store();

            if (res == "true") {
              Get.snackbar('تمت عملية الشراء بنجاح', 'شكراً لك',  backgroundColor: AppColor.BackGround3,);
              Get.offAllNamed(AppRoute.homePage);
              baskerc.mycart.clear();
            }
          }
        }),
        text: "تأكيد",
      ),
      SizedBox(width: 10),
      CustomElevatedButton(
        onPressed: (() {
          Get.back();
        }),
        text: "الغاء",
      ),
    ],
  );
  return Future.value(true);
}
