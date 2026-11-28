import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

/// One notification row. The icon and its colour follow the type.
/// A green dot on the right means the notification is not read yet.
///
/// API: every value comes from one notification in the list.
class NotificationTile extends StatelessWidget {
  final String iconType; // request, counter, accepted, declined, payment, review, message
  final String title; // API: the headline
  final String message; // API: the details
  final String time; // API: '2h', 'Mon', '8 Nov' ...
  final bool isUnread; // API: true if not read yet
  final bool showDivider; // false for the last row of a card

  const NotificationTile({
    super.key,
    required this.iconType,
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Icon and colours for each type
    IconData icon = Icons.notifications_none_rounded;
    Color boxColor = colors.bgNeutral;
    Color iconColor = colors.textSecondary;
    if (iconType == 'counter') {
      icon = Icons.swap_horiz;
      boxColor = colors.accentSoft;
      iconColor = colors.accentInk;
    } else if (iconType == 'message') {
      icon = Icons.chat_bubble_outline;
      boxColor = colors.primarySoft;
      iconColor = colors.primaryInk;
    } else if (iconType == 'request') {
      icon = Icons.send_outlined;
      boxColor = colors.infoSoft;
      iconColor = colors.infoInk;
    } else if (iconType == 'payment') {
      icon = Icons.account_balance_wallet_outlined;
      boxColor = colors.successSoft;
      iconColor = colors.successInk;
    } else if (iconType == 'review') {
      icon = Icons.star_rounded;
      boxColor = colors.accentSoft;
      iconColor = colors.accentStrongInk;
    } else if (iconType == 'accepted') {
      icon = Icons.check_circle_outline;
      boxColor = colors.successSoft;
      iconColor = colors.successInk;
    } else if (iconType == 'declined') {
      icon = Icons.close;
      boxColor = colors.dangerSoft;
      iconColor = colors.danger;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title, style: AppTextStyles.titleMedium()),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: AppTextStyles.caption(color: colors.textMuted),
                        ),
                        // The green "unread" dot
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: AppTextStyles.bodySmall(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: colors.border, height: 1),
      ],
    );
  }
}
