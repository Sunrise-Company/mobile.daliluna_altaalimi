import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class PremiumActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final bool isPrimary;
  final bool isWarning;

  const PremiumActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    required this.color,
    this.isPrimary = false,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final bgColor = isDisabled
        ? Colors.grey.shade100
        : isWarning
        ? Colors.red.shade50
        : isPrimary
        ? AppColor.PrimaryColor
        : AppColor.SecondryColor2.withValues(alpha: 0.3);

    final textColor = isDisabled
        ? Colors.grey.shade400
        : isWarning
        ? Colors.redAccent
        : isPrimary
        ? Colors.white
        : AppColor.PrimaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDisabled
                  ? Colors.transparent
                  : isWarning
                  ? Colors.red.shade200
                  : isPrimary
                  ? Colors.transparent
                  : AppColor.SecondryColor2,
              width: 1,
            ),
            boxShadow: isPrimary && !isDisabled
                ? [
                    BoxShadow(
                      color: AppColor.PrimaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
