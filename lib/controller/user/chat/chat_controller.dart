import 'package:get/get.dart';
import 'package:hall_mate/view/user/chat/chat_room_screen.dart';

class ChatController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Chat list screen.
  //
  // When you connect the API:
  //  - GET /conversations
  //  - 'unreadCount' > 0 makes the time green and shows the badge.
  //  - 'avatar' is DUMMY ONLY (a colour for the circle):
  //    emerald, marigold, slate or primary.
  //    With the API, take the initials from the name.
  // ══════════════════════════════════════════════════════════
  // .obs because Obx shows the list (the unread badge goes away on open).
  RxList<Map<String, dynamic>> conversations = <Map<String, dynamic>>[
    {
      'initials': 'SB',
      'name': 'Shaan Banquet Hall',
      'message': 'Sure, a white & gold stage is possible.',
      'time': '4:32 pm',
      'unreadCount': 2,
      'avatar': 'emerald',
    },
    {
      'initials': 'RP',
      'name': 'Royal Palm Banquet',
      'message': 'We can hold the date until tomorrow.',
      'time': '1:10 pm',
      'unreadCount': 0,
      'avatar': 'marigold',
    },
    {
      'initials': 'GG',
      'name': 'Gulshan Garden Lawn',
      'message': 'The rain backup marquee is included.',
      'time': 'Yesterday',
      'unreadCount': 0,
      'avatar': 'slate',
    },
    {
      'initials': 'NB',
      'name': 'Noor Ballroom',
      'message': 'Thank you for celebrating with us!',
      'time': '8 Nov',
      'unreadCount': 0,
      'avatar': 'marigold',
    },
    {
      'initials': 'HM',
      'name': 'Hall Mate Support',
      'message': 'Your refund has been processed.',
      'time': '2 Nov',
      'unreadCount': 0,
      'avatar': 'primary',
    },
  ].obs;

  // ── Search ──
  RxString searchText = ''.obs;

  void updateSearch(String text) {
    searchText.value = text;
  }

  // The conversations whose name contains the typed text
  List<Map<String, dynamic>> filteredConversations() {
    final String typed = searchText.value.trim().toLowerCase();
    if (typed.isEmpty) {
      return conversations;
    }
    List<Map<String, dynamic>> result = [];
    for (var chat in conversations) {
      final String name = chat['name'].toLowerCase();
      if (name.contains(typed)) {
        result.add(chat);
      }
    }
    return result;
  }

  // Called when a conversation is tapped:
  // its unread number goes to 0, then the Chat room opens.
  // Later (API): send this conversation's id to the Chat room.
  void openChat(Map<String, dynamic> chat) {
    chat['unreadCount'] = 0;
    conversations.refresh(); // tells Obx that something inside changed
    Get.to(() => const ChatRoomScreen());
  }
}
