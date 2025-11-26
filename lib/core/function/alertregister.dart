import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/view/widget/customelevatedbutton.dart';

Future<bool> alertRegister() {
  Get.defaultDialog(
    backgroundColor: AppColor.BackGround2,
    title: "تنبيه",
    titleStyle: const TextStyle(
      color: AppColor.DeepPurple,
      fontWeight: FontWeight.bold,
    ),
    middleText: "هل أنت متأكد من إنشاء الحساب ؟",
    middleTextStyle: TextStyle(color: AppColor.PrimaryColor),
    actions: [
      CustomElevatedButton(
        onPressed: (() {
          Get.showSnackbar(
            GetSnackBar(
              padding: EdgeInsets.all(20),
              titleText: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "تنبيه",
                  style: TextStyle(
                    color: AppColor.DeepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              messageText: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "تم إنشاء الحساب بنجاح",
                  style: TextStyle(color: AppColor.PrimaryColor, fontSize: 15),
                ),
              ),
              borderRadius: 20,
              margin: EdgeInsets.all(10),
              snackPosition: SnackPosition.TOP,
              backgroundColor: AppColor.BackGround,
              icon: Directionality(
                textDirection: TextDirection.rtl,
                child: const Icon(
                  Icons.add_alert,
                  color: AppColor.SecondryColor,
                  size: 30,
                ),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
          Get.offAllNamed(AppRoute.homePage);
        }),
        text: "تأكيد",
      ),
      CustomElevatedButton(
        onPressed: (() {
          Get.back();
        }),
        text: "إلغاء",
      ),
    ],
  );
  return Future.value(true);
}
