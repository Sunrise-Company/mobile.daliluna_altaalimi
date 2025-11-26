import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:badges/badges.dart' as badges;

class CustomCardUnits extends StatelessWidget {
  final Function() onTap;
  final void Function()? onTapShop;
  final String textIcon;
  final IconData? icon;
  const CustomCardUnits({
    super.key,
    required this.onTap,
    required this.textIcon,
    this.onTapShop,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 20, right: 20, left: 20),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: AppColor.SecondryColor, blurRadius: 10.0),
          ],
          color: AppColor.BackGround2,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColor.SecondryColor2, width: 2),
        ),
        child: badges.Badge(
          badgeAnimation: const badges.BadgeAnimation.rotation(
            animationDuration: Duration(seconds: 4),
            colorChangeAnimationDuration: Duration(seconds: 4),
            loopAnimation: false,
            curve: Curves.fastOutSlowIn,
            colorChangeAnimationCurve: Curves.easeInCubic,
          ),
          position: badges.BadgePosition.topEnd(top: -30, end: 10),
          showBadge: true,
          ignorePointer: false,
          badgeStyle: const badges.BadgeStyle(
            badgeColor: AppColor.PrimaryColor,
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide.none,
            shape: badges.BadgeShape.twitter,
          ),
          badgeContent: InkWell(
            onTap: onTapShop,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: AppColor.BackGround3,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColor.PrimaryColor, width: 1.5),
              ),
              child: IconButton(
                onPressed: onTapShop,
                icon: const Icon(Icons.lock, size: 15),
                color: AppColor.DeepPurple,
              ),
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        textIcon,
                        style: const TextStyle(
                          color: AppColor.PrimaryColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
