import 'package:flutter/material.dart';
// import 'package:gradients/gradients.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class ViewPdf extends StatelessWidget {
  const ViewPdf({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topCenter,
                colors: <Color>[AppColor.SecondryColor2, AppColor.DeepPurple],
              ),
            ),
          ),
          title: const Text("PDF"),
        ),
        backgroundColor: AppColor.BackGround2,
      ),
    );
  }
}
