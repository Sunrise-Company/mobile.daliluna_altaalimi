import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';

class CustomCardSubjects extends StatelessWidget {
  final String nameImage;
  final String text;
  final void Function()? onTap;
  const CustomCardSubjects({
    super.key,
    required this.text,
    required this.onTap,
    required this.nameImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        getValueForScreenType<double>(context: context, mobile: 10, tablet: 20),
      ),
      width: getValueForScreenType<double>(
        context: context,
        mobile: Get.width * 0.17,
        tablet: Get.width * 0.20,
      ),
      height: getValueForScreenType<double>(
        context: context,
        mobile: Get.height * 0.16,
        tablet: Get.height * 0.20,
      ),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shadowColor: AppColor.SecondryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColor.BackGround,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: AppLink.image + "/" + nameImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => LoadingImage(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.DeepPurple,
                      fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 15,
                        tablet: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// اللي فوق بدن حذف
class SubjectListItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback? onTap;

  const SubjectListItem({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: getValueForScreenType<double>(
            context: context,
            mobile: 6,
            tablet: 12,
          ),
          horizontal: getValueForScreenType<double>(
            context: context,
            mobile: 10,
            tablet: 24,
          ),
        ),
        padding: EdgeInsets.all(
          getValueForScreenType<double>(
            context: context,
            mobile: 8,
            tablet: 16,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.PrimaryColor,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                AppLink.image + "/" + imageUrl,
                width: getValueForScreenType<double>(
                  context: context,
                  mobile: 50,
                  tablet: 80,
                ),
                height: getValueForScreenType<double>(
                  context: context,
                  mobile: 50,
                  tablet: 80,
                ),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: getValueForScreenType<double>(
                      context: context,
                      mobile: 50,
                      tablet: 80,
                    ),
                    height: getValueForScreenType<double>(
                      context: context,
                      mobile: 50,
                      tablet: 80,
                    ),
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white70,
                      size: 30,
                    ),
                  );
                },
              ),
            ),

            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: Image.network(
            //     AppLink.image + "/" + imageUrl,
            //     width: getValueForScreenType<double>(
            //         context: context, mobile: 50, tablet: 80),
            //     height: getValueForScreenType<double>(
            //         context: context, mobile: 50, tablet: 80),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            SizedBox(
              width: getValueForScreenType<double>(
                context: context,
                mobile: 12,
                tablet: 24,
              ),
            ),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: getValueForScreenType<double>(
                    context: context,
                    mobile: 14,
                    tablet: 20,
                  ),
                  fontWeight: FontWeight.w600,
                  color: AppColor.DeepPurple,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: getValueForScreenType<double>(
                context: context,
                mobile: 16,
                tablet: 20,
              ),
              color: AppColor.SecondryColor,
            ),
          ],
        ),
      ),
    );
  }
}
