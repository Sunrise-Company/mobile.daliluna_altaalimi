import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/imageasset.dart';
import 'package:daliluna_altaalimi/data/model/lesson.dart';
import 'package:daliluna_altaalimi/data/model/lessonopened.dart';
import 'package:daliluna_altaalimi/data/model/ourcourses.dart';
import 'package:daliluna_altaalimi/data/model/section.dart';
import 'package:daliluna_altaalimi/data/model/subject.dart';

List<OurCoursesModel> OurCoursesList = [
  OurCoursesModel(image: AppImageAsset.im, textIcon: "الثالث الثانوي العلمي"),
  OurCoursesModel(image: AppImageAsset.im5, textIcon: "الثالث الثانوي الأدبي"),
  OurCoursesModel(image: AppImageAsset.im3, textIcon: "الصف التاسع"),
  OurCoursesModel(image: AppImageAsset.im4, textIcon: "الثاني الثانوي"),
  OurCoursesModel(image: AppImageAsset.im2, textIcon: "الأول الثانوي"),
];

List<OurCoursesModel> MyCoursesList = [
  OurCoursesModel(image: AppImageAsset.im, textIcon: "الثالث الثانوي العلمي"),
  OurCoursesModel(image: AppImageAsset.im5, textIcon: "الثالث الثانوي الأدبي"),
  OurCoursesModel(image: AppImageAsset.im4, textIcon: "الثاني الثانوي"),
  OurCoursesModel(image: AppImageAsset.im2, textIcon: "الأول الثانوي"),
];

List<OurCoursesModel> SectionList = [
  OurCoursesModel(image: AppImageAsset.pic, textIcon: "الجلسات الامتحانية"),
  OurCoursesModel(image: AppImageAsset.pic2, textIcon: "أوراق العمل"),
  OurCoursesModel(image: AppImageAsset.pic3, textIcon: "المنهاج"),
  OurCoursesModel(image: AppImageAsset.pic4, textIcon: "التأسيس"),
  OurCoursesModel(image: AppImageAsset.pic, textIcon: "المكثفات"),
  OurCoursesModel(image: AppImageAsset.pic2, textIcon: "معلومات عن الاستاذ"),
];

List<OurCoursesModel> MyCourseSectionList = [
  OurCoursesModel(image: AppImageAsset.pic, textIcon: "الجلسات الامتحانية"),
  OurCoursesModel(image: AppImageAsset.pic2, textIcon: "أوراق العمل"),
  OurCoursesModel(image: AppImageAsset.pic3, textIcon: "المنهاج"),
  OurCoursesModel(image: AppImageAsset.pic4, textIcon: "التأسيس"),
  OurCoursesModel(image: AppImageAsset.pic, textIcon: "المكثفات"),
];

List<SectionModel> SectionSelectedList = [
  SectionModel(
    iconClip: Icons.language,
    price: "ل.س 500.000",
    textIcon: "اللغة الفرنسية",
  ),
  SectionModel(
    iconClip: Icons.engineering_outlined,
    price: "ل.س 400.000",
    textIcon: "اللغة الانكليزية",
  ),
  SectionModel(
    iconClip: Icons.flag,
    price: "ل.س 800.000",
    textIcon: "التربية الوطنية",
  ),
  SectionModel(
    iconClip: Icons.person,
    price: "ل.س 700.000",
    textIcon: "التربية الاسلامية",
  ),
  SectionModel(iconClip: Icons.cabin, price: "ل.س 500.000", textIcon: "العلوم"),
  SectionModel(
    iconClip: Icons.laptop_chromebook_outlined,
    price: "ل.س 900.000",
    textIcon: "الكيمياء",
  ),
  SectionModel(
    iconClip: Icons.calculate,
    price: "100.000 p.c",
    textIcon: "الرياضيات",
  ),
  SectionModel(
    iconClip: Icons.calendar_month_outlined,
    price: "ل.س 300.000",
    textIcon: "الفيزياء",
  ),
];

List<SubjectModel> SubjectsList = [
  SubjectModel(iconClip: Icons.language, textIcon: "اللغة الفرنسية"),
  SubjectModel(
    iconClip: Icons.engineering_outlined,
    textIcon: "اللغة الانكليزية",
  ),
  SubjectModel(iconClip: Icons.flag, textIcon: "التربية الوطنية"),
  SubjectModel(iconClip: Icons.person, textIcon: "التربية الاسلامية"),
  SubjectModel(iconClip: Icons.cabin, textIcon: "العلوم"),
  SubjectModel(
    iconClip: Icons.laptop_chromebook_outlined,
    textIcon: "الكيمياء",
  ),
  SubjectModel(iconClip: Icons.calculate, textIcon: "الرياضيات"),
  SubjectModel(iconClip: Icons.calendar_month_outlined, textIcon: "الفيزياء"),
];

List<SectionModel> UnitsSUbjectList = [
  SectionModel(
    iconClip: Icons.language,
    price: "ل.س 500.000",
    textIcon: "الوحدة الاولى",
  ),
  SectionModel(
    iconClip: Icons.engineering_outlined,
    price: "ل.س 400.000",
    textIcon: "الوحدة الثانية",
  ),
  SectionModel(
    iconClip: Icons.person,
    price: "ل.س 700.000",
    textIcon: "الوحدة الثالثة",
  ),
  SectionModel(
    iconClip: Icons.laptop_chromebook_outlined,
    price: "ل.س 900.000",
    textIcon: "الوحدة الرابعة",
  ),
  SectionModel(
    iconClip: Icons.calendar_month_outlined,
    price: "ل.س 300.000",
    textIcon: "الوحدة الخامسة",
  ),
];

List<LessonOpenedModel> LessonOpenedList = [
  LessonOpenedModel(text: "تأسيس 1"),
  LessonOpenedModel(text: "تأسيس 2"),
  LessonOpenedModel(text: "تأسيس 3"),
  LessonOpenedModel(text: "تأسيس 4"),
  LessonOpenedModel(text: "تأسيس 5"),
  LessonOpenedModel(text: "تأسيس 5"),
];

List<LessonOpenedModel> SubjectList = [
  LessonOpenedModel(text: "الوحدة الاولى"),
  LessonOpenedModel(text: "الوحدة الثانية"),
  LessonOpenedModel(text: "الوحدة الثالثة"),
];

List<OurCoursesModel> TeacherList = [
  OurCoursesModel(textIcon: "بتول النويلاتي", image: AppImageAsset.teacher3),
  OurCoursesModel(textIcon: "مازن الخطيب", image: AppImageAsset.teacher2),
  OurCoursesModel(textIcon: "نور المصري", image: AppImageAsset.teacher),
  OurCoursesModel(textIcon: "بتول النويلاتي", image: AppImageAsset.teacher3),
  OurCoursesModel(textIcon: "مازن الخطيب", image: AppImageAsset.teacher2),
  OurCoursesModel(textIcon: "نور المصري", image: AppImageAsset.teacher),
];

List<LessonModel> LessonList = [
  LessonModel(
    lesson: "الدرس الأول",
    detailsLesson: "ترشيحي لغة عربية",
    price: "ل.س 50.00000",
  ),
  LessonModel(
    lesson: "الدرس الثاني",
    detailsLesson: "ترشيحي لغة عربية",
    price: "ل.س 60.00000",
  ),
  LessonModel(
    lesson: "الدرس الثالث",
    detailsLesson: "ترشيحي لغة عربية",
    price: "ل.س 70.00000",
  ),
  LessonModel(
    lesson: "الدرس الرابع",
    detailsLesson: "ترشيحي لغة عربية",
    price: "ل.س 80.00000",
  ),
  LessonModel(
    lesson: "الدرس الخامس",
    detailsLesson: "ترشيحي لغة عربية",
    price: "ل.س 90.00000",
  ),
  LessonModel(
    lesson: "الدرس السادس",
    detailsLesson: "ترشيحي لغة عربية",
    price: "ل.س 20.00000",
  ),
];
