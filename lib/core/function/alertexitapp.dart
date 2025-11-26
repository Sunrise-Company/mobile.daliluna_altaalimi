import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customelevatedbutton.dart';

Future<bool> alertExitApp() {
  Get.defaultDialog(
    backgroundColor: AppColor.BackGround,
    title: "تنبيه",
    titleStyle: const TextStyle(color: AppColor.DeepPurple, fontSize: 15),
    middleText: "هل أنت متأكد من الخروج من التطبيق ؟",
    middleTextStyle: TextStyle(color: AppColor.PrimaryColor, fontSize: 13),
    actions: [
      CustomElevatedButton(
        onPressed: (() {
          exit(0);
        }),
        text: "تأكيد",
      ),
      SizedBox(width: 10),
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
