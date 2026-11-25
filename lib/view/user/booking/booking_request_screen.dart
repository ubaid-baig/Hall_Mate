import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/photo_placeholder.dart';
import 'package:hall_mate/widgets/user/booking/slot_card.dart';

import '../../../controller/user/booking/booking_request_controller.dart';
import '../../../widgets/user/booking/package_select_card.dart';

// Booking request. Opens from the "Request booking" button on Venue detail.
class BookingRequestScreen extends StatelessWidget {
  const BookingRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final BookingRequestController controller = Get.put(
      BookingRequestController(),
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
                        controller.venueName,
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
                              PhotoPlaceholder(
                                photoStyle: controller.photo,
                                width: 60,
                                height: 60,
                                iconSize: 24,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.venueName,
                                      style: AppTextStyles.titleMedium(),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.venueSubtitle,
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
                                // If a date is picked, it is sent to the controller.
                                onPressed: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: controller.eventDate.value,
                                    firstDate: DateTime(2026),
                                    lastDate: DateTime(2028),
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
                        SizedBox(height: sh * 0.025),

                        // ── Time slot ──
                        Text('Time slot', style: AppTextStyles.titleLarge()),
                        const SizedBox(height: 10),
                        // Obx: the green slot moves when the other one is tapped.
                        // (A booked slot cannot be selected, see selectSlot.)
                        Obx(
                              () => Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectSlot(0);
                                  },
                                  child: SlotCard(
                                    label: controller.slots[0]['label'],
                                    note: controller.slots[0]['note'],
                                    isAvailable: controller.slots[0]['isAvailable'],
                                    isSelected:
                                    controller.selectedSlotIndex.value == 0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectSlot(1);
                                  },
                                  child: SlotCard(
                                    label: controller.slots[1]['label'],
                                    note: controller.slots[1]['note'],
                                    isAvailable: controller.slots[1]['isAvailable'],
                                    isSelected:
                                    controller.selectedSlotIndex.value == 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: sh * 0.025),

                        // ── Guests: label (left) and - 300 + stepper (right) ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Guests', style: AppTextStyles.titleLarge()),
                                const SizedBox(height: 2),
                                Text(
                                  controller.guestsHint,
                                  style: AppTextStyles.caption(
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: colors.bgSurface,
                                border: Border.all(color: colors.border),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    // 10 guests fewer
                                    onTap: () {
                                      controller.removeGuests();
                                    },
                                    child: SizedBox(
                                      width: 44,
                                      height: 44,
                                      child: Icon(
                                        Icons.remove,
                                        size: 22,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 56,
                                    child: Center(
                                      // Obx: the number changes on - and +
                                      child: Obx(
                                            () => Text(
                                          '${controller.guests.value}',
                                          style: AppTextStyles.titleLarge(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    // 10 guests more
                                    onTap: () {
                                      controller.addGuests();
                                    },
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: colors.primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 22,
                                        color: colors.textOnPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: sh * 0.025),

                        // ── Package ──
                        Text('Package', style: AppTextStyles.titleLarge()),
                        const SizedBox(height: 10),
                        // Obx: the selected package moves when the other is tapped
                        Obx(
                              () => Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectPackage(0);
                                  },
                                  child: PackageSelectCard(
                                    name: controller.packages[0]['name'],
                                    price: controller.packages[0]['price'],
                                    isSelected:
                                    controller.selectedPackageIndex.value == 0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectPackage(1);
                                  },
                                  child: PackageSelectCard(
                                    name: controller.packages[1]['name'],
                                    price: controller.packages[1]['price'],
                                    isSelected:
                                    controller.selectedPackageIndex.value == 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: sh * 0.025),

                        // ── Your offer per head ──
                        Text(
                          'Your offer per head',
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
                                  // totals below change straight away.
                                  onChanged: (text) {
                                    controller.updateOffer(text);
                                  },
                                  style: AppTextStyles.h2(),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
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
                              Text(
                                '/ head',
                                style: AppTextStyles.bodyMedium(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Obx: changes with the offer and the package
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
                                  // Obx: these change with guests and offer
                                  Obx(
                                        () => Text(
                                      controller.guestsCalcText(),
                                      style: AppTextStyles.bodyMedium(
                                        color: colors.textMuted,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                        () => Text(
                                      controller.formatRs(controller.total()),
                                      style: AppTextStyles.titleMedium(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.advanceLabel,
                                    style: AppTextStyles.bodyMedium(
                                      color: colors.textMuted,
                                    ),
                                  ),
                                  Obx(
                                        () => Text(
                                      controller.formatRs(controller.advance()),
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
                              'Your total offer',
                              style: AppTextStyles.caption(
                                color: colors.textMuted,
                              ),
                            ),
                            // Obx: the same total as in the summary card
                            Obx(
                                  () => Text(
                                controller.formatRs(controller.total()),
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
                            // Checks the offer, goes back and shows "Request sent".
                            // Later (API): POST /bookings first.
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