import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One offer in the negotiation list.
///  - isMine true:  green card (sent by the person using the app)
///  - isMine false: white card (sent by the other side)
///
/// API: every value comes from one offer in the offers list.
class OfferBubble extends StatelessWidget {
  final String sender; // API: 'You' or the venue / customer name
  final bool isMine; // API: true if the logged-in user sent this offer
  final String price; // API: price per head, e.g. 'Rs 2,400'
  final String total; // API: price x guests, e.g. 'Rs 7,20,000'
  final String time; // API: when the offer was sent
  final String? tag; // small pill: 'Countered' or 'Latest'

  const OfferBubble({
    super.key,
    required this.sender,
    required this.isMine,
    required this.price,
    required this.total,
    required this.time,
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
          RichText(
            text: TextSpan(
              style: AppTextStyles.priceLarge(color: priceColor),
              children: [
                TextSpan(text: price),
                TextSpan(
                  text: ' / head',
                  style: AppTextStyles.bodySmall(color: smallColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$total total · $time',
            style: AppTextStyles.caption(color: smallColor),
          ),
        ],
      ),
    );
  }
}
