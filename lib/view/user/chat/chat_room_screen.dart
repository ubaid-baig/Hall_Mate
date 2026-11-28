import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/model/chat_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/booking/booking_detail_screen.dart';
import 'package:hall_mate/widgets/common/message_bubble.dart';
import 'package:hall_mate/widgets/common/status_chip.dart';
import '../../../controller/user/chat/chat_room_controller.dart';

// Chat room (customer side): the customer and one venue.
class ChatRoomScreen extends StatelessWidget {
  final String chatId;

  const ChatRoomScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final ChatRoomController controller = Get.put(ChatRoomController());
    final AppDataController data = Get.find<AppDataController>();
    final ChatModel chat = data.chatById(chatId);

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: back, venue, manager name ──
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
                      AppFormat.initials(chat.venueName),
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
                        Text(chat.venueName, style: AppTextStyles.titleMedium()),
                        const SizedBox(height: 2),
                        Text(
                          '${chat.managerName} · Venue manager',
                          style: AppTextStyles.caption(color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

            // ── Booking strip: which booking this chat is about ──
            if (chat.bookingId != null) ...[
              Padding(
                padding: EdgeInsets.only(
                  left: sw * 0.05,
                  right: sw * 0.02,
                  top: 6,
                  bottom: 6,
                ),
                // Obx: the status chip follows the booking
                child: Obx(() {
                  final BookingModel booking = data.bookingById(chat.bookingId!);
                  return Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: colors.primaryInk,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${booking.id} · ${AppFormat.shortDate(booking.eventDate)}',
                          style: AppTextStyles.titleSmall(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusChip(status: booking.status),
                      TextButton(
                        onPressed: () {
                          Get.to(() => BookingDetailScreen(bookingId: booking.id));
                        },
                        child: Text(
                          'View',
                          style: AppTextStyles.titleSmall(color: colors.primaryInk),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Divider(color: colors.border, height: 1),
            ],

            // ── Messages ──
            Expanded(
              child: Container(
                width: double.infinity,
                color: colors.bgScreen,
                // reverse: true starts at the bottom, where the newest message is
                child: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: sh * 0.018,
                    ),
                    // Obx: a sent message appears straight away
                    child: Obx(() {
                      final List<MessageModel> messages =
                          data.chatById(chatId).messages;
                      if (messages.isEmpty) {
                        return Text(
                          'Say hello to ${chat.venueName}',
                          style: AppTextStyles.bodyMedium(color: colors.textMuted),
                        );
                      }
                      return Column(
                        children: messages.map((message) {
                          return MessageBubble(
                            isMine: !message.byManager,
                            text: message.text,
                            time: AppFormat.messageTime(message.sentAt),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                ),
              ),
            ),

            // ── Type and send ──
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
                        Expanded(
                          child: TextField(
                            controller: controller.messageController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (text) {
                              controller.sendMessage(chat);
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
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
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
                          onTap: () {
                            controller.sendMessage(chat);
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
