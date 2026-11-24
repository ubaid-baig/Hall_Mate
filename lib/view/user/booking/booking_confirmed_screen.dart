import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/view/user/nav_bar_widget.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/detail_row.dart';

import '../../../controller/user/booking/booking_confirmed_controller.dart';

// Booking confirmed: the receipt after the advance is paid.
class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final BookingConfirmedController controller = Get.put(
      BookingConfirmedController(),
    );

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ════════ TOP PART (this part scrolls if the screen is small) ════════
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: sh * 0.07),

                      // The big check mark: a light circle with a green circle inside
                      Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          color: colors.primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 38,
                              color: colors.textOnPrimary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sh * 0.025),
                      Text('Booking confirmed!', style: AppTextStyles.h1()),
                      const SizedBox(height: 8),
                      // API: venue name, date and slot
                      Text(
                        controller.subtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(color: colors.textMuted),
                      ),
                      SizedBox(height: sh * 0.03),

                      // ── Receipt card ──
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.bgSubtle,
                          border: Border.all(color: colors.border),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            DetailRow(
                              label: 'Booking ID',
                              value: controller.bookingId,
                            ),
                            const SizedBox(height: 12),
                            DetailRow(label: 'Venue', value: controller.venue),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Date & slot',
                              value: controller.dateAndSlot,
                            ),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Guests & package',
                              value: controller.guestsAndPackage,
                            ),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Agreed price',
                              value: controller.agreedPrice,
                            ),
                            const SizedBox(height: 12),
                            // Figma has a dashed line here. Flutter has no
                            // dashed line without a package, so it is plain.
                            Divider(color: colors.borderDashed, height: 1),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Advance paid',
                              badge: 'Paid',
                              value: controller.advancePaid,
                            ),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Balance due after event',
                              value: controller.balanceDue,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sh * 0.02),
                    ],
                  ),
                ),
              ),
            ),

            // ════════ BUTTONS (stay at the bottom) ════════
            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.05,
                top: 8,
                bottom: 8,
              ),
              child: Column(
                children: [
                  ActionButton(
                    label: 'View booking',
                    height: 52,
                    bgColor: colors.primary,
                    borderColor: colors.primary,
                    textColor: colors.textOnPrimary,
                    // Later: open the Booking detail screen of this booking
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  ActionButton(
                    label: 'Download receipt',
                    icon: Icons.download_outlined,
                    height: 52,
                    bgColor: colors.bgSurface,
                    borderColor: colors.borderStrong,
                    textColor: colors.textPrimary,
                    // Later: save the receipt as a PDF
                    onTap: () {},
                  ),
                  TextButton(
                    // Goes back to the home screen with the bottom bar.
                    // Get.offAll removes every screen behind it.
                    onPressed: () {
                      Get.offAll(() => const NavBarWidget());
                    },
                    child: Text(
                      'Back to home',
                      style: AppTextStyles.titleSmall(color: colors.primaryInk),
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
