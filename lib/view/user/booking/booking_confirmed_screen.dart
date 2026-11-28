import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/booking/booking_detail_screen.dart';
import 'package:hall_mate/view/user/nav_bar_widget.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/detail_row.dart';

// Booking confirmed + receipt. Opens after paying, and from "Receipt".
class BookingConfirmedScreen extends StatelessWidget {
  final String bookingId;

  const BookingConfirmedScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final AppDataController data = Get.find<AppDataController>();
    final BookingModel booking = data.bookingById(bookingId);

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: sh * 0.07),

                      // ── Big green tick ──
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
                      Text(
                        '${booking.venueName} has booked\n'
                        '${AppFormat.shortDate(booking.eventDate)} for you.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(color: colors.textMuted),
                      ),
                      SizedBox(height: sh * 0.03),

                      // ── Receipt ──
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
                            DetailRow(label: 'Booking ID', value: booking.id),
                            const SizedBox(height: 12),
                            DetailRow(label: 'Venue', value: booking.venueName),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Date',
                              value: AppFormat.dateWithYear(booking.eventDate),
                            ),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Event & guests',
                              value: '${booking.eventType} · ${booking.guests}',
                            ),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Agreed price',
                              value: AppFormat.rupees(booking.agreedAmount()),
                            ),
                            const SizedBox(height: 12),
                            Divider(color: colors.borderDashed, height: 1),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Advance paid',
                              badge: 'Paid',
                              value: AppFormat.rupees(booking.advance()),
                            ),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Paid with',
                              value: booking.paymentMethod,
                            ),
                            const SizedBox(height: 12),
                            DetailRow(
                              label: 'Balance at the venue',
                              value: AppFormat.rupees(booking.balance()),
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

            // ── Buttons ──
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
                    onTap: () {
                      Get.off(() => BookingDetailScreen(bookingId: booking.id));
                    },
                  ),
                  const SizedBox(height: 10),
                  ActionButton(
                    label: 'Download receipt',
                    icon: Icons.download_outlined,
                    height: 52,
                    bgColor: colors.bgSurface,
                    borderColor: colors.borderStrong,
                    textColor: colors.textPrimary,
                    onTap: () {
                      Get.snackbar(
                        'Receipt',
                        'Downloading the receipt will be added later',
                      );
                    },
                  ),
                  TextButton(
                    // Back to the Home tab
                    onPressed: () {
                      Get.find<NavController>().changeIndex(0);
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
