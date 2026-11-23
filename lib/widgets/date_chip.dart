import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One day in the "Free dates" row: day name, date number and two small bars.
/// The left bar is lunch, the right bar is dinner.
///   green bar = free        grey bar = booked
/// The selected day is filled green and its free bar turns orange.
///
/// API: every value comes from one day in the availability list.
class DateChip extends StatelessWidget {
  final String day; // for example 'Mon'
  final String date; // for example '14'
  final bool isLunchFree; // API: is the lunch slot free?
  final bool isDinnerFree; // API: is the dinner slot free?
  final bool isSelected; // true for the day the user picked

  const DateChip({
    super.key,
    required this.day,
    required this.date,
    required this.isLunchFree,
    required this.isDinnerFree,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Bar colours
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 4,
                decoration: BoxDecoration(
                  color: isLunchFree ? freeColor : bookedColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 3),
              Container(
                width: 10,
                height: 4,
                decoration: BoxDecoration(
                  color: isDinnerFree ? freeColor : bookedColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
