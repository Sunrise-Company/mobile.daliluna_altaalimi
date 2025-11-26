import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constant/imageasset.dart';

class CustomLogIn extends StatelessWidget {
  const CustomLogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(AppImageAsset.logo));
  }
}
