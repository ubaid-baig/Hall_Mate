import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/venue/venue_details_screen.dart';
import 'package:hall_mate/widgets/common/media_box.dart';

/// The big venue card: cover photo on top (with a tag and a heart), details below.
/// Used in "Featured venues" (Home), Search results and Saved venues.
class VenueCard extends StatelessWidget {
  final VenueModel venue;
  final bool isFavorite; // is this venue in the saved list?
  final double photoHeight;
  // Runs when the heart is tapped
  final VoidCallback? onFavoriteTap;

  const VenueCard({
    super.key,
    required this.venue,
    required this.isFavorite,
    this.photoHeight = 150,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      // Opens the Venue detail screen of THIS venue
      onTap: () {
        Get.to(() => VenueDetailScreen(venueId: venue.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgSurface,
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cover photo with the tag (left) and the heart (right) on top ──
            MediaBox(
              media: venue.coverOrPlaceholder(),
              width: double.infinity,
              height: photoHeight,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
              topRow: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colors.bgSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      venue.type,
                      style: AppTextStyles.labelSmall(color: colors.primaryInk),
                    ),
                  ),
                  // The heart: the screen decides what a tap does.
                  // (This GestureDetector is inside the card's one, so a tap on
                  // the heart runs this, not "open Venue detail".)
                  GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: colors.bgSurface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFavorite ? colors.iconHeart : colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Name, rating, details, rent ──
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(venue.name, style: AppTextStyles.h3())),
                      const SizedBox(width: 8),
                      Icon(Icons.star_rounded, size: 16, color: colors.iconStar),
                      const SizedBox(width: 3),
                      Text(venue.ratingText(), style: AppTextStyles.titleSmall()),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    venue.subtitle(),
                    style: AppTextStyles.bodySmall(color: colors.textMuted),
                  ),
                  const SizedBox(height: 8),
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
