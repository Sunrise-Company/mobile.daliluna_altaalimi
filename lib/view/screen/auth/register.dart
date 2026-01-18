import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/auth/register_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/function/choosedate.dart';
import 'package:daliluna_altaalimi/view/widget/custombuttomauth.dart';
import 'package:daliluna_altaalimi/view/widget/customdropdownbutton.dart';
import 'package:daliluna_altaalimi/view/widget/customtextfromfield.dart';
import 'package:daliluna_altaalimi/view/widget/customtextontap.dart';
import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';

import '../../../core/constant/imageasset.dart';
import '../../widget/citySelector.dart';
import '../../widget/selectGender.dart';

class Register extends GetView<RegisterController> {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
    return Directionality(
      textDirection: TextDirection.rtl,
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
                      height: 300,
                    ),
                    clipper: CustomClipPath(),
                  ),
                  ClipPath(
                    child: Container(
                      decoration: BoxDecoration(color: AppColor.PrimaryColor),
                      width: MediaQuery.of(context).size.width,
                      height: 280,
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          CircleAvatar(
                            backgroundImage: AssetImage(AppImageAsset.newLogo),
                            radius: 80,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "إنشاء حساب ",
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
                child: Container(
                  padding: EdgeInsets.all(
                    getValueForScreenType<double>(
                      context: context,
                      mobile: 25,
                      tablet: 50,
                    ),
                  ),
                  child: GetBuilder<RegisterController>(
                    builder: (controller) => Form(
                      key: controller.formstate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFromFields(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ";
                              }

                              if (val.length < 3) {
                                return "لا يمكن أن يكون أقل من 3";
                              }

                              if (val.length > 50) {
                                return "لا يمكن أن يكون أكبر من 50";
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"^[\u0621-\u064A_ -]+"),
                              ),
                            ],
                            readOnly: false,
                            keyboardType: TextInputType.text,
                            label: "الاسم و الكنية باللغة العربية",
                            preIcon: Icons.text_fields_rounded,
                            controller: controller.usernameAr,
                          ),
                          SizedBox(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 30,
                              tablet: 60,
                            ),
                          ),
                          CustomTextFromFields(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ";
                              }

                              if (val.length < 3) {
                                return "لا يمكن أن يكون أقل من 3";
                              }

                              if (val.length > 50) {
                                return "لا يمكن أن يكون أكبر من 50";
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z_ -]+$'),
                              ),
                            ],
                            readOnly: false,
                            keyboardType: TextInputType.text,
                            label: "اسم المستخدم باللغة الانكليزية",
                            preIcon: Icons.abc_rounded,
                            controller: controller.usernameEn,
                          ),
                          SizedBox(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 30,
                              tablet: 60,
                            ),
                          ),
                          CustomTextFromFields(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ";
                              }

                              if (val.length < 3) {
                                return "لا يمكن أن يكون أقل من 3";
                              }

                              if (val.length > 50) {
                                return "لا يمكن أن يكون أكبر من 50";
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"^[\u0621-\u064A_ -]+"),
                              ),
                            ],
                            readOnly: false,
                            keyboardType: TextInputType.text,
                            label: "اسم الأم",
                            preIcon: Icons.person_2_rounded,
                            controller: controller.mothersName,
                          ),
                          SizedBox(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 30,
                              tablet: 60,
                            ),
                          ),
                          CustomTextFromFields(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ";
                              }

                              if (val.length < 3) {
                                return "لا يمكن أن يكون أقل من 3";
                              }

                              if (val.length > 50) {
                                return "لا يمكن أن يكون أكبر من 50";
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"^[\u0621-\u064A_ -]+"),
                              ),
                            ],
                            readOnly: false,
                            keyboardType: TextInputType.text,
                            label: "اسم الأب",
                            preIcon: Icons.person,
                            controller: controller.fathersName,
                          ),
                          SizedBox(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 30,
                              tablet: 60,
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.only(
                          //     right: getValueForScreenType<double>(
                          //       context: context,
                          //       mobile: 10,
                          //       tablet: 20,
                          //     ),
                          //   ),
                          //   height: getValueForScreenType<double>(
                          //     context: context,
                          //     mobile: 60,
                          //     tablet: 80,
                          //   ),
                          //   decoration: BoxDecoration(
                          //       color: AppColor.BackGround3,
                          //       border:
                          //       Border.all(color: AppColor.DeepPurple),
                          //       borderRadius: BorderRadius.circular(3)),
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         "الجنس",
                          //         style: TextStyle(
                          //           color: AppColor.DeepPurple,
                          //           fontSize: getValueForScreenType<double>(
                          //             context: context,
                          //             mobile: 13,
                          //             tablet: 17,
                          //           ),
                          //         ),
                          //       ),
                          //       GetBuilder<RegisterController>(
                          //         builder: (controller) {
                          //           return Expanded(
                          //             child: RadioListTile(
                          //               activeColor: AppColor.SecondryColor,
                          //               title: Text(
                          //                 "ذكر",
                          //                 style: TextStyle(
                          //                   fontSize:
                          //                   getValueForScreenType<double>(
                          //                     context: context,
                          //                     mobile: 12,
                          //                     tablet: 17,
                          //                   ),
                          //                   color: AppColor.PrimaryColor,
                          //                 ),
                          //               ),
                          //               value: "ذكر",
                          //               groupValue: controller.gender,
                          //               onChanged: (value) {
                          //                 controller
                          //                     .onClickRadioButton(value);
                          //               },
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //       GetBuilder<RegisterController>(
                          //         builder: (controller) {
                          //           return Expanded(
                          //             child: RadioListTile(
                          //               activeColor: AppColor.DeepPurple,
                          //               title: Text(
                          //                 "أنثى",
                          //                 style: TextStyle(
                          //                   fontSize:
                          //                   getValueForScreenType<double>(
                          //                     context: context,
                          //                     mobile: 12,
                          //                     tablet: 17,
                          //                   ),
                          //                   color: AppColor.PrimaryColor,
                          //                 ),
                          //               ),
                          //               value: "أنثى",
                          //               groupValue: controller.gender,
                          //               onChanged: (value) {
                          //                 controller
                          //                     .onClickRadioButton(value);
                          //               },
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          GenderSelector(),
                          SizedBox(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 30,
                              tablet: 60,
                            ),
                          ),
                          // Obx(
                          //       () => CustomDropDown(
                          //       value: controller
                          //           .countryselectedValue.value.isNotEmpty
                          //           ? controller.countryselectedValue.value
                          //           : null,
                          //       onChanged: (newValue) {
                          //         controller.updateSelectedValue(newValue!);
                          //       },
                          //       items: [
                          //         'دمشق',
                          //         'ريف دمشق',
                          //         'اللاذقية',
                          //         'السويداء',
                          //         'حمص',
                          //         'حلب',
                          //         'درعا',
                          //         'دير الزور',
                          //         'حماة',
                          //         'الحسكة',
                          //         'ادلب',
                          //         'القنيطرة',
                          //         'الرقة',
                          //         'طرطوس',
                          //       ]),
                          // ),
                          CitySelector(),
                          SizedBox(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 30,
                              tablet: 60,
                            ),
                          ),
                          GetBuilder<RegisterController>(
                            builder: (controller) => CustomTextFromFields(
                              readOnly: true,
                              showCursor: false,
                              onTapFun: () async {
                                await selectDate(
                                  context,
                                  controller.selectedDate,
                                  controller.birthday,
                                );
                              },
                              keyboardType: TextInputType.text,
                              label: "تاريخ الميلاد",
                              preIcon: Icons.date_range_rounded,
                              controller: controller.birthday,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 30,
                              tablet: 60,
                            ),
                          ),
                          CustomTextFromFields(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ";
                              }

                              if (val.length < 5) {
                                return "لا يمكن أن يكون أقل من 5";
                              }

                              if (val.length > 50) {
                                return "لا يمكن أن يكون أكبر من 50";
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"^[\u0621-\u064A_ -]+"),
                              ),
                            ],
                            readOnly: false,
                            keyboardType: TextInputType.text,
                            label: "العنوان",
                            preIcon: Icons.location_city_rounded,
                            controller: controller.address,
                          ),
                          SizedBox(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 30,
                              tablet: 60,
                            ),
                          ),
                          GetBuilder<RegisterController>(
                            builder: (controller) => CustomTextFromFields(
                              inputFormatters: [
                                // FilteringTextInputFormatter.allow(
                                //   RegExp(r'^[a-zA-Z_0-9-]+$'),
                                // ),
                              ],
                              readOnly: false,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: controller.isshowpassword,
                              onTap: () {
                                controller.showPassword();
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "هذا الحقل مطلوب ولا يمكن أن يكون فارغ";
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
                          GetBuilder<RegisterController>(
                            builder: (controller) => CustomTextFromFields(
                              readOnly: false,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: controller.isshowconfirmPassword,
                              onTap: () {
                                controller.showconfirmPassword();
                              },
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(
                              //     RegExp(r'^[a-zA-Z_0-9-]+$'),
                              //   ),
                              // ],
                              validator: (val) {
                                if (val != controller.password.text) {
                                  return "تأكيد كلمة المرور غير مطابقة لكلمة المرور";
                                }
                                return null;
                              },
                              label: "تأكيد كلمة المرور",
                              preIcon: Icons.lock,
                              sufIcon: controller.isshowconfirmPassword == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              controller: controller.confirmPassword,
                            ),
                          ),
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
                            label: "رقم الهاتف",
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
                            preIcon: Icons.phone_android_rounded,
                            controller: controller.phone,
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
                                "أوافق على ",
                                style: TextStyle(
                                  color: AppColor.PrimaryColor,
                                  fontSize: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 13,
                                    tablet: 17,
                                  ),
                                ),
                              ),
                              CustomTextOnTap(
                                text: "سياسة الخصوصية",
                                onTap: () {
                                  controller.goToPrivacyPolicy();
                                },
                              ),
                              GetBuilder<RegisterController>(
                                builder: (controller) => Transform.scale(
                                  scale: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 1,
                                    tablet: 2,
                                  ),
                                  child: Checkbox(
                                    side: BorderSide(
                                      color: AppColor.SecondryColor,
                                      width: getValueForScreenType<double>(
                                        context: context,
                                        mobile: 1.5,
                                        tablet: 2,
                                      ),
                                    ),
                                    activeColor: AppColor.DeepPurple,
                                    value: controller.isChecked,
                                    onChanged: (value) {
                                      controller.toggleCheckbox(value!);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getValueForScreenType<double>(
                              context: context,
                              mobile: 20,
                              tablet: 40,
                            ),
                          ),
                          controller.load
                              ? const Center(child: LoadingImage())
                              : defaultButton(
                                  context: context,
                                  text: "إنشاء الحساب",
                                  fun: () {
                                    controller.getDeviceDetails();
                                    if (controller.formstate.currentState!
                                        .validate()) {
                                      // alertRegister();
                                      if (controller
                                          .countryselectedValue
                                          .isEmpty) {
                                        Get.defaultDialog(
                                          backgroundColor: AppColor.BackGround2,
                                          title: 'تنبيه',
                                          titleStyle: TextStyle(
                                            color: AppColor.DeepPurple,
                                          ),
                                          content: Text(
                                            'الرجاء اختيار المحافظة',
                                            style: TextStyle(
                                              color: AppColor.PrimaryColor,
                                            ),
                                          ),
                                        );
                                      } else if (controller.gender == null) {
                                        Get.defaultDialog(
                                          backgroundColor: AppColor.BackGround2,
                                          title: 'تنبيه',
                                          titleStyle: TextStyle(
                                            color: AppColor.DeepPurple,
                                          ),
                                          content: Text(
                                            'الرجاء اختيار الجنس',
                                            style: TextStyle(
                                              color: AppColor.PrimaryColor,
                                            ),
                                          ),
                                        );
                                      } else if (controller.isChecked ==
                                          false) {
                                        Get.defaultDialog(
                                          backgroundColor: AppColor.BackGround2,
                                          title: 'تنبيه',
                                          titleStyle: TextStyle(
                                            color: AppColor.DeepPurple,
                                          ),
                                          middleTextStyle: TextStyle(
                                            color: AppColor.PrimaryColor,
                                          ),
                                          middleText:
                                              'اذا كنت موافق على سياسة الخصوصية الخاصة بتطبيقنا الرجاء وضع الموافقة',
                                        );
                                      } else {
                                        controller.register();
                                      }
                                    }
                                  },
                                ),
                        ],
                      ),
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
