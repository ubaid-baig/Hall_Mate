import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;

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
