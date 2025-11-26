import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_builder/responsive_builder.dart';


import '../../controller/basket_controller.dart';
import '../../controller/teacherController/loginTeacherController.dart';
import '../../core/constant/color.dart';
import '../../core/constant/imageasset.dart';
import '../../core/constant/routes.dart';
import '../../core/function/alertinfocompany.dart';
import '../teacher/teacherprofile.dart';

Widget customDrawerTeacher(BuildContext context){
  LoginControllerss loginControlle = Get.put(LoginControllerss());
  late BasketController baskerc;
  baskerc = Get.put(BasketController());
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


           Column(
            children: [
              GetBuilder<BasketController>(
                builder: (controller) => Center(
                  child: GestureDetector(
                    onTap: () {
                      alertInfoCompany(
                        baskerc.companyInformations['app_company_informations']['description']
                            .toString(),
                        baskerc.companyInformations['app_company_informations']['title']
                            .toString(),
                        baskerc.companyInformations['app_company_informations']['facebook']
                            .toString(),
                        baskerc.companyInformations['app_company_informations']['website']
                            .toString(),
                      );
                    },
                    child: Text(
                      'By SunriseIt',
                      style: TextStyle(
                        color: AppColor.PrimaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
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
              Divider(color: AppColor.black,),
              ListTile(
                leading: Icon(

                       Icons.logout_rounded,

                  color: AppColor.PrimaryColor,
                  size: getValueForScreenType<double>(
                    context: context,
                    mobile: 25,
                    tablet: 40,
                  ),
                ),
                title: Text(

                      "تسجيل الخروج",

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
                  Get.back();
                  loginControlle.logoutTeacher();
                },
              ),
              Divider(color: AppColor.SecondaryColor,),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: AppColor.PrimaryColor,
                  size: getValueForScreenType<double>(
                    context: context,
                    mobile: 25,
                    tablet: 40,
                  ),
                ),
                title: Text(
                   "ملفي الشخصي",
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
                  Get.back();
                  Get.to(TeacherProfileWidget());
                },
              ),
              Divider(color: AppColor.SecondaryColor,),



            ],
          )

      ],
    ),
  );
}