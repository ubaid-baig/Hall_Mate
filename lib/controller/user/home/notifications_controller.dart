import 'package:get/get.dart';
import 'package:hall_mate/view/user/booking/booking_detail_screen.dart';
import 'package:hall_mate/view/user/booking/booking_confirmed_screen.dart';
import 'package:hall_mate/view/user/booking/write_review_screen.dart';
import 'package:hall_mate/view/user/chat/chat_room_screen.dart';

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

  // The three lists are .obs because Obx shows them
  // (the green dot goes away when a notification is read).

  RxList<Map<String, dynamic>> today = <Map<String, dynamic>>[
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
  ].obs;

  RxList<Map<String, dynamic>> yesterday = <Map<String, dynamic>>[
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
  ].obs;

  RxList<Map<String, dynamic>> earlier = <Map<String, dynamic>>[
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
  ].obs;

  // "2 unread" (counted from the three lists)
  String unreadText() {
    int count = 0;
    for (var item in today) {
      if (item['isUnread'] == true) count = count + 1;
    }
    for (var item in yesterday) {
      if (item['isUnread'] == true) count = count + 1;
    }
    for (var item in earlier) {
      if (item['isUnread'] == true) count = count + 1;
    }
    if (count == 0) {
      return 'All caught up';
    }
    return '$count unread';
  }

  // Tells every Obx that something inside the lists changed
  void refreshLists() {
    today.refresh();
    yesterday.refresh();
    earlier.refresh();
  }

  // The check button at the top: every notification becomes read.
  // Later (API): POST /notifications/read-all
  void markAllRead() {
    for (var item in today) {
      item['isUnread'] = false;
    }
    for (var item in yesterday) {
      item['isUnread'] = false;
    }
    for (var item in earlier) {
      item['isUnread'] = false;
    }
    refreshLists();
  }

  // A notification is tapped: it becomes read, and its screen opens.
  void openNotification(Map<String, dynamic> item) {
    item['isUnread'] = false;
    refreshLists();

    if (item['iconType'] == 'counter' || item['iconType'] == 'request') {
      Get.to(() => const BookingDetailScreen());
    } else if (item['iconType'] == 'message') {
      Get.to(() => const ChatRoomScreen());
    } else if (item['iconType'] == 'payment') {
      Get.to(() => const BookingConfirmedScreen());
    } else if (item['iconType'] == 'review') {
      Get.to(() => const WriteReviewScreen());
    }
    // 'expired' opens nothing
  }
}
