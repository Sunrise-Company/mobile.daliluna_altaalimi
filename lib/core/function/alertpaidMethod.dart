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
    middleText: message.isEmpty ? "اضغط تأكيد لإتمام عملية الشراء" : message,
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
            try {
              var res = await baskerc.app_basket_student_store();

              baskerc.isload(false);
              if (res['status'] == "true") {
                Get.snackbar(
                  'تمت عملية الشراء بنجاح',
                  'شكراً لك',
                  backgroundColor: AppColor.BackGround3,
                );
                Get.offAllNamed(AppRoute.homePage);
                baskerc.mycart.clear();
                baskerc.count.value = 0;
              } else {
                Get.snackbar(
                  'فشلت عملية الشراء',
                  res['message'] ?? 'الرجاء المحاولة مرة أخرى',
                  backgroundColor: AppColor.BackGround3,
                );
              }
            } catch (e) {
              baskerc.isload(false);
              Get.snackbar(
                'حدث خطأ',
                'الرجاء التحقق من اتصالك بالإنترنت',
                backgroundColor: AppColor.BackGround3,
              );
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
