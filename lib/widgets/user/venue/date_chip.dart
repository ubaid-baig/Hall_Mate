import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

// One day in the "Free dates" row of Venue detail.
// The small bar under the date is green when the day is free.
class DateChip extends StatelessWidget {
  final String day; // for example 'Mon'
  final String date; // for example '14'
  final bool isFree; // no booking on this day yet
  final bool isSelected; // true for the day the user picked

  const DateChip({
    super.key,
    required this.day,
    required this.date,
    required this.isFree,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final Color freeColor = isSelected ? colors.accent : colors.success;
    final Color bookedColor = isSelected
        ? colors.textOnPrimary.withValues(alpha: 0.4)
        : colors.borderStrong;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : colors.bgSurface,
        border: Border.all(color: isSelected ? colors.primary : colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: AppTextStyles.caption(
              color: isSelected ? colors.textOnPrimaryMute : colors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: AppTextStyles.titleMedium(
              color: isSelected ? colors.textOnPrimary : null,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 20,
            height: 4,
            decoration: BoxDecoration(
              color: isFree ? freeColor : bookedColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
