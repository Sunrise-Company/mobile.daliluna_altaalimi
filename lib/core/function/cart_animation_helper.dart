import 'package:flutter/material.dart';

class CartAnimationHelper {
  static OverlayEntry? _currentOverlay;

  static void animateToCart({
    required BuildContext context,
    required GlobalKey cartKey,
    required Offset startPosition,
    VoidCallback? onComplete,
  }) {
    print('🎬 animateToCart called');
    print('📦 Start position: $startPosition');

    final cartKeyContext = cartKey.currentContext;
    if (cartKeyContext == null) {
      print('❌ Cart key context is NULL - cannot animate');
      onComplete?.call();
      return;
    }

    print('✅ Cart key context found');

    // Cancel any existing animation
    _currentOverlay?.remove();
    _currentOverlay = null;

    final RenderBox cartBox = cartKeyContext.findRenderObject() as RenderBox;
    final Offset cartPosition = cartBox.localToGlobal(Offset.zero);
    final Size cartSize = cartBox.size;

    print('🎯 Cart position: $cartPosition');
    print('📏 Cart size: $cartSize');

    // Adjust to center of cart icon
    final Offset cartCenter = Offset(
      cartPosition.dx + (cartSize.width / 2) - 25,
      cartPosition.dy + (cartSize.height / 2) - 25,
    );

    print('🎯 Cart center: $cartCenter');

    final overlay = Overlay.of(context);
    print('🎨 Creating overlay widget');

    // Create animated widget
    final animatedWidget = _AnimatedCartIcon(
      startPosition: startPosition,
      endPosition: cartCenter,
      onComplete: () {
        _currentOverlay?.remove();
        _currentOverlay = null;
        onComplete?.call();
      },
    );

    _currentOverlay = OverlayEntry(builder: (context) => animatedWidget);

    overlay.insert(_currentOverlay!);
    print('✨ Animation overlay inserted');
  }
}

class _AnimatedCartIcon extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onComplete;

  const _AnimatedCartIcon({
    required this.startPosition,
    required this.endPosition,
    required this.onComplete,
  });

  @override
  State<_AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<_AnimatedCartIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _positionAnimation =
        Tween<Offset>(
          begin: widget.startPosition,
          end: widget.endPosition,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: IgnorePointer(
            child: Opacity(
              opacity: _opacityAnimation.value.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
