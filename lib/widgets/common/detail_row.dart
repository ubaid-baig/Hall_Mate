import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final String? badge;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium(color: colors.textMuted),
          ),
        ),
        if (badge != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colors.successSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badge!,
              style: AppTextStyles.labelTiny(color: colors.successInk),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(value, style: AppTextStyles.titleSmall(color: valueColor)),
      ],
    );
  }
}
