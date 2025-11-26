import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customelevatedbutton.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> alertInfoCompany(
  String desc,
  String title,
  String uriFacebook,
  String uriWeb,
) {
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: title,
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColor.SecondryColor,
    ),
    middleText: desc,
    middleTextStyle: TextStyle(color: AppColor.PrimaryColor, fontSize: 15),
    actions: [
      CustomElevatedButton(
        onPressed: (() {
          launchUrl(Uri.parse(uriFacebook));
        }),
        text: "Facebook",
      ),
      SizedBox(width: 10),
      CustomElevatedButton(
        onPressed: (() {
          launchUrl(Uri.parse(uriWeb));
        }),
        text: "زيارة الموقع",
      ),
    ],
  );
  return Future.value(true);
}
