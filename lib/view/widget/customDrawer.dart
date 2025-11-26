import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../controller/auth/login_controller.dart';
import '../../core/constant/color.dart';
import '../../core/constant/imageasset.dart';
import '../../core/constant/routes.dart';

Widget customDrawer(BuildContext context){
  LoginController logincontroller = Get.put(LoginController());
  logincontroller.checkIfLogin();
  return  Drawer(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Column(
      children: [

        DrawerHeader(
          decoration: BoxDecoration(
              color: AppColor.PrimaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40),)

          ),
          child: Row(

            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    AppImageAsset.backgroundCart),
                radius: 40,
              ),SizedBox(width: 30,),
              Text(
                'إعداداتي',

                style: TextStyle(

                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),

        Obx(() {
          return ListTile(
            leading: Icon(
              logincontroller.isLoginsuccess == true
                  ? Icons.logout_rounded
                  : Icons.login,
              color: AppColor.PrimaryColor,
              size: getValueForScreenType<double>(
                context: context,
                mobile: 25,
                tablet: 40,
              ),
            ),
            title: Text(
              logincontroller.isLoginsuccess == true
                  ? "تسجيل الخروج"
                  : "تسجيل الدخول",
              style: TextStyle(
                color: AppColor.PrimaryColor,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 14,
                  tablet: 20,
                ),
              ),
            ),
            onTap: () {
              Get.back(); // إغلاق الـ Drawer أولًا
              if (logincontroller.isLoginsuccess == true) {
                logincontroller.logout();
              } else {
                Get.toNamed(AppRoute.login);
              }
            },
          );
        }),
      ],
    ),
  );
}