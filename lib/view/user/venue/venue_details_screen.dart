import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/user/venue/favourite_controller.dart';
import 'package:hall_mate/controller/user/venue/venue_detail_controller.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/booking/booking_request_screen.dart';
import 'package:hall_mate/view/user/venue/media_gallery_screen.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/media_box.dart';
import 'package:hall_mate/widgets/user/venue/date_chip.dart';
import 'package:hall_mate/widgets/user/venue/feature_tile.dart';
import 'package:hall_mate/widgets/user/venue/review_card.dart';

// Venue detail. Opens when a venue card is tapped.
// It gets the venue's id, then finds the venue in the shared list.
class VenueDetailScreen extends StatelessWidget {
  final String venueId;

  const VenueDetailScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final VenueDetailController controller = Get.put(VenueDetailController());
    final AppDataController data = Get.find<AppDataController>();
    // The saved venues (hearts). Created once in main.dart.
    final FavouriteController favController = Get.find<FavouriteController>();

    // 7 days fit across the screen, the rest scroll sideways
    final double dateWidth = (sw * 0.9 - 36) / 7;

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        bottom: false,
        // Obx: if the manager changes the venue (rent, photos ...)
        // this screen shows the change straight away.
        child: Obx(() {
          final VenueModel venue = data.venueById(venueId);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ════════ COVER PHOTO ════════
                      // Stack: the photo at the back, the buttons on top of it
                      SizedBox(
                        height: sh * 0.32,
                        child: Stack(
                          children: [
                            MediaBox(
                              media: venue.coverOrPlaceholder(),
                              width: double.infinity,
                              height: sh * 0.32,
                              borderRadius: BorderRadius.zero,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                sw * 0.045,
                                sh * 0.018,
                                sw * 0.045,
                                sh * 0.025,
                              ),
                              child: Column(
                                children: [
                                  // Top row: back (left), heart (right)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: colors.bgSurface,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.arrow_back,
                                            size: 22,
                                            color: colors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      // The heart: save or unsave this venue
                                      GestureDetector(
                                        onTap: () {
                                          favController.toggleFavourite(venue.id);
                                        },
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: colors.bgSurface,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            favController.isSaved(venue.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 22,
                                            color: favController.isSaved(venue.id)
                                                ? colors.iconHeart
                                                : colors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // An empty space pushes the bottom row down
                                  const Expanded(child: SizedBox()),
                                  // Bottom row: photo count (left), video (right)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        // Opens the Media gallery screen
                                        onTap: () {
                                          Get.to(
                                            () => MediaGalleryScreen(
                                              venueId: venue.id,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.85),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            venue.mediaCountText(),
                                            style: AppTextStyles.labelSmall(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Only when the venue has a video
                                      if (venue.videos().isNotEmpty)
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => MediaGalleryScreen(
                                                venueId: venue.id,
                                                startOnVideos: true,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colors.bgSurface,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 22,
                                                  height: 22,
                                                  decoration: BoxDecoration(
                                                    color: colors.primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.play_arrow_rounded,
                                                    size: 16,
                                                    color: colors.textOnPrimary,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Videos',
                                                  style:
                                                      AppTextStyles.labelSmall(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ════════ DETAILS ════════
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          left: sw * 0.05,
                          right: sw * 0.05,
                          top: 20,
                          bottom: 24,
                        ),
                        color: colors.bgSurface,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Type chip ──
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primarySoft,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                venue.type,
                                style: AppTextStyles.labelSmall(
                                  color: colors.primaryInk,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // ── Name, area, rating ──
                            Text(venue.name, style: AppTextStyles.h1()),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: colors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${venue.area}, Karachi',
                                    style: AppTextStyles.bodyMedium(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 18,
                                  color: colors.iconStar,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  venue.ratingText(),
                                  style: AppTextStyles.titleSmall(),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  controller.reviewsText(venue),
                                  style: AppTextStyles.bodySmall(
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: sh * 0.022),

                            // ── Feature tiles (capacity + 2 features) ──
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.featureTiles(venue).map((tile) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FeatureTile(
                                      iconType: tile['icon']!,
                                      label: tile['label']!,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: sh * 0.028),

                            // ── About ──
                            Text('About', style: AppTextStyles.h3()),
                            const SizedBox(height: 8),
                            Text(
                              venue.about,
                              style: AppTextStyles.bodyMedium(
                                color: colors.textSecondary,
                              ),
                            ),
                            SizedBox(height: sh * 0.025),

                            // ── Rent ──
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colors.bgSubtle,
                                border: Border.all(color: colors.border),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: colors.primarySoft,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.sell_outlined,
                                      size: 20,
                                      color: colors.primaryInk,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rent per event',
                                          style: AppTextStyles.caption(
                                            color: colors.textMuted,
                                          ),
                                        ),
                                        Text(
                                          AppFormat.rupees(venue.rent),
                                          style: AppTextStyles.titleLarge(),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'For ${venue.minGuests} – ${venue.maxGuests} guests. '
                                          'Food is not included, bring your own caterer.',
                                          style: AppTextStyles.bodySmall(
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: sh * 0.028),

                            // ── Free dates ──
                            Text('Free dates', style: AppTextStyles.h3()),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 72,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.nextDays().length,
                                itemBuilder: (context, index) {
                                  final DateTime day = controller.nextDays()[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.selectDate(index);
                                      },
                                      // ListView builds the days a moment later,
                                      // so each day has its own Obx.
                                      child: Obx(
                                        () => SizedBox(
                                          width: dateWidth,
                                          child: DateChip(
                                            day: AppFormat.dayNames[day.weekday - 1],
                                            date: '${day.day}',
                                            isFree: controller.isFree(venue, day),
                                            isSelected: controller
                                                    .selectedDateIndex.value ==
                                                index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),

                            // The grey box about the selected day
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: colors.bgSubtle,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller.selectedDateText(),
                                      style: AppTextStyles.titleSmall(),
                                    ),
                                  ),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      // green when free, grey when booked
                                      color: controller.isFree(
                                        venue,
                                        controller.selectedDate(),
                                      )
                                          ? colors.success
                                          : colors.borderStrong,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    controller.isFree(
                                      venue,
                                      controller.selectedDate(),
                                    )
                                        ? 'Free'
                                        : 'Booked',
                                    style: AppTextStyles.titleSmall(
                                      color: controller.isFree(
                                        venue,
                                        controller.selectedDate(),
                                      )
                                          ? colors.primaryInk
                                          : colors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: sh * 0.025),

                            // ── Reviews ──
                            Text(
                              'Reviews ${controller.reviewsText(venue)}',
                              style: AppTextStyles.h3(),
                            ),
                            const SizedBox(height: 12),
                            if (venue.reviews.isEmpty)
                              Text(
                                'No reviews yet.',
                                style: AppTextStyles.bodyMedium(
                                  color: colors.textMuted,
                                ),
                              ),
                            Column(
                              children: venue.reviews.map((review) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ReviewCard(
                                    initials: AppFormat.initials(
                                      review.customerName,
                                    ),
                                    name: review.customerName,
                                    subtitle: review.eventLine,
                                    rating: review.rating,
                                    text: review.text,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ════════ BOTTOM BAR (stays in place, does not scroll) ════════
              Container(
                color: colors.bgSurface,
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Divider(color: colors.border, height: 1),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: sw * 0.05,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rent per event',
                                  style: AppTextStyles.caption(
                                    color: colors.textMuted,
                                  ),
                                ),
                                Text(
                                  AppFormat.rupees(venue.rent),
                                  style: AppTextStyles.h2(),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: sw * 0.46,
                              child: ActionButton(
                                label: 'Request booking',
                                height: 52,
                                bgColor: colors.primary,
                                borderColor: colors.primary,
                                textColor: colors.textOnPrimary,
                                // The selected day is sent along, so the
                                // request starts on that date
                                onTap: () {
                                  Get.to(
                                    () => BookingRequestScreen(
                                      venueId: venue.id,
                                      startDate: controller.selectedDate(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
