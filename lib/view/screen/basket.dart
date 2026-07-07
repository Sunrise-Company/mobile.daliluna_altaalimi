// ignore_for_file: must_be_iacademyv3utable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/basket_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/function/alertpaidMethod.dart';
import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/home_controller.dart';
import '../../core/constant/imageasset.dart';
import '../widget/GetValueForScreen.dart';

// ignore: must_be_immutable
class Basket extends StatelessWidget {
  Basket({super.key});
  late BasketController baskerc;

  @override
  Widget build(BuildContext context) {
    baskerc = Get.put(BasketController());
    final homeController = Get.put(HomeController());

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
                "السلة",
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
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(
        //     getValueForScreenType<double>(
        //       context: context,
        //       mobile: 55,
        //       tablet: 100,
        //     ),
        //   ),
        //   child: AppBar(
        //     leading: CustomIconAppBar(),
        //     actions: [
        //       Padding(
        //           padding: EdgeInsets.all(
        //             getValueForScreenType<double>(
        //               context: context,
        //               mobile: 8,
        //               tablet: 10,
        //             ),
        //           ),
        //           child: baskerc.count != 0
        //               ? ElevatedButton(
        //                   style: ButtonStyle(
        //                       backgroundColor: MaterialStatePropertyAll(
        //                           AppColor.PrimaryColor)),
        //                   onPressed: () {
        //                     // Obx(()=>
        //                     // // baskerc.isload.value?
        //                     print(baskerc.dataList['name']);
        //                     print(baskerc.dataList['phone']);
        //                     alertPaidMethod(baskerc.dataList['name'],
        //                         baskerc.dataList['phone']);
        //                   },
        //                   child: Obx(() {
        //                     return Row(
        //                       children: [
        //                         Text(
        //                           "المجموع" + "  " + baskerc.count.toString(),
        //                           style: TextStyle(
        //                             color: AppColor.White,
        //                             fontSize: getValueForScreenType<double>(
        //                               context: context,
        //                               mobile: 11,
        //                               tablet: 15,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     );
        //                   }))
        //               // :Center(child:CircularProgressIndicator())
        //
        //               : Text('')),
        //     ],
        //     title: Text(
        //       "مشترياتي",
        //       style: TextStyle(
        //         color: AppColor.White,
        //         fontSize: getValueForScreenType<double>(
        //           context: context,
        //           mobile: 20,
        //           tablet: 30,
        //         ),
        //       ),
        //     ),
        //     elevation: 0,
        //     flexibleSpace: Container(
        //       decoration: const BoxDecoration(
        //         gradient: LinearGradientPainter(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomRight,
        //           colors: <Color>[AppColor.DeepPurple, AppColor.PrimaryColor],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.4,
              child: Image.asset(
                height: double.infinity,
                width: double.infinity,
                AppImageAsset.backgroundCart, // غيّري المسار حسب صورتك
              ),
            ),

            Column(
              children: [
                Expanded(
                  child: Obx(
                    () => baskerc.isload == true
                        ? LoadingImage()
                        : baskerc.mycart.isEmpty
                        ? Text(
                            "لا يوجد لديك مشتريات",
                            style: TextStyle(
                              fontSize: getValueForScreenType<double>(
                                context: context,
                                mobile: 18,
                                tablet: 28,
                              ),
                              color: AppColor.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: getValueForScreenType<double>(
                                context: context,
                                mobile: 20,
                                tablet: 40,
                              ),
                            ),
                            itemCount: baskerc.getcount().length,
                            itemBuilder: (BuildContext context, index) {
                              final item = baskerc.mycart[index];
                              final itemType = item['itemType'] == 'unit'
                                  ? 'وحدة كاملة'
                                  : item['itemType'] == 'section'
                                  ? 'قسم كامل'
                                  : 'درس كامل';

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.PrimaryColor,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: getValueForScreenType<double>(
                                        context: context,
                                        mobile: 10,
                                        tablet: 18,
                                      ),
                                      horizontal: getValueForScreenType<double>(
                                        context: context,
                                        mobile: 20,
                                        tablet: 40,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: AppColor
                                          .SecondryColor.withOpacity(0.5),
                                      radius: getValueForScreenType<double>(
                                        context: context,
                                        mobile: 25,
                                        tablet: 35,
                                      ),
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: AppColor.PrimaryColor,
                                        size: getValueForScreenType<double>(
                                          context: context,
                                          mobile: 24,
                                          tablet: 36,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      item['itemName'].toString(),
                                      style: TextStyle(
                                        color: AppColor.PrimaryColor,
                                        fontSize: getValueForScreenType<double>(
                                          context: context,
                                          mobile: 16,
                                          tablet: 24,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "$itemType - ${item['subjectName']}",
                                          style: TextStyle(
                                            color: AppColor.DeepPurple,
                                            fontSize:
                                                getValueForScreenType<double>(
                                                  context: context,
                                                  mobile: 14,
                                                  tablet: 20,
                                                ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        (homeController.isDeployed == 1)
                                            ? Text(
                                                "${item['itemPrice']} ",
                                                style: TextStyle(
                                                  color: AppColor.grey,
                                                  fontSize:
                                                      getValueForScreenType<
                                                        double
                                                      >(
                                                        context: context,
                                                        mobile: 14,
                                                        tablet: 20,
                                                      ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Colors.redAccent,
                                        size: getValueForScreenType<double>(
                                          context: context,
                                          mobile: 26,
                                          tablet: 36,
                                        ),
                                      ),
                                      onPressed: () =>
                                          baskerc.removeItem(index),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                // Row(
                //   children: [
                //
                //           Padding(
                //               padding: EdgeInsets.all(
                //                 getValueForScreenType<double>(
                //                   context: context,
                //                   mobile: 8,
                //                   tablet: 10,
                //                 ),
                //               ),
                //               child: baskerc.count != 0
                //                   ? ElevatedButton(
                //                       style: ButtonStyle(
                //                           backgroundColor: MaterialStatePropertyAll(
                //                               AppColor.PrimaryColor)),
                //                       onPressed: () {
                //                         // Obx(()=>
                //                         // // baskerc.isload.value?
                //                         print(baskerc.dataList['name']);
                //                         print(baskerc.dataList['phone']);
                //                         alertPaidMethod(baskerc.dataList['name'],
                //                             baskerc.dataList['phone']);
                //                       },
                //                       child: Obx(() {
                //                         return Row(
                //                           children: [
                //                             Text(
                //                               "المجموع" + "  " + baskerc.count.toString(),
                //                               style: TextStyle(
                //                                 color: AppColor.White,
                //                                 fontSize: getValueForScreenType<double>(
                //                                   context: context,
                //                                   mobile: 11,
                //                                   tablet: 15,
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         );
                //                       }))
                //                   // :Center(child:CircularProgressIndicator())
                //
                //                   : Text('المجموع = 0')),
                //         ],
                //
                // )
                (homeController.isDeployed == 1)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                              getValueForScreenType<double>(
                                context: context,
                                mobile: 10,
                                tablet: 20,
                              ),
                            ),
                            child: Obx(() {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 20,
                                    tablet: 40,
                                  ),
                                  vertical: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 12,
                                    tablet: 18,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.SecondryColor.withOpacity(
                                    0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColor.PrimaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (baskerc.mycart.isEmpty) {
                                      Get.snackbar("تنبيه", "السلة فارغة");
                                      return;
                                    }
                                    // print(
                                    //   'fffffffffffff${baskerc.dataList['message']}',
                                    // );

                                    alertPaidMethod(
                                      baskerc.dataList['message'] ?? "",
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        color: AppColor.PrimaryColor,
                                        size: getValueForScreenType<double>(
                                          context: context,
                                          mobile: 22,
                                          tablet: 35,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "المجموع: ",
                                        style: TextStyle(
                                          color: AppColor.PrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getValueForScreenType<double>(
                                                context: context,
                                                mobile: 15,
                                                tablet: 22,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        "${baskerc.count.toString()} ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getValueForScreenType<double>(
                                                context: context,
                                                mobile: 16,
                                                tablet: 24,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ],
        ),

        // body: Stack(
        //   children: [
        //
        //     Obx(
        //       () => baskerc.isload == true
        //           ? LoadingImage()
        //           : baskerc.mycart.isEmpty
        //               ? Center(
        //                   child: Text(
        //                   "لا يوجد لديك مشتريات",
        //                   style: TextStyle(
        //                       fontSize: getValueForScreenType<double>(
        //                         context: context,
        //                         mobile: 15,
        //                         tablet: 25,
        //                       ),
        //                       color: AppColor.grey),
        //                 ))
        //               : Padding(
        //                   padding: EdgeInsets.all(
        //                     getValueForScreenType<double>(
        //                       context: context,
        //                       mobile: 20,
        //                       tablet: 40,
        //                     ),
        //                   ),
        //                   child: ListView.separated(
        //                       separatorBuilder: (context, index) => SizedBox(
        //                             height: getValueForScreenType<double>(
        //                               context: context,
        //                               mobile: 30,
        //                               tablet: 60,
        //                             ),
        //                           ),
        //                       itemCount: baskerc.getcount().length,
        //                       itemBuilder: (BuildContext context, index) {
        //                         return SizedBox(
        //                             width: getValueForScreenType<double>(
        //                               context: context,
        //                               mobile: Get.width * 0.2,
        //                               tablet: Get.width * 0.50,
        //                             ),
        //                             height: getValueForScreenType<double>(
        //                               context: context,
        //                               mobile: Get.height * 0.32,
        //                               tablet: Get.height * 0.50,
        //                             ),
        //                             child: Card(
        //                               shadowColor: AppColor.SecondryColor2,
        //                               elevation: 10,
        //                               color: AppColor.BackGround,
        //                               child: Column(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.spaceAround,
        //                                 children: [
        //                                   Text(
        //                                     baskerc.mycart[index]['itemType'] ==
        //                                             'unit'
        //                                         ? 'وحدة كاملة'
        //                                         : baskerc.mycart[index]
        //                                                     ['itemType'] ==
        //                                                 'section'
        //                                             ? ' قسم كامل'
        //                                             : 'درس كامل',
        //                                     style: TextStyle(
        //                                       color: AppColor.DeepPurple,
        //                                       fontSize:
        //                                           getValueForScreenType<double>(
        //                                         context: context,
        //                                         mobile: 15,
        //                                         tablet: 17,
        //                                       ),
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                       baskerc.mycart[index]['itemName']
        //                                           .toString(),
        //                                       style: TextStyle(
        //                                         color: AppColor.PrimaryColor,
        //                                         fontSize:
        //                                             getValueForScreenType<double>(
        //                                           context: context,
        //                                           mobile: 15,
        //                                           tablet: 17,
        //                                         ),
        //                                       )),
        //                                   Text(
        //                                     baskerc.mycart[index]['subjectName']
        //                                         .toString(),
        //                                     style: TextStyle(
        //                                       color: AppColor.DeepPurple,
        //                                       fontSize:
        //                                           getValueForScreenType<double>(
        //                                         context: context,
        //                                         mobile: 15,
        //                                         tablet: 17,
        //                                       ),
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                     baskerc.mycart[index]['itemPrice']
        //                                         .toString(),
        //                                     style: TextStyle(
        //                                       color: AppColor.grey,
        //                                       fontSize:
        //                                           getValueForScreenType<double>(
        //                                         context: context,
        //                                         mobile: 15,
        //                                         tablet: 17,
        //                                       ),
        //                                     ),
        //                                   ),
        //                                   CustomElevatedButton(
        //                                       onPressed: () {
        //                                         baskerc.removeItem(index);
        //                                       },
        //                                       text: "إزالة")
        //                                 ],
        //                               ),
        //                             ));
        //                       }),
        //                 ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
