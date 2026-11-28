import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/user/booking/booking_card.dart';
import 'package:hall_mate/controller/user/booking/bookings_controller.dart';
import 'package:hall_mate/model/booking_model.dart';

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
            // Obx: the green chip moves when another chip is tapped.
            // The value is read here first, because ListView builds the
            // chips a moment later, outside the Obx.
            Obx(() {
            final int selected = controller.selectedFilterIndex.value;
            final List<String> counts = controller.allCounts();

            return SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // API: one chip for All and one for every status
                itemCount: controller.filters.length,
                itemBuilder: (context, index) {
                  final bool isSelected = selected == index;

                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? sw * 0.05 : 0,
                      right: 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        controller.selectFilter(index);
                      },
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
                              controller.filters[index],
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
                                // how many bookings have this status
                                counts[index],
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
            );
            }),
            SizedBox(height: sh * 0.018),

            // ── Bookings list (this part scrolls up and down) ──
            Expanded(
              // Obx: the list changes when a chip is tapped
              child: Obx(() {
                final List<BookingModel> list = controller.filteredBookings();

                if (list.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                    child: Text(
                      'No bookings here yet',
                      style: AppTextStyles.bodyMedium(color: colors.textMuted),
                    ),
                  );
                }

                return SingleChildScrollView(
                child: Column(
                  // API: one card for every booking in the list
                  children: list.map((booking) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: sw * 0.05,
                        right: sw * 0.05,
                        bottom: sh * 0.015,
                      ),
                      child: BookingCard(
                        venueName: booking.venueName,
                        details: controller.detailsText(booking),
                        status: booking.status,
                        infoText: controller.infoText(booking),
                        buttonText: controller.buttonText(booking),
                        isButtonFilled: controller.isButtonFilled(booking),
                        photo: controller.photoOf(booking),
                        onPressed: () {
                          controller.openBooking(booking);
                        },
                      ),
                    );
                  }).toList(),
                ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
