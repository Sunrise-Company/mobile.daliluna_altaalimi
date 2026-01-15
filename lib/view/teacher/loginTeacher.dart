// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:get/get.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:daliluna_altaalimi/core/constant/color.dart';
// import 'package:daliluna_altaalimi/core/constant/routes.dart';
// import 'package:daliluna_altaalimi/view/widget/custombuttomauth.dart';
// import 'package:daliluna_altaalimi/view/widget/customtextauth.dart';
// import 'package:daliluna_altaalimi/view/widget/customtextfromfield.dart';
// import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';
// import '../../controller/teacherController/loginTeacherController.dart';
//
// class LoginTeacher extends StatelessWidget {
//   LoginControllerss controller = Get.put(LoginControllerss());
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: AppColor.BackGround2,
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(
//             getValueForScreenType<double>(
//               context: context,
//               mobile: 120,
//               tablet: 210,
//             ),
//           ),
//           child: Stack(
//             children: [
//               ClipPath(
//                 clipper: WaveClipperOne(),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: AppColor.PrimaryColor,
//                     gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: <Color>[
//                           AppColor.DeepPurple,
//                           AppColor.SecondryColor2
//                         ]),
//                   ),
//                   height: getValueForScreenType<double>(
//                     context: context,
//                     mobile: 150,
//                     tablet: 300,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: ListTile(
//                   title: Center(
//                       child: Text(
//                     "تسجيل الدخول",
//                     style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: getValueForScreenType<double>(
//                           context: context,
//                           mobile: 20,
//                           tablet: 25,
//                         ),
//                         color: AppColor.PrimaryColor),
//                   )),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: Obx(
//           () => controller.load.value == true
//               ? LoadingImage()
//               : SingleChildScrollView(
//                   child: Container(
//                     padding: EdgeInsets.all(
//                       getValueForScreenType<double>(
//                         context: context,
//                         mobile: 25,
//                         tablet: 50,
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: getValueForScreenType<double>(
//                             context: context,
//                             mobile: 20,
//                             tablet: 40,
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.all(
//                             getValueForScreenType<double>(
//                               context: context,
//                               mobile: 30,
//                               tablet: 60,
//                             ),
//                           ),
//                           decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: AppColor.PrimaryColor.withOpacity(0.5),
//                                   blurRadius: 7,
//                                   spreadRadius: 5,
//                                 ),
//                               ],
//                               gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: <Color>[
//                                     AppColor.BackGround,
//                                     AppColor.White
//                                   ]),
//                               color: AppColor.BackGround,
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                   color: Colors.transparent, width: 1)),
//                           child: Form(
//                             key: controller.formstateteacher,
//                             child: Column(
//                               children: [
//                                 CustomTextFromFields(
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.allow(
//                                           RegExp(r'^\+?\d{0,12}'))
//                                     ],
//                                     readOnly: false,
//                                     keyboardType: TextInputType.phone,
//                                     label: "  رقم الموبايل",
//                                     validator: (val) {
//                                       if (val!.isEmpty) {
//                                         return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ ";
//                                       }
//
//                                       // if (val.length < 10) {
//                                       //   return "لا يمكن أن يكون أقل من 10";
//                                       // }
//
//                                       // if (val.length > 30) {
//                                       //   return "لا يمكن أن يكون أكبر من 30";
//                                       // }
//                                     },
//                                     preIcon: Icons.phone_android,
//                                     controller: controller.emailcontrooelr),
//                                 SizedBox(
//                                   height: getValueForScreenType<double>(
//                                     context: context,
//                                     mobile: 40,
//                                     tablet: 80,
//                                   ),
//                                 ),
//                                 GetBuilder<LoginControllerss>(
//                                   builder: (controller) => CustomTextFromFields(
//                                       readOnly: false,
//                                       inputFormatters: [
//                                         FilteringTextInputFormatter.allow(
//                                             RegExp(r'^[a-zA-Z_0-9-]+$'))
//                                       ],
//                                       keyboardType:
//                                           TextInputType.visiblePassword,
//                                       obscureText: controller.isshowpassword,
//                                       onTap: () {
//                                         controller.showPassword();
//                                       },
//                                       validator: (val) {
//                                         if (val!.isEmpty) {
//                                           return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ ";
//                                         }
//                                       },
//                                       label: "كلمة المرور",
//                                       preIcon: Icons.lock,
//                                       sufIcon: controller.isshowpassword == true
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                       controller: controller.passwordcontroler),
//                                 ),
//                                 SizedBox(
//                                   height: getValueForScreenType<double>(
//                                     context: context,
//                                     mobile: 15,
//                                     tablet: 30,
//                                   ),
//                                 ),
//                                 GetBuilder<LoginControllerss>(
//                                   builder: (controller) => CustomButtomAuth(
//                                     text: "تسجيل الدخول",
//                                     onTap: () {
//                                       if (controller
//                                           .formstateteacher.currentState!
//                                           .validate()) {
//                                         controller.login();
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: getValueForScreenType<double>(
//                             context: context,
//                             mobile: 40,
//                             tablet: 60,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../controller/teacherController/loginTeacherController.dart';
import '../../core/constant/color.dart';
import '../../core/constant/imageasset.dart';
import '../widget/custombuttomauth.dart';
import '../widget/customtextfromfield.dart';
import '../widget/loadingimage.dart';

class LoginTeacher extends StatelessWidget {
  LoginControllerss controller = Get.put(LoginControllerss());
  Widget build(BuildContext context) {
    return Form(
      key: controller.formstateteacher,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    child: Container(
                      decoration: BoxDecoration(color: AppColor.SecondryColor2),

                      width: MediaQuery.of(context).size.width,
                      height: 370,
                    ),
                    clipper: CustomClipPath(),
                  ),
                  ClipPath(
                    child: Container(
                      decoration: BoxDecoration(color: AppColor.PrimaryColor),
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      child: Column(
                        children: [
                          SizedBox(height: 100),
                          CircleAvatar(
                            backgroundImage: AssetImage(AppImageAsset.newLogo),
                            radius: 80,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "أهلاً بعودتك ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    clipper: CustomClipPath(),
                  ),
                ],
              ),

              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: getValueForScreenType<double>(
                            context: context,
                            mobile: 30,
                            tablet: 60,
                          ),
                        ),
                        CustomTextFromFields(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\+?\d{0,12}'),
                            ),
                          ],
                          readOnly: false,
                          keyboardType: TextInputType.phone,
                          label: "  رقم الموبايل",
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ ";
                            }

                            // if (val.length < 10) {
                            //   return "لا يمكن أن يكون أقل من 10";
                            // }

                            if (val.length > 30) {
                              return "لا يمكن أن يكون أكبر من 30";
                            }
                            return null;
                          },
                          preIcon: Icons.phone_android,
                          controller: controller.emailcontrooelr,
                        ),
                        SizedBox(
                          height: getValueForScreenType<double>(
                            context: context,
                            mobile: 40,
                            tablet: 80,
                          ),
                        ),

                        GetBuilder<LoginControllerss>(
                          builder: (controller) => CustomTextFromFields(
                            readOnly: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z_0-9-]+$'),
                              ),
                            ],
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: controller.isshowpassword,
                            onTap: () {
                              controller.showPassword();
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ ";
                              }
                            },
                            label: "كلمة المرور",
                            preIcon: Icons.lock,
                            sufIcon: controller.isshowpassword == true
                                ? Icons.visibility_off
                                : Icons.visibility,
                            controller: controller.passwordcontroler,
                          ),
                        ),

                        SizedBox(
                          height: getValueForScreenType<double>(
                            context: context,
                            mobile: 45,
                            tablet: 60,
                          ),
                        ),

                        GetBuilder<LoginControllerss>(
                          builder: (controller) => controller.load.value
                              ? const Center(child: LoadingImage())
                              : defaultButton(
                                  context: context,
                                  text: "تسجيل الدخول",
                                  fun: () {
                                    if (controller
                                        .formstateteacher
                                        .currentState!
                                        .validate()) {
                                      controller.login();
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var cornerRadius = 200.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - cornerRadius);
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);
    path.lineTo(size.width - cornerRadius, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - cornerRadius,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
