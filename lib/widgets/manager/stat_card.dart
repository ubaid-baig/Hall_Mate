import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

// A small white box on the dashboard: a big number and a label under it.
class StatCard extends StatelessWidget {
  final String value; // for example '2'
  final String label; // for example 'New requests'

  const StatCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.h2()),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
