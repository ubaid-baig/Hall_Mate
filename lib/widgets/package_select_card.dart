import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// A package the user can choose on the Booking request screen
/// (name, price and a round "radio" button).
/// The selected one gets a green look and a filled radio.
///
/// API: name and price come from the venue's packages list.
class PackageSelectCard extends StatelessWidget {
  final String name; // API: package name
  final String price; // API: price per head
  final bool isSelected; // true for the package the user picked

  const PackageSelectCard({
    super.key,
    required this.name,
    required this.price,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected ? colors.primaryTint : colors.bgSurface,
        border: Border.all(
          color: isSelected ? colors.primaryBorder : colors.border,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.titleSmall(color: colors.textSecondary),
                ),
              ),
              // The round radio button: filled green with a white dot when
              // selected, an empty circle when not.
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : colors.bgSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? colors.primary : colors.borderStrong,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.textOnPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AppTextStyles.h3(color: colors.textPrimary),
              children: [
                TextSpan(text: price),
                TextSpan(
                  text: ' / head',
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
