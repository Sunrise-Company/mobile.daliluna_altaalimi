import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/imageasset.dart';
import 'package:lottie/lottie.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});
  void _launchUpdateUrl() async {
    const url = '${AppLink.baseUrl}/public/ArabicAcademic.apk';
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.BackGround2,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            getValueForScreenType<double>(
              context: context,
              mobile: 80,
              tablet: 120,
            ),
          ),
          child: AppBar(
            backgroundColor: AppColor.PrimaryColor,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(
                  getValueForScreenType<double>(
                    context: context,
                    mobile: 40,
                    tablet: 60,
                  ),
                ),
              ),
            ),
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.asset(
                  AppImageAsset.newLogoWithoutBackground,
                  height: getValueForScreenType<double>(
                    context: context,
                    mobile: 60,
                    tablet: 90,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(
            getValueForScreenType<double>(
              context: context,
              mobile: 30,
              tablet: 50,
            ),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(
                getValueForScreenType<double>(
                  context: context,
                  mobile: 25,
                  tablet: 50,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColor.White,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.PrimaryColor.withOpacity(0.5),
                    blurRadius: 7,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.system_update,
                    size: 60,
                    color: AppColor.SecondryColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'تم إصدار نسخة جديدة من التطبيق.',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.SecondryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'يرجى تحديث التطبيق للاستمرار في استخدامه.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _launchUpdateUrl,
                    icon: Icon(Icons.open_in_new, color: Colors.white),
                    label: Text(
                      'تحديث الآن',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.PrimaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      textStyle: TextStyle(fontSize: 16),
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
}
