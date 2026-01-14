import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/function/cart_animation_helper.dart';

class AnimatedCartIcon extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final GlobalKey? targetCartKey;

  const AnimatedCartIcon({
    super.key,
    this.onPressed,
    this.color,
    this.size,
    this.targetCartKey,
  });

  @override
  State<AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<AnimatedCartIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final GlobalKey _iconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onPressed == null) return;

    // Animate icon press
    await _controller.forward();
    await _controller.reverse();

    // Get icon position
    final RenderBox? box =
        _iconKey.currentContext?.findRenderObject() as RenderBox?;

    if (box != null && mounted && widget.targetCartKey != null) {
      final Offset position = box.localToGlobal(Offset.zero);

      // Trigger fly-to-cart animation
      CartAnimationHelper.animateToCart(
        context: context,
        cartKey: widget.targetCartKey!,
        startPosition: position,
        onComplete: () {
          widget.onPressed!();
        },
      );
    } else {
      // No animation, just execute
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _iconKey,
      borderRadius: BorderRadius.circular(50),
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.shopping_cart_outlined,
            color: widget.color ?? AppColor.SecondryColor,
            size: widget.size ?? 24,
          ),
        ),
      ),
    );
  }
}
