import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomCardMyCourseLesson extends StatelessWidget {
  final String lesson;
  final String detailsLesson;
  final void Function()? onTap;
  const CustomCardMyCourseLesson({
    super.key,
    required this.lesson,
    required this.detailsLesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.White,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColor.SecondryColor2.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SizedBox(
            height: 150,
            width: 100,
            child: Card(
              color: AppColor.BackGround,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    lesson,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Flexible(
                    child: Text(detailsLesson, style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
