import 'package:get/get.dart';

class NotificationsController extends GetxController {
  // ══════════════════════════════════════════════════════════
  // DUMMY DATA for the Notifications screen.
  //
  // When you connect the API:
  //  - GET /notifications. Put each one in the list of its day
  //    (today, yesterday or earlier).
  //  - 'iconType' decides the icon and colour. Use exactly:
  //    counter, message, request, payment, review, expired
  //  - 'isUnread' true shows the green dot.
  //  - The check button at the top = "mark all as read".
  // ══════════════════════════════════════════════════════════

  // API: count of notifications that are not read yet
  String unreadText = '2 unread';

  List<Map<String, dynamic>> today = [
    {
      'iconType': 'counter',
      'title': 'New counter offer',
      'message': 'Shaan Banquet Hall countered at Rs 2,600 / head for Sat 19 Dec.',
      'time': '2h',
      'isUnread': true,
    },
    {
      'iconType': 'message',
      'title': 'New message from Imran',
      'message': '“Sure, a white & gold stage is possible.”',
      'time': '3h',
      'isUnread': true,
    },
  ];

  List<Map<String, dynamic>> yesterday = [
    {
      'iconType': 'request',
      'title': 'Request sent',
      'message': 'Your request to Royal Palm Banquet is waiting for a reply.',
      'time': 'Mon',
      'isUnread': false,
    },
    {
      'iconType': 'payment',
      'title': 'Advance received',
      'message': 'Gulshan Garden Lawn confirmed your booking for Fri 15 Jan.',
      'time': 'Mon',
      'isUnread': false,
    },
  ];

  List<Map<String, dynamic>> earlier = [
    {
      'iconType': 'review',
      'title': 'How was your event?',
      'message': 'Rate Noor Ballroom and help other families choose.',
      'time': '8 Nov',
      'isUnread': false,
    },
    {
      'iconType': 'expired',
      'title': 'Offer expired',
      'message': "Royal Palm Banquet didn't reply within 24 hours.",
      'time': '5 Nov',
      'isUnread': false,
    },
  ];
}
