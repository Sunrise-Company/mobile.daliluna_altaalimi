// import 'package:daliluna_altaalimi/linkapi.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class policyController extends GetxController {
//   var isScroll = false.obs;
//   var noPolicyContent = false.obs;
//   var content = ''.obs;
//   var isConnection = true.obs;
//   var isPolicy = 0.obs;

//   var boolValue = true.obs;
//   final ScrollController scrollcontroller = ScrollController();

//   @override
//   void onInit() {
//     getPolicy();
//     fetchPolicyContent();
//     super.onInit();
//   }

//   Future fetchPolicyContent() async {
//     try {
//       var url = Uri.parse("${AppLink.server}/fetchPolicyContent");
//       var response = await http.get(url);
//       if (response.statusCode == 200) {
//         var body = '';
//         if (response.body != '0') {
//           body = response.body;
//         }

//         if (response.body == '0') {
//           noPolicyContent(true);
//         } else {
//           content(body as String);
//         }
//       } else {
//         return "error";
//       }
//     } catch (e) {
//       print('ppppppppppppppppppp');
//       isConnection(false);
//       Get.snackbar('تنبيه', "لا يوجد اتصال بالانترنت",
//           dismissDirection: DismissDirection.startToEnd,
//           duration: Duration(minutes: 10),
//           mainButton: TextButton(
//             onPressed: () {
//               Get.closeCurrentSnackbar();

//               fetchPolicyContent();
//             },
//             child: Text(
//               'إعادة',
//               style: TextStyle(color: Colors.red),
//             ),
//           ));
//     }
//   }

//   acceptPolicy() async {
//     print('---------------------------------------------');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('boolValue', true);
//     boolValue(true);
//     isPolicy(1);

//     print('gooooooooooooooo');
//     Get.offNamed('/checkAuth');
//   }

//   getPolicy() async {
//     print('policyControllerrrr');
//     print('4444444444444444444444');
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     if (prefs.getBool('boolValue') != null) {
//       print('uuuuuuuuuuuuuuu');
//       boolValue(prefs.getBool('boolValue')!);
//       print(boolValue);
//     } else {
//       boolValue(false);
//     }
//     print('checkkkkkkkkk');
//     print(boolValue);
//   }
// }
