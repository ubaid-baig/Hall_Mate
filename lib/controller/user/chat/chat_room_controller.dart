import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Chat room screen.
  //
  // When you connect the API:
  //  - GET /conversations/{id}/messages  (oldest first)
  //  - Sending a message is POST /conversations/{id}/messages
  //  - 'isMine' true  = sent by the person using the app (green, right)
  //    'isMine' false = sent by the other person (white, left)
  //  - Later: new messages must appear by themselves, so 'messages' will
  //    become an RxList and the list on the screen will sit inside an Obx.
  // ══════════════════════════════════════════════════════════

  // ── Top bar ──
  // API: the other person (a venue manager or the Hall Mate support)
  String initials = 'SB';
  String name = 'Shaan Banquet Hall';
  String statusLine = 'Imran · online';
  bool isOnline = true; // API: green dot when the person is online

  // ── Booking strip (under the top bar) ──
  // API: the booking this chat is about. Support chats have no booking,
  // so hide the strip then.
  String bookingText = 'HM-1042 · Sat 19 Dec · Dinner';
  String bookingStatus = 'Negotiating';

  // ── Messages ──
  // Text message:  isMine, text, time
  // Image message: isMine, imageLabel, photo ('photo' is DUMMY ONLY, a colour)
  String dateSeparator = 'Today'; // API: group the messages by day
  // .obs because Obx shows the list (a sent message is added to it).
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[
    {
      'isMine': false,
      'text': 'Assalam-o-Alaikum Ali! Thanks for your request for 19 December.',
      'time': '10:02 am',
    },
    {
      'isMine': true,
      'text': 'Walaikum Assalam. Can the stage be white and gold?',
      'time': '10:05 am',
    },
    {
      'isMine': false,
      'text': "Sure, a white & gold stage is possible. Here's one we set up last week.",
      'time': '10:12 am',
    },
    {
      'isMine': false,
      'imageLabel': 'Stage décor',
      'photo': 'marigold',
    },
    {
      'isMine': true,
      'text': 'Looks great. Please send 2–3 more options.',
      'time': '10:15 am · Seen',
    },
  ].obs;

  // The text the user types at the bottom.
  TextEditingController messageController = TextEditingController();

  // Called by the send button (and the keyboard's send key).
  // Later (API): POST /conversations/{id}/messages first.
  void sendMessage() {
    final String text = messageController.text.trim();
    if (text.isEmpty) {
      return; // nothing typed, nothing to send
    }
    messages.add({
      'isMine': true,
      'text': text,
      'time': timeNow(),
    });
    messageController.clear();
  }

  // The time now as "4:05 pm"
  // (padLeft(2, '0') turns 5 into "05")
  String timeNow() {
    final DateTime now = DateTime.now();
    int hour = now.hour % 12;
    if (hour == 0) {
      hour = 12;
    }
    final String minute = now.minute.toString().padLeft(2, '0');
    final String amPm = now.hour < 12 ? 'am' : 'pm';
    return '$hour:$minute $amPm';
  }
}
