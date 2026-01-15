import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeOutBack),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeIn));

    animController.forward();

    // (اختياري) الانتقال التلقائي بعد 4 ثواني
    // Future.delayed(const Duration(seconds: 4), () {
    //   Get.offNamed('/home');
    // });
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }
}
