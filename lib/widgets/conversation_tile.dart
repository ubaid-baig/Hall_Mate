import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/view/chat_room_screen.dart';

/// One row in the Chat list.
///
/// API: every value comes from one conversation in your API list.
/// If unreadCount is more than 0, the time turns green and a number badge shows.
class ConversationTile extends StatelessWidget {
  final String initials; // API: take the first letters of the name
  final String name; // API: the other person / venue name
  final String message; // API: last message
  final String time; // API: time of the last message
  final int unreadCount; // API: number of unread messages
  final String avatarStyle; // DUMMY ONLY: emerald, marigold, slate or primary
  final bool showDivider; // false for the last row

  const ConversationTile({
    super.key,
    required this.initials,
    required this.name,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.avatarStyle,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bool hasUnread = unreadCount > 0;

    // Pick the circle colour from the dummy style name.
    Color avatarBg = colors.photoEmerald;
    Color avatarInk = colors.photoEmeraldInk;
    if (avatarStyle == 'marigold') {
      avatarBg = colors.photoMarigold;
      avatarInk = colors.photoMarigoldInk;
    } else if (avatarStyle == 'slate') {
      avatarBg = colors.photoSlate;
      avatarInk = colors.photoSlateInk;
    } else if (avatarStyle == 'primary') {
      avatarBg = colors.primary;
      avatarInk = colors.textOnPrimary;
    }

    return GestureDetector(
      // Opens the Chat room.
      // API: send this conversation's id along, for example
      // Get.to(() => ChatRoomScreen(), arguments: conversationId)
      onTap: () {
        Get.to(() => const ChatRoomScreen());
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: avatarBg,
                  child: Text(
                    initials,
                    style: AppTextStyles.labelSmall(color: avatarInk),
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
                            child: Text(name, style: AppTextStyles.titleMedium()),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            time,
                            style: hasUnread
                                ? AppTextStyles.labelSmall(color: colors.primaryInk)
                                : AppTextStyles.caption(color: colors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message,
                              style: AppTextStyles.bodySmall(
                                color: hasUnread
                                    ? colors.textPrimary
                                    : colors.textMuted,
                              ),
                            ),
                          ),
                          if (hasUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$unreadCount',
                                  style: AppTextStyles.labelTiny(
                                    color: colors.textOnPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showDivider) Divider(color: colors.border, height: 1),
        ],
      ),
    );
  }
}
