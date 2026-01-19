import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/function/cart_animation_helper.dart';

class CustomButtonBuy extends StatefulWidget {
  final void Function()? onTap;
  final GlobalKey? targetCartKey;

  const CustomButtonBuy({super.key, required this.onTap, this.targetCartKey});

  @override
  State<CustomButtonBuy> createState() => _CustomButtonBuyState();
}

class _CustomButtonBuyState extends State<CustomButtonBuy>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late final GlobalKey _buttonKey;

  @override
  void initState() {
    super.initState();
    _buttonKey = GlobalKey(debugLabel: 'button_${identityHashCode(this)}');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onTap == null) return;

    // Animate button press
    await _controller.forward();
    await _controller.reverse();

    // Get button position
    final RenderBox? box =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;

    if (box != null && mounted && widget.targetCartKey != null) {
      final Offset position = box.localToGlobal(Offset.zero);

      // Trigger fly-to-cart animation
      CartAnimationHelper.animateToCart(
        context: context,
        cartKey: widget.targetCartKey!,
        startPosition: position,
        onComplete: () {
          widget.onTap!();
        },
      );
    } else {
      // No animation, just execute
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          key: _buttonKey,
          width: getValueForScreenType<double>(
            context: context,
            mobile: 90,
            tablet: 150,
          ),
          height: getValueForScreenType<double>(
            context: context,
            mobile: 40,
            tablet: 50,
          ),
          child: Card(
            elevation: 3,
            color: AppColor.SecondryColor2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "اشتراك",
                  style: TextStyle(
                    fontSize: getValueForScreenType<double>(
                      context: context,
                      mobile: 10,
                      tablet: 17,
                    ),
                    color: AppColor.DeepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.add_shopping_cart_rounded,
                  size: getValueForScreenType<double>(
                    context: context,
                    mobile: 17,
                    tablet: 22,
                  ),
                  color: AppColor.SecondryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
