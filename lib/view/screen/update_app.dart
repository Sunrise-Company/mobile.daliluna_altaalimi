import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});
  void _launchUpdateUrl() async {
    const url = 'https://arabicacademic.com/public/ArabicAcademic.apk';
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
              mobile: 120,
              tablet: 210,
            ),
          ),
          child: Stack(
            children: [
              ClipPath(
                clipper: WaveClipperOne(),
                child: Container(
                  height: getValueForScreenType<double>(
                    context: context,
                    mobile: 150,
                    tablet: 300,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.DeepPurple, AppColor.SecondryColor2],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Center(
                child: ListTile(
                  title: Center(
                    child: Text(
                      "تحديث التطبيق",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 20,
                          tablet: 26,
                        ),
                        color: AppColor.PrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
