import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/booking_detail_controller.dart';
import 'package:hall_mate/widgets/action_button.dart';
import 'package:hall_mate/widgets/booking_step_tracker.dart';
import 'package:hall_mate/widgets/counter_offer_sheet.dart';
import 'package:hall_mate/widgets/info_tile.dart';
import 'package:hall_mate/widgets/offer_bubble.dart';
import 'package:hall_mate/widgets/photo_placeholder.dart';
import 'package:hall_mate/widgets/status_chip.dart';

// Booking detail & negotiation (customer view).
// Opens when a button on a booking card in "My bookings" is tapped.
class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final BookingDetailController controller = Get.put(
      BookingDetailController(),
    );

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: back arrow, booking code, "more" button ──
            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.05,
                top: sh * 0.015,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // API: booking code and request date
                        Text(
                          'Booking ${controller.bookingId}',
                          style: AppTextStyles.h3(),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.requestedOn,
                          style: AppTextStyles.caption(color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // Later: PopupMenuButton (like the to-do app) with
                    // "Cancel booking" and "Report a problem"
                    onTap: () {},
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.bgSurface,
                        border: Border.all(color: colors.border),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        size: 22,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.018),

            // ── Everything between the top bar and the bottom bar scrolls ──
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Venue summary card ──
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colors.bgSurface,
                          border: Border.all(color: colors.border),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            Row(
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
                                      // API: venue name and event date
                                      Text(
                                        controller.venueName,
                                        style: AppTextStyles.titleMedium(),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        controller.dateText,
                                        style: AppTextStyles.bodySmall(
                                          color: colors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // API: the booking status decides the colour
                                StatusChip(status: controller.status),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Divider(color: colors.border, height: 1),
                            const SizedBox(height: 12),

                            // Venue manager row with the chat button
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: colors.primarySoft,
                                  child: Text(
                                    // API: first letters of the manager's name
                                    controller.managerInitials,
                                    style: AppTextStyles.labelSmall(
                                      color: colors.primaryInk,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Venue manager',
                                        style: AppTextStyles.caption(
                                          color: colors.textMuted,
                                        ),
                                      ),
                                      Text(
                                        controller.managerName,
                                        style: AppTextStyles.titleSmall(),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  // Later: open the chat with this manager
                                  onTap: () {},
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: colors.bgSurface,
                                      border: Border.all(color: colors.border),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.chat_bubble_outline,
                                      size: 20,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── 4 info tiles (2 rows of 2) ──
                      Row(
                        children: [
                          Expanded(
                            child: InfoTile(
                              label: 'Guests',
                              value: controller.guests,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InfoTile(
                              label: 'Package',
                              value: controller.package,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InfoTile(
                              label: 'Listed price',
                              value: controller.listedPrice,
                              suffix: '/ head',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InfoTile(
                              label: 'Time',
                              value: controller.timeText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // ── Status steps ──
                      BookingStepTracker(
                        steps: controller.steps,
                        currentIndex: controller.currentStepIndex,
                      ),
                      SizedBox(height: sh * 0.025),

                      // ── Offers ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Offers', style: AppTextStyles.h3()),
                          Text(
                            'Each offer expires after 24 h',
                            style: AppTextStyles.caption(color: colors.textMuted),
                          ),
                        ],
                      ),
                      SizedBox(height: sh * 0.012),
                      Column(
                        // API: one bubble for every offer in the list.
                        // Offers sent by me sit on the right, the others on the left.
                        children: controller.offers.map((offer) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Align(
                              alignment: offer['isMine']
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: SizedBox(
                                width: sw * 0.72,
                                child: OfferBubble(
                                  sender: offer['sender'],
                                  isMine: offer['isMine'],
                                  price: offer['price'],
                                  total: offer['total'],
                                  time: offer['time'],
                                  tag: offer['tag'],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom bar (stays in place, does not scroll) ──
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
                    child: Column(
                      children: [
                        // API: who sent the latest offer and when it expires
                        Text(
                          controller.latestOfferNote,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption(color: colors.textMuted),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ActionButton(
                                label: 'Counter',
                                icon: Icons.swap_horiz,
                                bgColor: colors.bgSurface,
                                borderColor: colors.primaryBorder,
                                textColor: colors.primaryInk,
                                // Opens the "Make a counter offer" bottom sheet
                                onTap: () {
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
                                      return const CounterOfferSheet();
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ActionButton(
                                // API: the amount = latest offer price x guests
                                label: controller.acceptText,
                                bgColor: colors.primary,
                                borderColor: colors.primary,
                                textColor: colors.textOnPrimary,
                                // Later: accept the offer (POST /bookings/{id}/accept)
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
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
