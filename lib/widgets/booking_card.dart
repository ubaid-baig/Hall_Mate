import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/view/booking_detail_screen.dart';
import 'package:hall_mate/widgets/photo_placeholder.dart';
import 'package:hall_mate/widgets/status_chip.dart';
import 'package:hall_mate/view/write_review_screen.dart';

/// One booking in the "My bookings" list.
///
/// API: every value comes from one booking in your API list.
/// The button text and style depend on the status, for example:
///   Negotiating -> 'Reply' (filled)      Requested -> 'View' (outlined)
///   Confirmed   -> 'Receipt' (outlined)  Completed -> 'Write a review' (filled)
class BookingCard extends StatelessWidget {
  final String venueName; // API: venue name
  final String details; // API: date, slot and guests
  final String status; // API: booking status
  final String infoText; // small line on the left of the button
  final String buttonText; // text of the button
  final bool isButtonFilled; // true = green button, false = outlined button
  final String photoStyle; // DUMMY ONLY: placeholder colour

  const BookingCard({
    super.key,
    required this.venueName,
    required this.details,
    required this.status,
    required this.infoText,
    required this.buttonText,
    required this.isButtonFilled,
    required this.photoStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          // ── Top: photo, venue name, status chip, details ──
          Row(
            children: [
              PhotoPlaceholder(
                photoStyle: photoStyle,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            venueName,
                            style: AppTextStyles.titleLarge(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusChip(status: status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details,
                      style: AppTextStyles.bodySmall(color: colors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: colors.border, height: 1),
          const SizedBox(height: 12),

          // ── Bottom: info text and the action button ──
          Row(
            children: [
              Expanded(
                child: Text(
                  infoText,
                  style: AppTextStyles.bodySmall(color: colors.textSecondary),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  // A completed booking opens the Write review screen,
                  // every other booking opens the Booking detail screen.
                  // API: send this booking's id to the screen, for example
                  // Get.to(() => BookingDetailScreen(), arguments: bookingId)
                  // and load GET /bookings/{id} in BookingDetailController.
                  onPressed: () {
                    if (status == 'Completed') {
                      Get.to(() => const WriteReviewScreen());
                    } else {
                      Get.to(() => const BookingDetailScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isButtonFilled ? colors.primary : colors.bgSurface,
                    foregroundColor:
                        isButtonFilled ? colors.textOnPrimary : colors.primaryInk,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color:
                            isButtonFilled ? colors.primary : colors.primaryBorder,
                      ),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: AppTextStyles.titleSmall(
                      color:
                          isButtonFilled ? colors.textOnPrimary : colors.primaryInk,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
