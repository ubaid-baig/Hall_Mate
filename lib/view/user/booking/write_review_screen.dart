import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/media_box.dart';
import 'package:hall_mate/widgets/common/star_row.dart';
import '../../../controller/user/booking/write_review_controller.dart';

// Write a review. Opens for a Completed booking.
class WriteReviewScreen extends StatelessWidget {
  final String bookingId;

  const WriteReviewScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final WriteReviewController controller = Get.put(WriteReviewController());
    final AppDataController data = Get.find<AppDataController>();
    final BookingModel booking = data.bookingById(bookingId);

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.05,
                vertical: 12,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Write a review', style: AppTextStyles.h3()),
                      const SizedBox(height: 2),
                      Text(
                        booking.venueName,
                        style: AppTextStyles.caption(color: colors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

            Expanded(
              child: Container(
                width: double.infinity,
                color: colors.bgScreen,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Venue card ──
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.bgSurface,
                            border: Border.all(color: colors.border),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              MediaBox(
                                media: data
                                    .venueById(booking.venueId)
                                    .coverOrPlaceholder(),
                                width: 52,
                                height: 52,
                                showLabel: false,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      booking.venueName,
                                      style: AppTextStyles.titleMedium(),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.eventLine(booking),
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
                        SizedBox(height: sh * 0.03),

                        // ── Overall stars ──
                        Center(
                          child: Text(
                            'How was your event?',
                            style: AppTextStyles.h2(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          // Obx: the stars fill up to the tapped one
                          child: Obx(
                            () => StarRow(
                              rating: controller.overallRating.value,
                              size: 40,
                              gap: 8,
                              onStarTap: (stars) {
                                controller.setOverallRating(stars);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Obx(
                            () => Text(
                              controller.ratingLabel(),
                              style: AppTextStyles.titleMedium(
                                color: colors.primaryInk,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: sh * 0.03),

                        // ── Review text ──
                        Text(
                          'Tell others about it',
                          style: AppTextStyles.titleMedium(),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colors.bgSurface,
                            border: Border.all(
                              color: colors.primaryBorder,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: controller.reviewController,
                                keyboardType: TextInputType.multiline,
                                onChanged: (text) {
                                  controller.updateLetterCount(text);
                                },
                                minLines: 4,
                                maxLines: 4,
                                style: AppTextStyles.bodyLarge(),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: 'What did you like? What could be better?',
                                  hintStyle: AppTextStyles.bodyLarge(
                                    color: colors.textMuted,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Obx(
                                  () => Text(
                                    controller.counterText(),
                                    style: AppTextStyles.caption(
                                      color: colors.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Post button ──
            Container(
              color: colors.bgSurface,
              child: Column(
                children: [
                  Divider(color: colors.border, height: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: 12,
                    ),
                    child: ActionButton(
                      label: 'Post review',
                      height: 52,
                      bgColor: colors.primary,
                      borderColor: colors.primary,
                      textColor: colors.textOnPrimary,
                      onTap: () {
                        controller.postReview(booking);
                      },
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
