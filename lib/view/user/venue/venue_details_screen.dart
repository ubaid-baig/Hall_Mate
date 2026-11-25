import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/user/venue/venue_detail_controller.dart';
import 'package:hall_mate/controller/user/venue/favourite_controller.dart';
import 'package:hall_mate/view/user/booking/booking_request_screen.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/user/venue/date_chip.dart';
import 'package:hall_mate/widgets/user/venue/feature_tile.dart';
import 'package:hall_mate/widgets/user/venue/package_card.dart';
import 'package:hall_mate/widgets/user/venue/review_card.dart';
import 'package:hall_mate/view/user/venue/media_gallery_screen.dart';

class VenueDetailScreen extends StatelessWidget {
  const VenueDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final VenueDetailController controller = Get.put(VenueDetailController());
    // The saved venues (hearts). Created once in main.dart.
    final FavouriteController favController = Get.find<FavouriteController>();

    final double dateWidth = (sw * 0.9 - 36) / 7;

    return Scaffold(
      backgroundColor: colors.photoEmerald,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ════════ COVER PHOTO ════════
                    Container(
                      width: double.infinity,
                      height: sh * 0.32,
                      color: colors.photoEmerald,
                      padding: EdgeInsets.fromLTRB(
                        sw * 0.045,
                        sh * 0.018,
                        sw * 0.045,
                        sh * 0.025,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Row(
                                children: [
                                  GestureDetector(
                                    // Later: share the venue link
                                    onTap: () {},
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: colors.bgSurface,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.share_outlined,
                                        size: 20,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // The heart: save or unsave this venue.
                                  // Obx: it turns red / empty straight away.
                                  Obx(() {
                                    final bool isSaved =
                                    favController.isSaved(controller.name);

                                    return GestureDetector(
                                      onTap: () {
                                        favController.toggleFavourite(
                                          controller.cardData(),
                                        );
                                      },
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: colors.bgSurface,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isSaved
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 22,
                                          color: isSaved
                                              ? colors.iconHeart
                                              : colors.textPrimary,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),

                          // Middle: the photo placeholder (icon + text)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 36,
                                    color: colors.photoEmeraldInk,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.coverLabel,
                                    style: AppTextStyles.labelSmall(
                                      color: colors.photoEmeraldInk,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom row: photo counter (left), video button (right)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                // Opens the Media gallery screen
                                onTap: () {
                                  Get.to(() => const MediaGalleryScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    controller.photoCountText,
                                    style: AppTextStyles.labelSmall(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                // Opens the Media gallery screen (Later: on the Videos tab)
                                onTap: () {
                                  Get.to(() => const MediaGalleryScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.bgSurface,
                                    borderRadius: BorderRadius.circular(20),
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
                                        controller.videoText,
                                        style: AppTextStyles.labelSmall(),
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

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: sw * 0.05,
                        right: sw * 0.05,
                        top: 20,
                        bottom: 24,
                      ),
                      decoration: BoxDecoration(
                        color: colors.bgSurface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Type chip and Verified chip ──
                          Row(
                            children: [
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
                                  controller.type,
                                  style: AppTextStyles.labelSmall(
                                    color: colors.primaryInk,
                                  ),
                                ),
                              ),
                              if (controller.isVerified) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.accentSoft,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.verified_user_outlined,
                                        size: 16,
                                        color: colors.accentStrongInk,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        controller.verifiedText,
                                        style: AppTextStyles.labelSmall(
                                          color: colors.accentStrongInk,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ── Name, location, rating ──
                          Text(controller.name, style: AppTextStyles.h1()),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: colors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                controller.location,
                                style: AppTextStyles.bodyMedium(
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: colors.iconStar,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                controller.rating,
                                style: AppTextStyles.titleSmall(),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                controller.reviewsText,
                                style: AppTextStyles.bodySmall(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: sh * 0.022),

                          // ── 3 feature tiles ──
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FeatureTile(
                                  iconType: controller.features[0]['icon']!,
                                  label: controller.features[0]['label']!,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FeatureTile(
                                  iconType: controller.features[1]['icon']!,
                                  label: controller.features[1]['label']!,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FeatureTile(
                                  iconType: controller.features[2]['icon']!,
                                  label: controller.features[2]['label']!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: sh * 0.028),

                          // ── About ──
                          Text('About', style: AppTextStyles.h3()),
                          const SizedBox(height: 8),
                          Text(
                            controller.about,
                            style: AppTextStyles.bodyMedium(
                              color: colors.textSecondary,
                            ),
                          ),
                          SizedBox(height: sh * 0.028),

                          // ── Packages ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Packages', style: AppTextStyles.h3()),
                              Text(
                                controller.minGuestsText,
                                style: AppTextStyles.caption(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Tap a package to select it (green look).
                          // Obx: the green look moves when the other card is tapped.
                          Obx(
                                () => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.selectPackage(0);
                                    },
                                    child: PackageCard(
                                      name: controller.packages[0]['name'],
                                      price: controller.packages[0]['price'],
                                      features: controller.packages[0]['features'],
                                      isPopular: controller.packages[0]['isPopular'],
                                      isSelected:
                                      controller.selectedPackageIndex.value == 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.selectPackage(1);
                                    },
                                    child: PackageCard(
                                      name: controller.packages[1]['name'],
                                      price: controller.packages[1]['price'],
                                      features: controller.packages[1]['features'],
                                      isPopular: controller.packages[1]['isPopular'],
                                      isSelected:
                                      controller.selectedPackageIndex.value == 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: sh * 0.028),

                          // ── Free dates ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.freeDatesTitle,
                                style: AppTextStyles.h3(),
                              ),
                              TextButton(
                                // Later: open the full calendar
                                onPressed: () {},
                                child: Text(
                                  'Full calendar',
                                  style: AppTextStyles.titleSmall(
                                    color: colors.primaryInk,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Obx: the green day moves when another day is tapped.
                          // The value is read here first, because ListView builds
                          // the days a moment later, outside the Obx.
                          Obx(() {
                            final int selected = controller.selectedDateIndex.value;

                            return SizedBox(
                              height: 72,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.dates.length,
                                itemBuilder: (context, index) {
                                  final day = controller.dates[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.selectDate(index);
                                      },
                                      child: SizedBox(
                                        width: dateWidth,
                                        child: DateChip(
                                          day: day['day'],
                                          date: day['date'],
                                          isLunchFree: day['isLunchFree'],
                                          isDinnerFree: day['isDinnerFree'],
                                          isSelected: selected == index,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                          const SizedBox(height: 12),

                          // The grey box about the selected day.
                          // Obx: its text changes when another day is tapped.
                          Obx(
                                () => Container(
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Expanded: a long text wraps instead of
                                  // pushing the status off the screen
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: AppTextStyles.titleSmall(
                                          color: colors.textPrimary,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: controller.selectedDateText(),
                                          ),
                                          TextSpan(
                                            text: controller.selectedDateNote(),
                                            style: AppTextStyles.bodySmall(
                                              color: colors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          // green when a slot is free, grey when not
                                          color: controller.isSelectedDayFree()
                                              ? colors.success
                                              : colors.borderStrong,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        controller.selectedDateStatus(),
                                        style: AppTextStyles.titleSmall(
                                          color: controller.isSelectedDayFree()
                                              ? colors.primaryInk
                                              : colors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Legend: what the bars mean
                          Row(
                            children: [
                              Container(
                                width: 14,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: colors.success,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Free (lunch | dinner)',
                                style: AppTextStyles.caption(
                                  color: colors.textMuted,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 14,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: colors.borderStrong,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Booked',
                                style: AppTextStyles.caption(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: sh * 0.022),

                          // ── Reviews ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Reviews', style: AppTextStyles.h3()),
                              TextButton(
                                // Later: open the full reviews list
                                onPressed: () {},
                                child: Text(
                                  controller.seeAllReviewsText,
                                  style: AppTextStyles.titleSmall(
                                    color: colors.primaryInk,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Column(
                            // API: one card for every review in the list
                            children: controller.reviews.map((review) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ReviewCard(
                                  initials: review['initials'],
                                  name: review['name'],
                                  subtitle: review['subtitle'],
                                  rating: review['rating'],
                                  text: review['text'],
                                  managerReply: review['managerReply'],
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
                          // Obx: the package and price change when a package is tapped
                          Obx(
                                () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // "Gold package" (changes when a package is tapped)
                                  controller.selectedPackageLabel(),
                                  style: AppTextStyles.caption(
                                    color: colors.textMuted,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: AppTextStyles.h2(
                                      color: colors.textPrimary,
                                    ),
                                    children: [
                                      // The price of the selected package
                                      TextSpan(
                                        text: controller.selectedPackagePrice(),
                                      ),
                                      TextSpan(
                                        text: ' / head',
                                        style: AppTextStyles.bodySmall(
                                          color: colors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: sw * 0.46,
                            child: ActionButton(
                              label: 'Request booking',
                              height: 52,
                              bgColor: colors.primary,
                              borderColor: colors.primary,
                              textColor: colors.textOnPrimary,
                              onTap: () {
                                Get.to(() => const BookingRequestScreen());
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
        ),
      ),
    );
  }
}