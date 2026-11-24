import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/user/booking/booking_card.dart';
import '../../../controller/user/booking/bookings_controller.dart';

// This is the "My bookings" tab.
class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final BookingsController controller = Get.put(BookingsController());

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.05,
                top: sh * 0.02,
              ),
              child: Text('My bookings', style: AppTextStyles.h1()),
            ),
            SizedBox(height: sh * 0.005),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: Text(
                'Track requests, offers and payments',
                style: AppTextStyles.bodyMedium(color: colors.textSecondary),
              ),
            ),
            SizedBox(height: sh * 0.02),

            // ── Status chips (scroll sideways) ──
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // API: one chip for All and one for every status
                itemCount: controller.filters.length,
                itemBuilder: (context, index) {
                  final filter = controller.filters[index];
                  final bool isSelected =
                      controller.selectedFilterIndex == index;

                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? sw * 0.05 : 0,
                      right: 8,
                    ),
                    child: GestureDetector(
                      // Later: set the selected chip in the controller
                      // and show only the bookings with that status.
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? colors.primary : colors.bgSurface,
                          border: Border.all(
                            color: isSelected ? colors.primary : colors.border,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              filter['label'],
                              style: AppTextStyles.titleSmall(
                                color: isSelected ? colors.textOnPrimary : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colors.accent
                                    : colors.bgSubtle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                filter['count'],
                                style: AppTextStyles.labelTiny(
                                  color: isSelected
                                      ? colors.textOnAccent
                                      : colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: sh * 0.018),

            // ── Bookings list (this part scrolls up and down) ──
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  // API: one card for every booking in the list
                  children: controller.bookings.map((booking) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: sw * 0.05,
                        right: sw * 0.05,
                        bottom: sh * 0.015,
                      ),
                      child: BookingCard(
                        venueName: booking['venueName'],
                        details: booking['details'],
                        status: booking['status'],
                        infoText: booking['infoText'],
                        buttonText: booking['buttonText'],
                        isButtonFilled: booking['isButtonFilled'],
                        photoStyle: booking['photo'],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
