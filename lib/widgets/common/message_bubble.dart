import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

// One chat message. Mine = green on the right, theirs = white on the left.
class MessageBubble extends StatelessWidget {
  final bool isMine;
  final String text;
  final String time; // for example '10:02 am'

  const MessageBubble({
    super.key,
    required this.isMine,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // An empty space on the other side keeps the bubble narrow
          if (isMine) SizedBox(width: sw * 0.2),
          Expanded(
            child: Align(
              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMine ? colors.primary : colors.bgSurface,
                  border: Border.all(
                    color: isMine ? colors.primary : colors.border,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: AppTextStyles.bodyLarge(
                        color: isMine ? colors.textOnPrimary : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: AppTextStyles.labelTiny(
                        color: isMine
                            ? colors.textOnPrimaryMute
                            : colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isMine) SizedBox(width: sw * 0.2),
        ],
      ),
    );
  }
}
