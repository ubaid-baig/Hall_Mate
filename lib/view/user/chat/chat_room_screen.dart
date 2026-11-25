import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/view/user/booking/booking_detail_screen.dart';
import 'package:hall_mate/widgets/user/chat/message_bubble.dart';
import 'package:hall_mate/widgets/common/status_chip.dart';
import '../../../controller/user/chat/chat_room_controller.dart';

// Chat room: the messages with one person.
// Opens from the Messages list and from the chat button on Booking detail.
class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final ChatRoomController controller = Get.put(ChatRoomController());

    return Scaffold(
      // White, so the status bar area matches the white top bar.
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ════════ TOP BAR ════════
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.05,
                vertical: 10,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: colors.photoEmerald,
                    child: Text(
                      // API: first letters of the name
                      controller.initials,
                      style: AppTextStyles.labelSmall(
                        color: colors.photoEmeraldInk,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.name, style: AppTextStyles.titleMedium()),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            // API: show the green dot only when the person is online
                            if (controller.isOnline) ...[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: colors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              controller.statusLine,
                              style: AppTextStyles.caption(color: colors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // Later: call the venue manager
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
                        Icons.phone_outlined,
                        size: 22,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

            // ════════ BOOKING STRIP ════════
            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.02,
                top: 6,
                bottom: 6,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: colors.primaryInk,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    // API: the booking this chat is about
                    child: Text(
                      controller.bookingText,
                      style: AppTextStyles.titleSmall(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(status: controller.bookingStatus),
                  TextButton(
                    // Opens the booking. (Later: send this booking's id along.)
                    onPressed: () {
                      Get.to(() => const BookingDetailScreen());
                    },
                    child: Text(
                      'View',
                      style: AppTextStyles.titleSmall(color: colors.primaryInk),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

            // ════════ MESSAGES (this part scrolls up and down) ════════
            Expanded(
              child: Container(
                width: double.infinity,
                color: colors.bgScreen,
                child: SingleChildScrollView(
                  // Later: start at the newest message at the bottom.
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: 14,
                    ),
                    child: Column(
                      children: [
                        // The small "Today" label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.bgNeutral,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            controller.dateSeparator,
                            style: AppTextStyles.labelSmall(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        SizedBox(height: sh * 0.018),
                        // Obx: a new bubble appears when you send a message
                        Obx(
                          () => Column(
                            // API: one bubble for every message in the list
                            children: controller.messages.map((message) {
                              return MessageBubble(
                                isMine: message['isMine'],
                                text: message['text'],
                                time: message['time'] ?? '',
                                imageLabel: message['imageLabel'],
                                photoStyle: message['photo'] ?? 'emerald',
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ════════ MESSAGE BAR (stays in place, does not scroll) ════════
            Container(
              color: colors.bgSurface,
              child: Column(
                children: [
                  Divider(color: colors.border, height: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          // Later: attach a photo
                          onTap: () {},
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors.primarySoft,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: colors.primaryInk,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: controller.messageController,
                            textInputAction: TextInputAction.send,
                            // The keyboard's send key also sends
                            onSubmitted: (text) {
                              controller.sendMessage();
                            },
                            style: AppTextStyles.bodyLarge(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: colors.bgSubtle,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              hintText: 'Type a message',
                              hintStyle: AppTextStyles.bodyLarge(
                                color: colors.textMuted,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide(color: colors.primaryBorder),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          // Adds your message and clears the field.
                          // Later (API): POST /conversations/{id}/messages
                          onTap: () {
                            controller.sendMessage();
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.send_outlined,
                              size: 20,
                              color: colors.textOnPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
