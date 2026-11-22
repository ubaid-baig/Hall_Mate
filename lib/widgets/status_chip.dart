import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// The small coloured pill that shows a booking status.
/// API: pass the status text from the booking. Use exactly:
/// Requested, Negotiating, Accepted, Confirmed, Completed.
class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Default (Completed or anything unknown)
    Color bgColor = colors.bgNeutral;
    Color inkColor = colors.textSecondary;

    if (status == 'Requested') {
      bgColor = colors.infoSoft;
      inkColor = colors.infoInk;
    } else if (status == 'Negotiating') {
      bgColor = colors.accentSoft;
      inkColor = colors.accentStrongInk;
    } else if (status == 'Accepted') {
      bgColor = colors.successSoft;
      inkColor = colors.successInk;
    } else if (status == 'Confirmed') {
      bgColor = colors.primarySoft;
      inkColor = colors.primaryInk;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: AppTextStyles.labelSmall(color: inkColor)),
    );
  }
}
