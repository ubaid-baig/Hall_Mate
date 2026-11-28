import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/common/status_chip.dart';

// One booking request in the manager's Requests and Dashboard.
// It is built like the customer's BookingCard, only the customer's
// initials are shown instead of the venue photo.
class RequestCard extends StatelessWidget {
  final String initials; // 'AR'
  final String customerName;
  final String details; // 'Sat 19 Dec 2026 · Walima · 300 guests'
  final String status;
  final String infoText;
  final String buttonText;
  final bool isButtonFilled;
  final VoidCallback onPressed;

  const RequestCard({
    super.key,
    required this.initials,
    required this.customerName,
    required this.details,
    required this.status,
    required this.infoText,
    required this.buttonText,
    required this.isButtonFilled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          // ── Top: initials, customer name, status chip, details ──
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: colors.photoMarigold,
                child: Text(
                  initials,
                  style: AppTextStyles.titleSmall(color: colors.photoMarigoldInk),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            customerName,
                            style: AppTextStyles.titleLarge(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusChip(status: status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details,
                      style: AppTextStyles.bodySmall(color: colors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: colors.border, height: 1),
          const SizedBox(height: 12),

          // ── Bottom: info text and the action button ──
          Row(
            children: [
              Expanded(
                child: Text(
                  infoText,
                  style: AppTextStyles.bodySmall(color: colors.textSecondary),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isButtonFilled ? colors.primary : colors.bgSurface,
                    foregroundColor:
                        isButtonFilled ? colors.textOnPrimary : colors.primaryInk,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color:
                            isButtonFilled ? colors.primary : colors.primaryBorder,
                      ),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: AppTextStyles.titleSmall(
                      color:
                          isButtonFilled ? colors.textOnPrimary : colors.primaryInk,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
