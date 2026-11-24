import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// A small card with a grey label on top and a bold value below,
/// for example "Guests" and "300".
/// The optional suffix is shown lighter after the value, for example "/ head".
class InfoTile extends StatelessWidget {
  final String label; // for example 'Guests'
  final String value; // API: the value from the booking
  final String? suffix; // for example '/ head'

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption(color: colors.textMuted)),
          const SizedBox(height: 4),
          // RichText does not take the theme colour by itself,
          // so the colour is written here.
          RichText(
            text: TextSpan(
              style: AppTextStyles.titleSmall(color: colors.textPrimary),
              children: [
                TextSpan(text: value),
                if (suffix != null)
                  TextSpan(
                    text: ' $suffix',
                    style: AppTextStyles.bodySmall(color: colors.textMuted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
