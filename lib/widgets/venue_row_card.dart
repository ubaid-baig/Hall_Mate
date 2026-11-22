import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/photo_placeholder.dart';

/// The small venue card: square photo on the left, details on the right.
/// Used in "Near you" (Home).
///
/// API: every value comes from one venue in your API list.
class VenueRowCard extends StatelessWidget {
  final String name; // API: venue name
  final String rating; // API: average rating
  final String subtitle; // API: type + distance + capacity
  final String price; // API: starting price per head
  final String photoStyle; // DUMMY ONLY: placeholder colour

  const VenueRowCard({
    super.key,
    required this.name,
    required this.rating,
    required this.subtitle,
    required this.price,
    required this.photoStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          PhotoPlaceholder(
            photoStyle: photoStyle,
            width: 80,
            height: 80,
            iconSize: 24,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(name, style: AppTextStyles.titleLarge()),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.star_rounded, size: 16, color: colors.iconStar),
                    const SizedBox(width: 3),
                    Text(rating, style: AppTextStyles.titleSmall()),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall(color: colors.textMuted),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodySmall(color: colors.textMuted),
                    children: [
                      const TextSpan(text: 'from '),
                      TextSpan(
                        text: price,
                        style: AppTextStyles.titleMedium(
                          color: colors.primaryInk,
                        ),
                      ),
                      const TextSpan(text: ' / head'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
