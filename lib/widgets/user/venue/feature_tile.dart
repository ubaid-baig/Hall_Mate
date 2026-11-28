import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

class FeatureTile extends StatelessWidget {
  final String iconType; // 'guests' or a feature name, for example 'Parking'
  final String label; // the text under the icon

  const FeatureTile({super.key, required this.iconType, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Pick the icon from the feature name
    IconData icon = Icons.check_circle_outline;
    if (iconType == 'guests') {
      icon = Icons.people_outline;
    } else if (iconType == 'Parking') {
      icon = Icons.local_parking;
    } else if (iconType == 'Family hall') {
      icon = Icons.meeting_room_outlined;
    } else if (iconType == 'Generator') {
      icon = Icons.bolt_outlined;
    } else if (iconType == 'Valet') {
      icon = Icons.directions_car_outlined;
    } else if (iconType == 'Stage') {
      icon = Icons.mic_none_outlined;
    } else if (iconType == 'Sound system') {
      icon = Icons.speaker_outlined;
    } else if (iconType == 'Marquee') {
      icon = Icons.festival_outlined;
    } else if (iconType == 'Lighting') {
      icon = Icons.light_outlined;
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
