import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/guest_stepper.dart';
import 'package:hall_mate/widgets/common/media_box.dart';

import '../../../controller/user/booking/booking_request_controller.dart';

// Booking request. Opens from the "Request booking" button on Venue detail.
class BookingRequestScreen extends StatelessWidget {
  final String venueId;
  final DateTime startDate; // the day picked on Venue detail

  const BookingRequestScreen({
    super.key,
    required this.venueId,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);

    // Get.put makes the controller once. When the screen is built again
    // (for example when the keyboard opens) the same one is used,
    // so what you typed stays.
    final BookingRequestController controller = Get.put(
      BookingRequestController(venueId: venueId, startDate: startDate),
    );

    return Scaffold(
      // White, so the status bar area matches the white top bar and bottom bar.
      // The scrolling middle part has its own grey background below.
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ════════ TOP BAR ════════
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.05,
                vertical: 12,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Request booking', style: AppTextStyles.h3()),
                      const SizedBox(height: 2),
                      Text(
                        controller.venue().name,
                        style: AppTextStyles.caption(color: colors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

            // ════════ SCROLLING MIDDLE PART ════════
            Expanded(
              child: Container(
                width: double.infinity,
                color: colors.bgScreen,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Venue card ──
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.bgSurface,
                            border: Border.all(color: colors.border),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              MediaBox(
                                media: controller.venue().coverOrPlaceholder(),
                                width: 60,
                                height: 60,
                                showLabel: false,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.venue().name,
                                      style: AppTextStyles.titleMedium(),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${controller.venue().type} · ${controller.venue().area}',
                                      style: AppTextStyles.bodySmall(
                                        color: colors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: sh * 0.025),

                        // ── Event date ──
                        Text('Event date', style: AppTextStyles.titleLarge()),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 14, right: 4),
                          decoration: BoxDecoration(
                            color: colors.bgSurface,
                            border: Border.all(color: colors.border),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 22,
                                color: colors.primaryInk,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                // Obx: the text changes after a new date is picked
                                child: Obx(
                                  () => Text(
                                    controller.eventDateText(),
                                    style: AppTextStyles.titleSmall(),
                                  ),
                                ),
                              ),
                              TextButton(
                                // Opens the date picker (like in the to-do app).
                                // A booked date is refused by the controller.
                                onPressed: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: controller.eventDate.value,
                                    firstDate: AppFormat.today(),
                                    lastDate: DateTime(AppFormat.today().year + 2),
                                  );
                                  if (picked != null) {
                                    controller.changeDate(picked);
                                  }
                                },
                                child: Text(
                                  'Change',
                                  style: AppTextStyles.titleSmall(
                                    color: colors.primaryInk,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Obx: green when the date is free, red when it is taken
                        Obx(
                          () => Text(
                            controller.isDateFree()
                                ? 'This date is free'
                                : 'This date is booked, please pick another one',
                            style: AppTextStyles.bodySmall(
                              color: controller.isDateFree()
                                  ? colors.successInk
                                  : colors.danger,
                            ),
                          ),
                        ),
                        SizedBox(height: sh * 0.025),

                        // ── Event type (scrolls sideways) ──
                        Text('Event', style: AppTextStyles.titleLarge()),
                        const SizedBox(height: 10),
                        // Obx: the green chip moves when another one is tapped.
                        // The value is read here first, because ListView builds
                        // the chips a moment later, outside the Obx.
                        Obx(() {
                          final int selected = controller.selectedEventIndex.value;
                          return SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.eventTypes.length,
                              itemBuilder: (context, index) {
                                final bool isSelected = selected == index;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.selectEvent(index);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? colors.primary
                                            : colors.bgSurface,
                                        border: Border.all(
                                          color: isSelected
                                              ? colors.primary
                                              : colors.border,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          controller.eventTypes[index],
                                          style: AppTextStyles.titleSmall(
                                            color: isSelected
                                                ? colors.textOnPrimary
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                        SizedBox(height: sh * 0.025),

                        // ── Guests: label (left) and - 150 + stepper (right) ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Guests', style: AppTextStyles.titleLarge()),
                                const SizedBox(height: 2),
                                Text(
                                  controller.guestsHint(),
                                  style: AppTextStyles.caption(
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            // Obx: the number changes on - and + (10 at a time)
                            Obx(
                              () => GuestStepper(
                                value: '${controller.guests.value}',
                                onMinus: () {
                                  controller.removeGuests();
                                },
                                onPlus: () {
                                  controller.addGuests();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: sh * 0.025),

                        // ── Your offer for the event ──
                        Text(
                          'Your offer for the event',
                          style: AppTextStyles.titleLarge(),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: colors.bgSurface,
                            border: Border.all(
                              color: colors.primaryBorder,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Rs',
                                style: AppTextStyles.bodyLarge(
                                  color: colors.textMuted,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: controller.priceController,
                                  keyboardType: TextInputType.number,
                                  // Every key typed updates the offer, and the
                                  // numbers below change straight away.
                                  onChanged: (text) {
                                    controller.updateOffer(text);
                                  },
                                  style: AppTextStyles.h2(),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    // The box around the field is drawn by the
                                    // Container above, so the field's own
                                    // borders are see-through.
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Obx: changes while you type
                        Obx(
                          () => Text(
                            controller.compareText(),
                            style: AppTextStyles.bodySmall(
                              color: colors.accentStrongInk,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Summary card ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.bgSurface,
                            border: Border.all(color: colors.border),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Listed rent',
                                    style: AppTextStyles.bodyMedium(
                                      color: colors.textMuted,
                                    ),
                                  ),
                                  Text(
                                    AppFormat.rupees(controller.venue().rent),
                                    style: AppTextStyles.titleMedium(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '25% advance once accepted',
                                    style: AppTextStyles.bodyMedium(
                                      color: colors.textMuted,
                                    ),
                                  ),
                                  // Obx: 25% of what you type
                                  Obx(
                                    () => Text(
                                      AppFormat.rupees(controller.advance()),
                                      style: AppTextStyles.titleMedium(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.border, height: 1),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.schedule_outlined,
                                    size: 20,
                                    color: colors.primaryInk,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      controller.noteText,
                                      style: AppTextStyles.bodySmall(
                                        color: colors.textSecondary,
                                      ),
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
                ),
              ),
            ),

            // ════════ BOTTOM BAR (stays in place, does not scroll) ════════
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your offer',
                              style: AppTextStyles.caption(
                                color: colors.textMuted,
                              ),
                            ),
                            // Obx: the same number you type above
                            Obx(
                              () => Text(
                                AppFormat.rupees(controller.offer.value),
                                style: AppTextStyles.h2(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: sw * 0.46,
                          child: ActionButton(
                            label: 'Send request',
                            icon: Icons.send_outlined,
                            height: 52,
                            bgColor: colors.primary,
                            borderColor: colors.primary,
                            textColor: colors.textOnPrimary,
                            // Checks the offer and the date, adds the request
                            // to the shared list and opens the new booking.
                            onTap: () {
                              controller.sendRequest();
                            },
                          ),
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
