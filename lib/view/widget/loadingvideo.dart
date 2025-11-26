import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:daliluna_altaalimi/core/constant/imageasset.dart';

class LoadingVedio extends StatelessWidget {
  const LoadingVedio({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(AppImageAsset.loadingVideo));
  }
}
