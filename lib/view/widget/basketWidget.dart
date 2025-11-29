import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/basket_controller.dart';
import '../../core/constant/color.dart';
import '../../core/constant/routes.dart';

Widget BasketWidget({required String heroTag}) {
  late BasketController baskerc;
  baskerc = Get.put(BasketController());
  return FloatingActionButton(
    heroTag: heroTag,
    backgroundColor: AppColor.SecondryColor,
    elevation: 6,
    onPressed: () {
      Get.toNamed(AppRoute.basket);
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
        Positioned(
          right: 0,
          top: 5,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
            child: Text(
              baskerc.mycart.isNotEmpty
                  ? baskerc.mycart.length.toString()
                  : "0",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
