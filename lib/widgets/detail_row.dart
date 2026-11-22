import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One line of a price or receipt card: a grey label on the left and a
/// bold value on the right. An optional small green badge (for example
/// "Paid") can sit before the value.
///
/// API: label and value come from the booking / payment response.
class DetailRow extends StatelessWidget {
  final String label; // for example 'Guests'
  final String value; // API: for example '300'
  final Color? valueColor; // optional colour of the value (green for "Pay now")
  final String? badge; // optional pill before the value, e.g. 'Paid'

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
