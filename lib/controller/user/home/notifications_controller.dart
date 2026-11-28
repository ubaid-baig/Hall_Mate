import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/booking_model.dart';
import 'package:hall_mate/model/chat_model.dart';
import 'package:hall_mate/model/notification_model.dart';
import 'package:hall_mate/view/user/booking/booking_detail_screen.dart';
import 'package:hall_mate/view/user/booking/write_review_screen.dart';
import 'package:hall_mate/view/user/chat/chat_room_screen.dart';

// The customer's notifications. They are made by the shared data
// controller whenever the manager does something (counter, accept ...).
class NotificationsController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  List<NotificationModel> myNotifications() {
    return data.notificationsFor(false, auth.userName());
  }

  // Only the notifications of one group: 'TODAY', 'YESTERDAY' or 'EARLIER'
  List<NotificationModel> group(String name) {
    List<NotificationModel> result = [];
    for (var item in myNotifications()) {
      if (item.group == name) {
        result.add(item);
      }
    }
    return result;
  }

  // "2 unread"
  String unreadText() {
    final int count = data.unreadCount(false, auth.userName());
    if (count == 0) {
      return 'All caught up';
    }
    return '$count unread';
  }

  void markAllRead() {
    data.markAllRead(false, auth.userName());
  }

  // A notification is tapped: it becomes read, and its screen opens.
  void openNotification(NotificationModel item) {
    data.markRead(item);

    if (item.chatId != null) {
      final ChatModel chat = data.chatById(item.chatId!);
      data.markChatRead(chat, false);
      Get.to(() => ChatRoomScreen(chatId: chat.id));
    } else if (item.bookingId != null) {
      final BookingModel booking = data.bookingById(item.bookingId!);
      if (booking.status == 'Completed' && !booking.isReviewed) {
        Get.to(() => WriteReviewScreen(bookingId: booking.id));
      } else {
        Get.to(() => BookingDetailScreen(bookingId: booking.id));
      }
    }
  }
}
