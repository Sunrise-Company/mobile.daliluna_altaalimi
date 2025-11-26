import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomCardLessonOpened extends StatelessWidget {
  final String text;
  const CustomCardLessonOpened({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.BackGround2,
      elevation: 5,
      shadowColor: AppColor.SecondryColor,
      margin: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Text(text, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
