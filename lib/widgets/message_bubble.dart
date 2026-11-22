import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/widgets/photo_placeholder.dart';

/// One message in the Chat room.
///  - isMine true:  green bubble on the right
///  - isMine false: white bubble on the left
/// If imageLabel is given, it shows a picture message instead of text.
///
/// API: every value comes from one message in the messages list.
class MessageBubble extends StatelessWidget {
  final bool isMine; // API: true if the logged-in user sent it
  final String? text; // API: the message text (null for a picture)
  final String time; // API: for example '10:02 am'
  final String? imageLabel; // API: the picture's title (null for a text message)
  final String photoStyle; // DUMMY ONLY: placeholder colour

  const MessageBubble({
    super.key,
    required this.isMine,
    required this.time,
    this.text,
    this.imageLabel,
    this.photoStyle = 'emerald',
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);

    // What goes inside: a picture or a text bubble
    Widget content;
    if (imageLabel != null) {
      content = PhotoPlaceholder(
        photoStyle: photoStyle,
        width: sw * 0.48,
        height: 138,
        iconSize: 28,
        showLabel: true,
        label: imageLabel!,
        borderRadius: BorderRadius.circular(18),
      );
    } else {
      content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? colors.primary : colors.bgSurface,
          border: Border.all(color: isMine ? colors.primary : colors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text ?? '',
              style: AppTextStyles.bodyLarge(
                color: isMine ? colors.textOnPrimary : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: AppTextStyles.labelTiny(
                color: isMine ? colors.textOnPrimaryMute : colors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    // The empty SizedBox on one side keeps the bubble from getting too wide.
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (isMine) SizedBox(width: sw * 0.3),
          Expanded(
            child: Align(
              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
              child: content,
            ),
          ),
          if (!isMine) SizedBox(width: sw * 0.3),
        ],
      ),
    );
  }
}
