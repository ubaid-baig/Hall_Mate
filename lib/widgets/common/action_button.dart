import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon; // optional icon before the text
  final Color bgColor;
  final Color borderColor;
  final Color textColor; // also used for the icon
  final VoidCallback onTap;
  final double height;

  const ActionButton({
    super.key,
    required this.label,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
    this.icon,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: textColor),
                const SizedBox(width: 8),
              ],
              Text(label, style: AppTextStyles.titleSmall(color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
