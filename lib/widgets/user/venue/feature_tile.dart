import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One small tile with an icon and a short text, for example
/// "Up to 500 guests". Used in a row of three on the Venue detail screen.
class FeatureTile extends StatelessWidget {
  final String iconType; // API: 'guests', 'parking' or 'family_hall'
  final String label; // API: the text under the icon

  const FeatureTile({super.key, required this.iconType, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Pick the icon from the type name
    IconData icon = Icons.check_circle_outline;
    if (iconType == 'guests') {
      icon = Icons.people_outline;
    } else if (iconType == 'parking') {
      icon = Icons.local_parking;
    } else if (iconType == 'family_hall') {
      icon = Icons.meeting_room_outlined;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgSubtle,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: colors.primaryInk),
          const SizedBox(height: 10),
          Text(label, style: AppTextStyles.titleSmall()),
        ],
      ),
    );
  }
}
