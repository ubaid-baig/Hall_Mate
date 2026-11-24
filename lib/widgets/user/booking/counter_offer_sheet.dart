import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/user/booking/booking_detail_controller.dart';
import 'package:hall_mate/widgets/common/action_button.dart';

/// The content of the "Make a counter offer" bottom sheet.
///
/// It is opened from the Counter button on the Booking detail screen with
/// showModalBottomSheet (the dark area behind it is added by Flutter).
class CounterOfferSheet extends StatelessWidget {
  const CounterOfferSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    // Already created by the Booking detail screen
    final BookingDetailController controller =
        Get.find<BookingDetailController>();

    return SafeArea(
      child: Padding(
        // viewInsets.bottom is the keyboard height, so the keyboard
        // pushes the sheet up and does not cover the buttons.
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Small drag handle on top ──
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Title and the other side's latest offer ──
            Text('Make a counter offer', style: AppTextStyles.h2()),
            const SizedBox(height: 4),
            // API: the other side's latest offer
            Text(
              controller.theirLatestOfferText,
              style: AppTextStyles.bodyMedium(color: colors.textSecondary),
            ),
            const SizedBox(height: 18),

            // ── Price field ──
            Text('Your price per head', style: AppTextStyles.titleSmall()),
            const SizedBox(height: 8),
            TextField(
              controller: controller.priceController,
              keyboardType: TextInputType.number,
              style: AppTextStyles.bodyLarge(),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.bgSurface,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                prefixIcon: Icon(
                  Icons.sell_outlined,
                  size: 20,
                  color: colors.textSecondary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colors.primaryBorder, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Total: guests x price ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colors.bgSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.guestsCalcText,
                    style: AppTextStyles.bodySmall(color: colors.textMuted),
                  ),
                  Text(controller.totalText, style: AppTextStyles.titleSmall()),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              controller.expiryNote,
              style: AppTextStyles.caption(color: colors.textMuted),
            ),
            const SizedBox(height: 18),

            // ── Buttons ──
            Row(
              children: [
                SizedBox(
                  width: sw * 0.3,
                  child: ActionButton(
                    label: 'Cancel',
                    bgColor: colors.bgSurface,
                    borderColor: colors.borderStrong,
                    textColor: colors.textPrimary,
                    // Closes the sheet
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ActionButton(
                    label: 'Send counter offer',
                    icon: Icons.send_outlined,
                    bgColor: colors.primary,
                    borderColor: colors.primary,
                    textColor: colors.textOnPrimary,
                    // Later: send the new price to the API (POST /bookings/{id}/offers),
                    // then close the sheet with Navigator.pop(context).
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
