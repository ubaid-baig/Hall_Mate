import 'package:get/get.dart';

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
  List<Map<String, dynamic>> conversations = [
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
  ];
}
