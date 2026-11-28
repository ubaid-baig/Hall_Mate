import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/chat_model.dart';

class ChatRoomController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  // The text the customer types at the bottom
  TextEditingController messageController = TextEditingController();

  // Called by the send button (and the keyboard's send key).
  // The message goes into the shared chat, so the manager sees it,
  // and she gets a "New message" notification.
  // Later (API): POST /conversations/{id}/messages first.
  void sendMessage(ChatModel chat) {
    final String text = messageController.text.trim();
    if (text.isEmpty) {
      return; // nothing typed, nothing to send
    }
    data.sendMessage(chat, text, false);
    messageController.clear();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
