import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/user/booking/booking_detail_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/booking/booking_confirmed_screen.dart';
import 'package:hall_mate/view/user/booking/payment_screen.dart';
import 'package:hall_mate/view/user/booking/write_review_screen.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/booking_step_tracker.dart';
import 'package:hall_mate/widgets/common/counter_offer_sheet.dart';
import 'package:hall_mate/widgets/common/info_tile.dart';
import 'package:hall_mate/widgets/common/media_box.dart';
import 'package:hall_mate/widgets/common/offer_bubble.dart';
import 'package:hall_mate/widgets/common/status_chip.dart';

// Booking detail & negotiation (customer view).
// It gets the booking's id and reads the booking from the shared list,
// so a counter offer from the manager shows here straight away.
class BookingDetailScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final BookingDetailController controller = Get.put(
      BookingDetailController(),
    );
    final AppDataController data = Get.find<AppDataController>();

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        // Obx: the whole screen follows the booking (offers, status ...)
        child: Obx(() {
          final BookingModel booking = data.bookingById(bookingId);

          return Column(
            children: [
              // ── Top bar: back arrow and booking code ──
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
                          Text('Booking ${booking.id}', style: AppTextStyles.h3()),
                          const SizedBox(height: 2),
                          Text(
                            'Requested on ${AppFormat.dayMonthYear(booking.requestedOn())}',
                            style: AppTextStyles.caption(color: colors.textMuted),
                          ),
                        ],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking.venueName,
                                          style: AppTextStyles.titleMedium(),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppFormat.dateWithYear(
                                            booking.eventDate,
                                          ),
                                          style: AppTextStyles.bodySmall(
                                            color: colors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  StatusChip(status: booking.status),
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
                                      AppFormat.initials(
                                        data.venueById(booking.venueId).managerName,
                                      ),
                                      style: AppTextStyles.labelSmall(
                                        color: colors.primaryInk,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Venue manager',
                                          style: AppTextStyles.caption(
                                            color: colors.textMuted,
                                          ),
                                        ),
                                        Text(
                                          data.venueById(booking.venueId).managerName,
                                          style: AppTextStyles.titleSmall(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    // Opens the chat with this venue
                                    onTap: () {
                                      controller.openChat(booking);
                                    },
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
                                value: '${booking.guests}',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InfoTile(
                                label: 'Event',
                                value: booking.eventType,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: InfoTile(
                                label: 'Listed rent',
                                value: AppFormat.rupees(booking.listedRent),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InfoTile(
                                label: 'Date',
                                value: AppFormat.shortDate(booking.eventDate),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // ── Status steps (not shown for a declined request) ──
                        if (booking.status != 'Declined')
                          BookingStepTracker(
                            steps: controller.steps,
                            currentIndex: booking.stepIndex(),
                          ),
                        SizedBox(height: sh * 0.025),

                        // ── Offers ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Offers', style: AppTextStyles.h3()),
                            Text(
                              'Each offer expires after 24 h',
                              style: AppTextStyles.caption(
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: sh * 0.012),
                        // One card for every offer. Mine on the right (green),
                        // the venue's on the left (white).
                        Column(
                          children: booking.offers.map((offer) {
                            final int index = booking.offers.indexOf(offer);
                            final bool isMine = !offer.byManager;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Align(
                                alignment: isMine
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: SizedBox(
                                  width: sw * 0.72,
                                  child: OfferBubble(
                                    sender: controller.offerSender(booking, offer),
                                    isMine: isMine,
                                    price: AppFormat.rupees(offer.amount),
                                    note: controller.offerNote(booking, offer),
                                    tag: controller.offerTag(booking, index),
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

              // ── Bottom bar: the buttons change with the status ──
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
                          Text(
                            controller.bottomNote(booking),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption(color: colors.textMuted),
                          ),

                          // My turn: counter or accept the venue's price
                          if (booking.isCustomerTurn()) ...[
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
                                    // Opens the "Make a counter offer" sheet
                                    onTap: () {
                                      CounterOfferSheet.show(
                                        context,
                                        booking.id,
                                        false,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ActionButton(
                                    label: controller.acceptText(booking),
                                    bgColor: colors.primary,
                                    borderColor: colors.primary,
                                    textColor: colors.textOnPrimary,
                                    onTap: () {
                                      controller.accept(booking);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // The venue's turn: nothing to press yet
                          if (booking.isManagerTurn()) ...[
                            const SizedBox(height: 10),
                            ActionButton(
                              label: 'Waiting for reply',
                              bgColor: colors.bgSubtle,
                              borderColor: colors.border,
                              textColor: colors.textMuted,
                              onTap: () {
                                Get.snackbar(
                                  'Waiting for reply',
                                  'You can answer once the venue replies',
                                );
                              },
                            ),
                          ],

                          if (booking.status == 'Accepted') ...[
                            const SizedBox(height: 10),
                            ActionButton(
                              label:
                                  'Pay ${AppFormat.rupees(booking.advance())} advance',
                              icon: Icons.lock_outline,
                              bgColor: colors.primary,
                              borderColor: colors.primary,
                              textColor: colors.textOnPrimary,
                              onTap: () {
                                Get.to(() => PaymentScreen(bookingId: booking.id));
                              },
                            ),
                          ],

                          if (booking.status == 'Confirmed') ...[
                            const SizedBox(height: 10),
                            ActionButton(
                              label: 'View receipt',
                              bgColor: colors.bgSurface,
                              borderColor: colors.primaryBorder,
                              textColor: colors.primaryInk,
                              onTap: () {
                                Get.to(
                                  () => BookingConfirmedScreen(
                                    bookingId: booking.id,
                                  ),
                                );
                              },
                            ),
                          ],

                          if (booking.status == 'Completed' &&
                              !booking.isReviewed) ...[
                            const SizedBox(height: 10),
                            ActionButton(
                              label: 'Write a review',
                              icon: Icons.star_outline_rounded,
                              bgColor: colors.primary,
                              borderColor: colors.primary,
                              textColor: colors.textOnPrimary,
                              onTap: () {
                                Get.to(
                                  () => WriteReviewScreen(bookingId: booking.id),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
