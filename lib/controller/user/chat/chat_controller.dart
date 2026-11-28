import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/chat_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/user/chat/chat_room_screen.dart';

// The customer's chat list. The manager sees the same chats
// in her own Chat tab (from the venue's side).
class ChatController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  // ── Search ──
  RxString searchText = ''.obs;

  void updateSearch(String text) {
    searchText.value = text;
  }

  // The chats whose venue name contains the typed text
  List<ChatModel> filteredConversations() {
    final String typed = searchText.value.trim().toLowerCase();
    List<ChatModel> result = [];
    for (var chat in data.chatsOfCustomer(auth.userName())) {
      if (typed.isEmpty || chat.venueName.toLowerCase().contains(typed)) {
        result.add(chat);
      }
    }
    return result;
  }

  // "4:32 pm" or "26 Nov"
  String timeText(ChatModel chat) {
    final DateTime? last = chat.lastTime();
    if (last == null) {
      return '';
    }
    return AppFormat.shortTime(last);
  }

  // A chat is tapped: its unread number goes to 0, then the chat room opens
  void openChat(ChatModel chat) {
    data.markChatRead(chat, false);
    Get.to(() => ChatRoomScreen(chatId: chat.id));
  }
}
