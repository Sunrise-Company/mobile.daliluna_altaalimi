import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/auth/login_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/view/widget/custombuttomauth.dart';
import 'package:daliluna_altaalimi/view/widget/customtextauth.dart';
import 'package:daliluna_altaalimi/view/widget/customtextfromfield.dart';
import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';

import '../../../core/constant/imageasset.dart';
import '../../teacher/loginTeacher.dart';
//
// class Login extends GetView<LoginController> {
//   const Login({super.key});
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
//         body: GetBuilder<LoginController>(
//           builder: (controller) => controller.load == true
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
//                             key: controller.formstate,
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
//                                       if (val.length < 10) {
//                                         return "لا يمكن أن يكون أقل من 10";
//                                       }
//
//                                       if (val.length > 30) {
//                                         return "لا يمكن أن يكون أكبر من 30";
//                                       }
//                                       return null;
//                                     },
//                                     preIcon: Icons.phone_android,
//                                     controller: controller.username),
//                                 SizedBox(
//                                   height: getValueForScreenType<double>(
//                                     context: context,
//                                     mobile: 40,
//                                     tablet: 80,
//                                   ),
//                                 ),
//                                 GetBuilder<LoginController>(
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
//
//                                         if (val.length < 8) {
//                                           return "لا يمكن أن يكون أقل من 8";
//                                         }
//
//                                         if (val.length > 30) {
//                                           return "لا يمكن أن يكون أكبر من 30";
//                                         }
//                                         return null;
//                                       },
//                                       label: "كلمة المرور",
//                                       preIcon: Icons.lock,
//                                       sufIcon: controller.isshowpassword == true
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                       controller: controller.password),
//                                 ),
//                                 SizedBox(
//                                   height: getValueForScreenType<double>(
//                                     context: context,
//                                     mobile: 15,
//                                     tablet: 30,
//                                   ),
//                                 ),
//                                 GetBuilder<LoginController>(
//                                   builder: (controller) => CustomButtomAuth(
//                                     text: "تسجيل الدخول",
//                                     onTap: () {
//                                       if (controller.formstate.currentState!
//                                           .validate()) {
//                                         controller.login();
//                                       }
//                                     },
//                                   ),
//                                 ),
//                                 Obx(() => Text(
//                                       controller.message.toString(),
//                                       style: TextStyle(
//                                           color: AppColor.SecondryColor,
//                                           fontWeight: FontWeight.bold),
//                                     )),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       " لديك حساب مدرس؟  ",
//                                     ),
//                                     InkWell(
//                                         onTap: () {
//                                           Get.to(LoginTeacher());
//                                         },
//                                         child: Text(
//                                           'سجل دخول',
//                                           style: TextStyle(
//                                               color: AppColor.SecondryColor,
//                                               fontWeight: FontWeight.bold),
//                                         ))
//                                   ],
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
//                         CustomTextAuth(
//                           details: "اذا كنت لا تمتلك حساب",
//                           auth: "إنشاء حساب",
//                           onTap: () {
//                             Get.toNamed(AppRoute.register);
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

class Login extends GetView<LoginController> {
  Widget build(BuildContext context) {
    return Form(
      key: controller.formstate,
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
                            mobile: 10,
                            tablet: 80,
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

                            if (val.length < 10) {
                              return "لا يمكن أن يكون أقل من 10";
                            }

                            if (val.length > 30) {
                              return "لا يمكن أن يكون أكبر من 30";
                            }
                            return null;
                          },
                          preIcon: Icons.phone_android,
                          controller: controller.username,
                        ),
                        SizedBox(
                          height: getValueForScreenType<double>(
                            context: context,
                            mobile: 40,
                            tablet: 80,
                          ),
                        ),
                        GetBuilder<LoginController>(
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

                              if (val.length < 8) {
                                return "لا يمكن أن يكون أقل من 8";
                              }

                              if (val.length > 30) {
                                return "لا يمكن أن يكون أكبر من 30";
                              }
                              return null;
                            },
                            label: "كلمة المرور",
                            preIcon: Icons.lock,
                            sufIcon: controller.isshowpassword == true
                                ? Icons.visibility_off
                                : Icons.visibility,
                            controller: controller.password,
                          ),
                        ),
                        SizedBox(
                          height: getValueForScreenType<double>(
                            context: context,
                            mobile: 30,
                            tablet: 60,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              " لديك حساب مدرس؟  ",
                              style: TextStyle(
                                fontSize: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 14,
                                  tablet: 20,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(LoginTeacher());
                              },
                              child: Text(
                                'سجل دخول',
                                style: TextStyle(
                                  fontSize: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 14,
                                    tablet: 20,
                                  ),
                                  color: AppColor.SecondryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getValueForScreenType<double>(
                            context: context,
                            mobile: 25,
                            tablet: 40,
                          ),
                        ),
                        GetBuilder<LoginController>(
                          builder: (controller) => controller.load
                              ? const Center(child: LoadingImage())
                              : defaultButton(
                                  context: context,
                                  text: "تسجيل الدخول",
                                  fun: () {
                                    if (controller.formstate.currentState!
                                        .validate()) {
                                      controller.login();
                                    }
                                  },
                                ),
                        ),
                        SizedBox(
                          height: getValueForScreenType<double>(
                            context: context,
                            mobile: 25,
                            tablet: 40,
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              " اذا كنت لا تمتلك حساب؟",
                              style: TextStyle(
                                fontSize: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 14,
                                  tablet: 20,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRoute.register);
                              },
                              child: Text(
                                "إنشاء حساب",
                                style: TextStyle(
                                  fontSize: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 14,
                                    tablet: 20,
                                  ),
                                  color: AppColor.SecondryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
