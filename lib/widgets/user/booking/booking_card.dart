import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/model/venue_model.dart';
import 'package:hall_mate/widgets/common/media_box.dart';
import 'package:hall_mate/widgets/common/status_chip.dart';

// One booking in "My bookings". The controller decides every text
// and what the button opens.
class BookingCard extends StatelessWidget {
  final String venueName;
  final String details;
  final String status;
  final String infoText;
  final String buttonText;
  final bool isButtonFilled;
  final MediaModel photo; // the venue's cover
  final VoidCallback onPressed;

  const BookingCard({
    super.key,
    required this.venueName,
    required this.details,
    required this.status,
    required this.infoText,
    required this.buttonText,
    required this.isButtonFilled,
    required this.photo,
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
          // ── Top: photo, venue name, status chip, details ──
          Row(
            children: [
              MediaBox(
                media: photo,
                width: 52,
                height: 52,
                showLabel: false,
                borderRadius: BorderRadius.circular(14),
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
                            venueName,
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
