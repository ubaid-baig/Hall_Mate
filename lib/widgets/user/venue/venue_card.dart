import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

import '../../../view/user/venue/venue_details_screen.dart';
import '../../common/photo_placeholder.dart';


/// The big venue card: photo on top (with a tag and a heart), details below.
/// Used in "Featured venues" (Home) and in the Search results list.
///
/// API: every value comes from one venue in your API list.
class VenueCard extends StatelessWidget {
  final String name; // API: venue name
  final String rating; // API: average rating, e.g. '4.5'
  final String subtitle; // API: area + capacity (+ extras)
  final String price; // API: starting price per head, e.g. 'Rs 2,200'
  final String tag; // text on the white pill over the photo
  final bool isFavorite; // API: is this venue in the user's favourites?
  final String photoStyle; // DUMMY ONLY: placeholder colour
  final double photoHeight;
  // Runs when the heart is tapped. Optional, so screens that don't pass it still work.
  final VoidCallback? onFavoriteTap;

  const VenueCard({
    super.key,
    required this.name,
    required this.rating,
    required this.subtitle,
    required this.price,
    required this.tag,
    required this.isFavorite,
    required this.photoStyle,
    this.photoHeight = 150,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      // Opens the Venue detail screen.
      // API: send this venue's id along, for example
      // Get.to(() => VenueDetailScreen(), arguments: venueId)
      onTap: () {
        Get.to(() => const VenueDetailScreen());
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
            // ── Photo with the tag (left) and the heart (right) on top ──
            PhotoPlaceholder(
              photoStyle: photoStyle,
              width: double.infinity,
              height: photoHeight,
              iconSize: 28,
              showLabel: true,
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
                      tag,
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

            // ── Name, rating, details, price ──
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(name, style: AppTextStyles.h3())),
                      const SizedBox(width: 8),
                      Icon(Icons.star_rounded, size: 16, color: colors.iconStar),
                      const SizedBox(width: 3),
                      Text(rating, style: AppTextStyles.titleSmall()),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall(color: colors.textMuted),
                  ),
                  const SizedBox(height: 8),
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
      ),
    );
  }
}