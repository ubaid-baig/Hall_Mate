import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// The "- 300 +" box for choosing the number of guests.
/// The screen passes what happens on - and + (onMinus, onPlus).
class GuestStepper extends StatelessWidget {
  final String value; // for example '300'
  final VoidCallback? onMinus; // runs when - is tapped
  final VoidCallback? onPlus; // runs when + is tapped

  const GuestStepper({
    super.key,
    required this.value,
    this.onMinus,
    this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onMinus,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.remove, size: 22, color: colors.textPrimary),
            ),
          ),
          SizedBox(
            width: 56,
            child: Center(
              child: Text(value, style: AppTextStyles.titleLarge()),
            ),
          ),
          GestureDetector(
            onTap: onPlus,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add, size: 22, color: colors.textOnPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
