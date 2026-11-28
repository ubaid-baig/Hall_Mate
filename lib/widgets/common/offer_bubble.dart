import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

// One offer card in the bargaining list.
// Used on the customer's Booking detail and on the manager's Request detail.
class OfferBubble extends StatelessWidget {
  final String sender; // 'You' or the other side's name
  final bool isMine; // true = green card on the right
  final String price; // 'Rs 2,80,000'
  final String note; // '7% below the listed rent · Tue 26 Nov, 11:02 am'
  final String? tag; // 'Latest', 'Countered' or 'Accepted'

  const OfferBubble({
    super.key,
    required this.sender,
    required this.isMine,
    required this.price,
    required this.note,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Colours for the green card (mine) and the white card (theirs)
    final Color bgColor = isMine ? colors.primary : colors.bgSurface;
    final Color borderColor = isMine ? colors.primary : colors.border;
    final Color senderColor =
        isMine ? colors.textOnPrimaryMute : colors.textSecondary;
    final Color priceColor = isMine ? colors.textOnPrimary : colors.textPrimary;
    final Color smallColor = isMine ? colors.textOnPrimaryMute : colors.textMuted;

    // The pill: a see-through white on the green card, orange on the white card
    final Color pillBg =
        isMine ? colors.textOnPrimary.withValues(alpha: 0.18) : colors.accent;
    final Color pillText = isMine ? colors.textOnPrimary : colors.textOnAccent;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  sender,
                  style: AppTextStyles.labelSmall(color: senderColor),
                ),
              ),
              if (tag != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: pillBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag!,
                    style: AppTextStyles.labelTiny(color: pillText),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(price, style: AppTextStyles.priceLarge(color: priceColor)),
          const SizedBox(height: 4),
          Text(note, style: AppTextStyles.caption(color: smallColor)),
        ],
      ),
    );
  }
}
