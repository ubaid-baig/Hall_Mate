import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/venue/venue_details_screen.dart';
import 'package:hall_mate/widgets/common/media_box.dart';

/// The small venue card: photo on the left, details on the right.
/// Used in "Near you" on Home.
class VenueRowCard extends StatelessWidget {
  final VenueModel venue;

  const VenueRowCard({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: () {
        Get.to(() => VenueDetailScreen(venueId: venue.id));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.bgSurface,
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            MediaBox(
              media: venue.coverOrPlaceholder(),
              width: 80,
              height: 80,
              showLabel: false,
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
                        child: Text(venue.name, style: AppTextStyles.titleLarge()),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star_rounded, size: 16, color: colors.iconStar),
                      const SizedBox(width: 3),
                      Text(venue.ratingText(), style: AppTextStyles.titleSmall()),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${venue.type} · ${venue.subtitle()}',
                    style: AppTextStyles.bodySmall(color: colors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodySmall(color: colors.textMuted),
                      children: [
                        TextSpan(
                          text: AppFormat.rupees(venue.rent),
                          style: AppTextStyles.titleMedium(
                            color: colors.primaryInk,
                          ),
                        ),
                        const TextSpan(text: ' / event'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
