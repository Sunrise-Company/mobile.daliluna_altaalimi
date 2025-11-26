import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:daliluna_altaalimi/core/constant/imageasset.dart';

import 'GetValueForScreen.dart';

class LoadingImage extends StatelessWidget {
  const LoadingImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: responsiveValue(context: context, mobile: 70, tablet: 120),
        height: responsiveValue(context: context, mobile: 70, tablet: 120),
        child: Lottie.asset(AppImageAsset.loadingImage),
      ),
    );
  }
}
