import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/basket_controller.dart';
import '../../controller/home_controller.dart';
import '../../core/constant/color.dart';
import '../../core/constant/routes.dart';

class BasketWidget extends StatefulWidget {
  final String heroTag;
  final GlobalKey? customKey;
  const BasketWidget({super.key, required this.heroTag, this.customKey});

  @override
  State<BasketWidget> createState() => _BasketWidgetState();
}

class _BasketWidgetState extends State<BasketWidget>
    with SingleTickerProviderStateMixin {
  late BasketController baskerc;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    baskerc = Get.put(BasketController());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.customKey,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child:(homeController.isDeployed!=0)? FloatingActionButton(
          heroTag: widget.heroTag,
          backgroundColor: AppColor.SecondryColor,
          elevation: 6,
          onPressed: () async {
            await _controller.forward();
            await _controller.reverse();
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
                  child: Obx(
                    () => Text(
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
              ),
            ],
          ),
        ):SizedBox(),
      ),
    );
  }
}
