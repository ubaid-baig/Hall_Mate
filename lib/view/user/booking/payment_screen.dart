import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/user/booking/payment_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/widgets/common/action_button.dart';
import 'package:hall_mate/widgets/common/detail_row.dart';
import '../../../widgets/user/booking/payment_method_tile.dart';

// Pay the 25% advance of the agreed price.
class PaymentScreen extends StatelessWidget {
  final String bookingId;

  const PaymentScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final PaymentController controller = Get.put(PaymentController());
    final AppDataController data = Get.find<AppDataController>();

    // The maths comes from the booking:
    // advance = price ÷ 4, balance = price - advance
    final BookingModel booking = data.bookingById(bookingId);

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
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
                      Text('Pay advance', style: AppTextStyles.h3()),
                      const SizedBox(height: 2),
                      Text(
                        'Booking ${booking.id}',
                        style: AppTextStyles.caption(color: colors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

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
                        // ── Green card: the amount to pay now ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Advance to confirm (25%)',
                                style: AppTextStyles.bodyMedium(
                                  color: colors.textOnPrimaryMute,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                AppFormat.rupees(booking.advance()),
                                style: AppTextStyles.h1(color: colors.textOnPrimary),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.summaryLine(booking),
                                style: AppTextStyles.bodySmall(
                                  color: colors.textOnPrimaryMute,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Price rows ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.bgSurface,
                            border: Border.all(color: colors.border),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              DetailRow(
                                label: 'Agreed price',
                                value: AppFormat.rupees(booking.agreedAmount()),
                              ),
                              const SizedBox(height: 12),
                              DetailRow(
                                label: 'Event',
                                value: '${booking.eventType} · ${booking.guests} guests',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.borderDashed, height: 1),
                              const SizedBox(height: 12),
                              DetailRow(
                                label: 'Pay now (25%)',
                                value: AppFormat.rupees(booking.advance()),
                                valueColor: colors.primaryInk,
                              ),
                              const SizedBox(height: 12),
                              DetailRow(
                                label: 'Balance at the venue',
                                value: AppFormat.rupees(booking.balance()),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: sh * 0.025),

                        // ── Payment method ──
                        Text('Payment method', style: AppTextStyles.h3()),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: colors.bgSurface,
                            border: Border.all(color: colors.border),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          // Obx: the green tick moves when another method is tapped
                          child: Obx(
                            () => Column(
                              children: controller.methods.map((method) {
                                final int index = controller.methods.indexOf(method);
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectMethod(index);
                                  },
                                  child: PaymentMethodTile(
                                    iconType: method['iconType']!,
                                    title: method['title']!,
                                    subtitle: method['subtitle']!,
                                    isSelected: index ==
                                        controller.selectedMethodIndex.value,
                                    isFirst: index == 0,
                                    isLast: index == controller.methods.length - 1,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Note ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colors.primarySoft,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: colors.primaryInk,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Your date, ${AppFormat.shortDate(booking.eventDate)}, '
                                  'is confirmed as soon as the advance is paid.',
                                  style: AppTextStyles.bodySmall(
                                    color: colors.textSecondary,
                                  ),
                                ),
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

            // ── Pay button (stays in place) ──
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
                    child: ActionButton(
                      label: 'Pay ${AppFormat.rupees(booking.advance())}',
                      icon: Icons.lock_outline,
                      height: 52,
                      bgColor: colors.primary,
                      borderColor: colors.primary,
                      textColor: colors.textOnPrimary,
                      onTap: () {
                        controller.pay(booking);
                      },
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
