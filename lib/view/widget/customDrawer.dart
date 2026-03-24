import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../controller/auth/login_controller.dart';
import '../../controller/home_controller.dart';
import '../../core/constant/color.dart';
import '../../core/constant/imageasset.dart';
import '../../core/constant/routes.dart';
import '../../core/services/apiservices.dart';

Widget customDrawer(BuildContext context) {
  LoginController logincontroller = Get.put(LoginController());
  logincontroller.checkIfLogin();
  HomeController homecontroller = Get.put(HomeController());
  return Drawer(
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
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(AppImageAsset.backgroundCart),
                radius: 40,
              ),
              SizedBox(width: 30),
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

        // زر حذف الحساب — يظهر فقط عند تسجيل الدخول وفي وضع المراجعة (isDeployed == 0)
        Obx(() {
          if (logincontroller.isLoginsuccess != true ||
              homecontroller.isDeployed == 1) {
            return SizedBox.shrink();
          }
          return ListTile(
            leading: Icon(
              Icons.delete_forever_rounded,
              color: Colors.red,
              size: getValueForScreenType<double>(
                context: context,
                mobile: 25,
                tablet: 40,
              ),
            ),
            title: Text(
              "حذف الحساب",
              style: TextStyle(
                color: Colors.red,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 14,
                  tablet: 20,
                ),
              ),
            ),
            onTap: () {
              Get.back(); // إغلاق الـ Drawer
              _showDeleteAccountDialog(context, logincontroller);
            },
          );
        }),
      ],
    ),
  );
}

void _showDeleteAccountDialog(
  BuildContext context,
  LoginController logincontroller,
) {
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool obscureText = true.obs;

  Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة تحذير
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.delete_forever_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "حذف الحساب",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "هذا الإجراء لا يمكن التراجع عنه.\nيرجى إدخال كلمة المرور للتأكيد.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 20),
            Obx(
              () => TextField(
                controller: passwordController,
                obscureText: obscureText.value,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: "كلمة المرور",
                  labelStyle: TextStyle(color: AppColor.PrimaryColor),
                  prefixIcon: IconButton(
                    icon: Icon(
                      obscureText.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColor.PrimaryColor,
                    ),
                    onPressed: () => obscureText.value = !obscureText.value,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Row(
                children: [
                  // زر إلغاء
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading.value ? null : () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColor.PrimaryColor),
                      ),
                      child: Text(
                        "إلغاء",
                        style: TextStyle(color: AppColor.PrimaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // زر حذف
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              final password = passwordController.text.trim();
                              if (password.isEmpty) {
                                Get.snackbar(
                                  "تنبيه",
                                  "الرجاء إدخال كلمة المرور",
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              isLoading.value = true;
                              final result = await ApiService.deleteAccount(
                                password,
                              );
                              isLoading.value = false;

                              if (result['status'] == true) {
                                Get.back(); // إغلاق الـ Dialog
                                Get.snackbar(
                                  "تم",
                                  result['message'],
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                                // تسجيل الخروج وإعادة التوجيه
                                await logincontroller.logout();
                              } else {
                                Get.snackbar(
                                  "خطأ",
                                  result['message'],
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading.value
                          ? SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text("حذف", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
