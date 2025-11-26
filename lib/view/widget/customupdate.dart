import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:daliluna_altaalimi/core/constant/imageasset.dart';

class Update extends StatelessWidget {
  const Update({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(AppImageAsset.update));
  }
}
