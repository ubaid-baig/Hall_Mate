import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/counter_offer_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/widgets/common/action_button.dart';

// "Make a counter offer" bottom sheet.
// The customer opens it from Booking detail, the manager from Request detail.
class CounterOfferSheet extends StatelessWidget {
  final String bookingId;
  final bool isManager; // true = the manager is sending the offer

  const CounterOfferSheet({
    super.key,
    required this.bookingId,
    required this.isManager,
  });

  // Opens the sheet. The price field starts with their latest offer.
  static void show(BuildContext context, String bookingId, bool isManager) {
    final AppDataController data = Get.find<AppDataController>();
    final CounterOfferController controller = Get.put(CounterOfferController());
    controller.start(data.bookingById(bookingId));

    final colors = AppColors.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return CounterOfferSheet(bookingId: bookingId, isManager: isManager);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final AppDataController data = Get.find<AppDataController>();
    final CounterOfferController controller = Get.find<CounterOfferController>();
    final BookingModel booking = data.bookingById(bookingId);

    return SafeArea(
      child: Padding(
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

            Text('Make a counter offer', style: AppTextStyles.h2()),
            const SizedBox(height: 4),
            Text(
              controller.theirOfferText(booking),
              style: AppTextStyles.bodyMedium(color: colors.textSecondary),
            ),
            const SizedBox(height: 18),

            // ── Price field ──
            Text('Your price for the event', style: AppTextStyles.titleSmall()),
            const SizedBox(height: 8),
            TextField(
              controller: controller.priceController,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                controller.updatePrice(text);
              },
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
                hintText: 'Total rent in rupees',
                hintStyle: AppTextStyles.bodyLarge(color: colors.textMuted),
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

            // ── How it compares, and the advance ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colors.bgSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              // Obx: both lines change while you type
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.compareText(booking),
                      style: AppTextStyles.titleSmall(
                        color: colors.accentStrongInk,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.advanceText(),
                      style: AppTextStyles.bodySmall(color: colors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Unanswered offers expire after 24 hours.',
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
                    // Adds the offer to the shared booking, closes the sheet
                    onTap: () {
                      final bool isSent = controller.send(booking, isManager);
                      if (isSent) {
                        Navigator.pop(context);
                        Get.snackbar(
                          'Counter offer sent',
                          isManager
                              ? 'The customer has 24 hours to reply'
                              : 'The venue has 24 hours to reply',
                        );
                      }
                    },
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
