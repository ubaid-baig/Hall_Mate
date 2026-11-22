import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One package (Silver, Gold ...) on the Venue detail screen.
/// A popular package gets a green look and a "Popular" pill.
///
/// API: every value comes from one package in the venue's packages list.
class PackageCard extends StatelessWidget {
  final String name; // API: package name
  final String price; // API: price per head, e.g. 'Rs 2,200'
  final List<String> features; // API: what the package includes
  final bool isPopular; // API: true for the package to highlight

  const PackageCard({
    super.key,
    required this.name,
    required this.price,
    required this.features,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isPopular ? colors.primaryTint : colors.bgSurface,
        border: Border.all(
          color: isPopular ? colors.primaryBorder : colors.border,
          width: isPopular ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name (and the "Popular" pill). A fixed height keeps both cards equal.
          SizedBox(
            height: 24,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: AppTextStyles.titleSmall(color: colors.textSecondary),
                  ),
                ),
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Popular',
                      style: AppTextStyles.labelTiny(color: colors.textOnAccent),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: AppTextStyles.h2(color: colors.textPrimary),
              children: [
                TextSpan(text: price),
                TextSpan(
                  text: ' / head',
                  style: AppTextStyles.bodySmall(color: colors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Column(
            // One check line for every feature in the list
            children: features.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 18, color: colors.primaryInk),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(feature, style: AppTextStyles.bodyMedium()),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
