import 'package:url_launcher/url_launcher.dart';

void openGooglePlay() async {
  final String appPackageName = 'com.example.app'; // Replace with your app's package name

  // The URL scheme for opening the Google Play Store
  final String url = 'https://play.google.com/store/apps/details?id=$appPackageName';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}