import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateApp extends StatelessWidget {
  const UpdateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'images/logo.png',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text('يوجد تحديث جديد للتطبيق انقر على الزر'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        launchUrlString(
                          "market://details?id=com.bayanschool.bayanschool",
                        );
                      },
                      child: Text('تنزيل'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
