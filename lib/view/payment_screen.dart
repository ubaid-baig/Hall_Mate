import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/payment_controller.dart';
import 'package:hall_mate/view/booking_confirmed_screen.dart';
import 'package:hall_mate/widgets/action_button.dart';
import 'package:hall_mate/widgets/detail_row.dart';
import 'package:hall_mate/widgets/payment_method_tile.dart';

// Pay advance. Opens after the customer accepts the final offer.
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final PaymentController controller = Get.put(PaymentController());

    return Scaffold(
      // White, so the status bar area matches the white top bar and bottom bar.
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
                      Text('Pay advance', style: AppTextStyles.h3()),
                      const SizedBox(height: 2),
                      Text(
                        'Booking ${controller.bookingId}',
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
                                controller.advanceLabel,
                                style: AppTextStyles.bodyMedium(
                                  color: colors.textOnPrimaryMute,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // API: 25% of the total
                              Text(
                                controller.advanceAmount,
                                style: AppTextStyles.h1(color: colors.textOnPrimary),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.summaryLine,
                                style: AppTextStyles.bodySmall(
                                  color: colors.textOnPrimaryMute,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Price card ──
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
                                value: controller.agreedPrice,
                              ),
                              const SizedBox(height: 12),
                              DetailRow(label: 'Guests', value: controller.guests),
                              const SizedBox(height: 12),
                              DetailRow(label: 'Total', value: controller.total),
                              const SizedBox(height: 12),
                              // Figma has a dashed line here. Flutter has no
                              // dashed line without a package, so it is plain.
                              Divider(color: colors.borderDashed, height: 1),
                              const SizedBox(height: 12),
                              DetailRow(
                                label: controller.payNowLabel,
                                value: controller.payNow,
                                valueColor: colors.primaryInk,
                              ),
                              const SizedBox(height: 12),
                              DetailRow(
                                label: 'Balance after the event',
                                value: controller.balance,
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
                          child: Column(
                            // API: one row for every payment method in the list
                            children: controller.methods.map((method) {
                              final int index = controller.methods.indexOf(method);

                              return PaymentMethodTile(
                                iconType: method['iconType']!,
                                title: method['title']!,
                                subtitle: method['subtitle']!,
                                // Later: tapping a row changes selectedMethodIndex
                                isSelected: index == controller.selectedMethodIndex,
                                isFirst: index == 0,
                                isLast: index == controller.methods.length - 1,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Info box ──
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
                                  controller.infoNote,
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
                    child: ActionButton(
                      // API: the advance amount
                      label: controller.payButtonText,
                      icon: Icons.lock_outline,
                      height: 52,
                      bgColor: colors.primary,
                      borderColor: colors.primary,
                      textColor: colors.textOnPrimary,
                      // Later: POST /payments first, and only if it works open the
                      // Booking confirmed screen. For now it opens it directly.
                      // Get.off replaces this screen, so Back does not return here.
                      onTap: () {
                        Get.off(() => const BookingConfirmedScreen());
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
