import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/model/chat_model.dart';

class ManagerChatRoomController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  TextEditingController messageController = TextEditingController();

  // The message goes into the shared chat (byManager = true),
  // so the customer sees it and gets a notification.
  void sendMessage(ChatModel chat) {
    final String text = messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    data.sendMessage(chat, text, true);
    messageController.clear();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
