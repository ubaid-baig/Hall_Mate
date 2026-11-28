import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/user/chat/chat_controller.dart';
import 'package:hall_mate/model/chat_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/widgets/common/conversation_tile.dart';

// Chat tab (customer): one row for every venue the customer talks to.
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
            // ── Title ──
            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.05,
                top: sh * 0.02,
              ),
              child: Text('Messages', style: AppTextStyles.h1()),
            ),
            SizedBox(height: sh * 0.018),

            // ── Search field ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: TextField(
                // Every letter typed filters the list straight away
                onChanged: (text) {
                  controller.updateSearch(text);
                },
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

            // ── Conversations ──
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
                    // Obx: the list changes while you type, and when a
                    // new message arrives
                    child: Obx(() {
                      final List<ChatModel> chats =
                          controller.filteredConversations();

                      if (chats.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No conversations found',
                            style: AppTextStyles.bodyMedium(
                              color: colors.textMuted,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: chats.map((chat) {
                          return ConversationTile(
                            initials: AppFormat.initials(chat.venueName),
                            name: chat.venueName,
                            message: chat.lastText(),
                            time: controller.timeText(chat),
                            unreadCount: chat.unreadForCustomer,
                            avatarStyle: chat.venuePhoto,
                            showDivider: chat != chats.last,
                            onTap: () {
                              controller.openChat(chat);
                            },
                          );
                        }).toList(),
                      );
                    }),
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
