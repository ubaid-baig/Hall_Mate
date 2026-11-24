import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/user/chat/chat_controller.dart';
import 'package:hall_mate/widgets/user/chat/conversation_tile.dart';

// This is the "Messages" (Chat list) tab.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final ChatController controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: colors.bgScreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title and "new message" button ──
            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.05,
                top: sh * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Messages', style: AppTextStyles.h1()),
                  GestureDetector(
                    // Later: start a new conversation
                    onTap: () {},
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.bgSurface,
                        border: Border.all(color: colors.border),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 22,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.018),

            // ── Search field ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: TextField(
                textInputAction: TextInputAction.search,
                style: AppTextStyles.bodyLarge(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.bgSurface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 22,
                    color: colors.textMuted,
                  ),
                  hintText: 'Search conversations',
                  hintStyle: AppTextStyles.bodyLarge(color: colors.textMuted),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.primaryBorder),
                  ),
                ),
              ),
            ),
            SizedBox(height: sh * 0.018),

            // ── Conversations (one card, this part scrolls up and down) ──
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: sw * 0.05,
                    right: sw * 0.05,
                    bottom: sh * 0.02,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.bgSurface,
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      // API: one row for every conversation in the list
                      children: controller.conversations.map((chat) {
                        return ConversationTile(
                          initials: chat['initials'],
                          name: chat['name'],
                          message: chat['message'],
                          time: chat['time'],
                          unreadCount: chat['unreadCount'],
                          avatarStyle: chat['avatar'],
                          // no line under the last row
                          showDivider: chat != controller.conversations.last,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
