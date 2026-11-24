import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/photo_placeholder.dart';
import 'package:hall_mate/widgets/common/star_row.dart';
import '../../../controller/user/booking/write_review_controller.dart';

class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final WriteReviewController controller = Get.put(WriteReviewController());

    return Scaffold(
      // White, so the status bar area matches the white top bar and bottom bar.
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [

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
                        controller.venueName,
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
                              PhotoPlaceholder(
                                photoStyle: controller.photo,
                                width: 52,
                                height: 52,
                                iconSize: 22,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.venueName,
                                      style: AppTextStyles.titleMedium(),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.eventLine,
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

                        Center(
                          child: Text(
                            'How was your event?',
                            style: AppTextStyles.h2(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: StarRow(
                            rating: controller.overallRating,
                            size: 40,
                            gap: 8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            controller.ratingLabel,
                            style: AppTextStyles.titleMedium(
                              color: colors.primaryInk,
                            ),
                          ),
                        ),
                        SizedBox(height: sh * 0.025),

                        // ── Category ratings ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colors.bgSurface,
                            border: Border.all(color: colors.border),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            // API: one row for every category
                            children: controller.categories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        category['label'],
                                        style: AppTextStyles.bodyMedium(),
                                      ),
                                    ),
                                    StarRow(rating: category['rating'], size: 18),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: sh * 0.025),

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
                                minLines: 4,
                                maxLines: 4,
                                style: AppTextStyles.bodyLarge(),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,

                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  controller.counterText,
                                  style: AppTextStyles.caption(
                                    color: colors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: sh * 0.025),

                        // ── Photos ──
                        Text(
                          'Add photos (optional)',
                          style: AppTextStyles.titleMedium(),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            PhotoPlaceholder(
                              photoStyle: 'marigold',
                              width: 64,
                              height: 64,
                              iconSize: 24,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            const SizedBox(width: 10),
                            PhotoPlaceholder(
                              photoStyle: 'emerald',
                              width: 64,
                              height: 64,
                              iconSize: 24,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            const SizedBox(width: 10),

                            GestureDetector(
                              // Later: pick a photo from the gallery
                              onTap: () {},
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: colors.bgSurface,
                                  border: Border.all(color: colors.borderDashed),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo_camera_outlined,
                                      size: 22,
                                      color: colors.textSecondary,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Add',
                                      style: AppTextStyles.labelTiny(
                                        color: colors.textSecondary,
                                      ),
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
                ),
              ),
            ),

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
                      onTap: () {},
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
