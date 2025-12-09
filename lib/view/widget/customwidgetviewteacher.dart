import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/linkapi.dart';

import '../../controller/basket_controller.dart';
import '../../controller/teacher_controller.dart';

// import '../../controller/teacherController/teacherProfile.dart';

class CustomWidgetViewTeacher extends StatelessWidget {
  final String name;
  final String assetName;
  final void Function()? onTap;
  const CustomWidgetViewTeacher({
    super.key,
    required this.name,
    required this.assetName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.SecondryColor,
            width: getValueForScreenType<double>(
              context: context,
              mobile: 1,
              tablet: 2,
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topCenter,
            colors: <Color>[AppColor.SecondryColor2, AppColor.BackGround],
          ),
        ),
        padding: EdgeInsets.all(
          getValueForScreenType<double>(
            context: context,
            mobile: 10,
            tablet: 20,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: AppColor.White,
              maxRadius: getValueForScreenType<double>(
                context: context,
                mobile: 75,
                tablet: 125,
              ),
              backgroundImage: NetworkImage(AppLink.image + "/" + assetName),
            ),
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: getValueForScreenType<double>(
                    context: context,
                    mobile: 12,
                    tablet: 18,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget DisplayTeacher(
  int index,
  dynamic teacher,
  BuildContext context,
  void Function()? onTap,
) {
  TeacherController controller = Get.put(TeacherController());

  late BasketController baskerc;
  baskerc = Get.put(BasketController());

  return AnimationConfiguration.staggeredList(
    position: index,
    duration: Duration(milliseconds: 500),
    child: SlideAnimation(
      horizontalOffset: 100,
      duration: Duration(milliseconds: 600),
      child: FadeInAnimation(
        child: InkWell(
          // onTap: () {
          //   baskerc.updateteacherName(teacher['name']);
          //   baskerc.updateteacherId(teacher['id'].toString());
          //   controller.goToSections(
          //     Get.arguments['subjetcsid'].toString(),
          //     teacher['id'].toString(),
          //     Get.arguments['classid'],
          //   );
          // },
          onTap: onTap,
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: AppColor.PrimaryColor,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child:
                        teacher['image'] != null &&
                            teacher['image'] != "-" &&
                            teacher['image'].toString().isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: AppLink.image + "/" + teacher['image'],
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[400],
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[400],
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: getValueForScreenType<double>(
                        context: context,
                        mobile: 5,
                        tablet: 10,
                      ),
                    ),
                    child: Text(
                      teacher['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 14,
                          tablet: 24,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppColor.PrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
