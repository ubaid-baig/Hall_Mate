import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/request_detail_controller.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/booking_step_tracker.dart';
import 'package:hall_mate/widgets/common/counter_offer_sheet.dart';
import 'package:hall_mate/widgets/common/info_tile.dart';
import 'package:hall_mate/widgets/common/offer_bubble.dart';
import 'package:hall_mate/widgets/common/status_chip.dart';

// Request detail & negotiation (manager view).
// It is built like the customer's Booking detail and reads the SAME
// booking, so both sides always see the same offers and status.
class RequestDetailScreen extends StatelessWidget {
  final String bookingId;

  const RequestDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final RequestDetailController controller = Get.put(
      RequestDetailController(),
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
                        // ── Customer card ──
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
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: colors.photoMarigold,
                                    child: Text(
                                      AppFormat.initials(booking.customerName),
                                      style: AppTextStyles.titleSmall(
                                        color: colors.photoMarigoldInk,
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
                                          booking.customerName,
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

                              // Phone number and the chat button
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    size: 20,
                                    color: colors.primaryInk,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Customer',
                                          style: AppTextStyles.caption(
                                            color: colors.textMuted,
                                          ),
                                        ),
                                        Text(
                                          booking.customerPhone,
                                          style: AppTextStyles.titleSmall(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    // Opens the chat with this customer
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
                        // One card for every offer. The venue's (mine) on the
                        // right in green, the customer's on the left in white.
                        Column(
                          children: booking.offers.map((offer) {
                            final int index = booking.offers.indexOf(offer);
                            final bool isMine = offer.byManager;
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

                          // My turn: counter, accept or decline
                          if (booking.isManagerTurn()) ...[
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
                                    // The same sheet the customer uses,
                                    // with byManager = true
                                    onTap: () {
                                      CounterOfferSheet.show(
                                        context,
                                        booking.id,
                                        true,
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
                            TextButton(
                              onPressed: () {
                                controller.decline(booking);
                              },
                              child: Text(
                                'Decline request',
                                style: AppTextStyles.titleSmall(
                                  color: colors.danger,
                                ),
                              ),
                            ),
                          ],

                          // The customer's turn: nothing to press yet
                          if (booking.isCustomerTurn()) ...[
                            const SizedBox(height: 10),
                            ActionButton(
                              label: 'Waiting for reply',
                              bgColor: colors.bgSubtle,
                              borderColor: colors.border,
                              textColor: colors.textMuted,
                              onTap: () {
                                Get.snackbar(
                                  'Waiting for reply',
                                  'You can answer once the customer replies',
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
