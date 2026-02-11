import 'package:daliluna_altaalimi/controller/teacherController/teacherProfile.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constant/color.dart';
import '../widget/GetValueForScreen.dart';
import '../widget/customreadmore.dart';
import '../widget/customtitle.dart';
import '../widget/loading.dart';

class TeacherProfileWidget extends StatelessWidget {
  final TeacherProfileController teacherController = Get.put(
    TeacherProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            getValueForScreenType<double>(
              context: context,
              mobile: 55,
              tablet: 100,
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColor.PrimaryColor,
            title: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: AppColor.SecondryColor,
              child: Text(
                "الملف الشخصي ",
                style: TextStyle(
                  fontSize: responsiveValue(
                    context: context,
                    mobile: 20,
                    tablet: 35,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (teacherController.isLoading.value) return const Center(child: Loading());

          final image = teacherController.image.value;
          final name = teacherController.arabicName.value;
          final description = "${teacherController.description.value}";
          final education = teacherController.education.value;


          return ResponsiveBuilder(
            builder: (context, sizingInformation) {
              final isTablet =
                  sizingInformation.deviceScreenType == DeviceScreenType.tablet;

              final imageHeight = MediaQuery.of(context).size.height * 0.5;
              final borderRadius = isTablet ? 40.0 : 30.0;
              final horizontalPadding = isTablet ? 40.0 : 20.0;

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    /// ✅ صورة المدرس بالخلفية العلوية
                    Container(
                      height: imageHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            image.isNotEmpty
                                ? AppLink.image + "/" + image
                                : 'https://placehold.co/600x400',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: imageHeight - 40),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: isTablet ? 35 : 25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: const Offset(0, -2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// الاسم
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: responsiveValue(
                                context: context,
                                mobile: 20,
                                tablet: 30,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            height: responsiveValue(
                              context: context,
                              mobile: 20,
                              tablet: 30,
                            ),
                          ),

                          /// التعليم
                          if (education.isNotEmpty &&
                              education != 'تعليم غير متوفر')
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20 : 14,
                                vertical: isTablet ? 10 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.SecondryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: AppColor.SecondryColor,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                education,
                                style: TextStyle(
                                  color: AppColor.SecondryColor,
                                  fontSize: responsiveValue(
                                    context: context,
                                    mobile: 14,
                                    tablet: 20,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          const SizedBox(height: 25),

                          /// العنوان "الوصف"
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomTitle(text: "الوصف"),
                          ),
                          const SizedBox(height: 10),

                          /// نص الوصف (بشكل مختصر إذا طويل)
                          CustomReadMore(text: description),

                          const SizedBox(height: 25),

                          Obx(() {
                            if (teacherController.institutes.isEmpty) return SizedBox();

                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomTitle(text: "المعهد"),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: teacherController.institutes.map((inst) {
                                    String name = "";
                                    if (inst is String) {
                                      name = inst;
                                    } else if (inst is Map && inst['name'] != null) {
                                      name = inst['name'];
                                    }

                                    return Chip(label: Text(name));
                                  }).toList(),
                                ),
                                const SizedBox(height: 25),
                              ],
                            );
                          }),
                          Obx(() {
                            if (teacherController.classes.isEmpty) return SizedBox();

                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomTitle(text: "المواد"),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: teacherController.classes.map((cls) {
                                    String name = "";
                                    if (cls is String) {
                                      name = cls;
                                    } else if (cls is Map && cls['name'] != null) {
                                      name = cls['name'];
                                    }

                                    return Chip(label: Text(name));
                                  }).toList(),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
