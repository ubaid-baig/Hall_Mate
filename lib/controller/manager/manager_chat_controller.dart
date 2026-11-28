import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/chat_model.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/manager/chat/manager_chat_room_screen.dart';

// The manager's chat list: one row for every customer who wrote to her venue.
// The same chats show on the customer side (from the customer's side).
class ManagerChatController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  RxString searchText = ''.obs;

  void updateSearch(String text) {
    searchText.value = text;
  }

  // The chats of this venue whose customer name contains the typed text
  List<ChatModel> filteredConversations() {
    final String typed = searchText.value.trim().toLowerCase();
    List<ChatModel> result = [];
    for (var chat in data.chatsOfVenue(auth.venueId())) {
      if (typed.isEmpty || chat.customerName.toLowerCase().contains(typed)) {
        result.add(chat);
      }
    }
    return result;
  }

  String timeText(ChatModel chat) {
    final DateTime? last = chat.lastTime();
    if (last == null) {
      return '';
    }
    return AppFormat.shortTime(last);
  }

  void openChat(ChatModel chat) {
    data.markChatRead(chat, true);
    Get.to(() => ManagerChatRoomScreen(chatId: chat.id));
  }
}
