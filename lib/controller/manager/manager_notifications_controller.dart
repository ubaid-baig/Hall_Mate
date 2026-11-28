import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/model/chat_model.dart';
import 'package:hall_mate/model/notification_model.dart';
import 'package:hall_mate/view/manager/chat/manager_chat_room_screen.dart';
import 'package:hall_mate/view/manager/requests/request_detail_screen.dart';

// The manager's notifications. They are made by the shared data
// controller whenever a customer does something (request, counter, pay ...).
class ManagerNotificationsController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();
  final AuthController auth = Get.find<AuthController>();

  List<NotificationModel> myNotifications() {
    return data.notificationsFor(true, auth.venueId());
  }

  List<NotificationModel> group(String name) {
    List<NotificationModel> result = [];
    for (var item in myNotifications()) {
      if (item.group == name) {
        result.add(item);
      }
    }
    return result;
  }

  String unreadText() {
    final int count = data.unreadCount(true, auth.venueId());
    if (count == 0) {
      return 'All caught up';
    }
    return '$count unread';
  }

  void markAllRead() {
    data.markAllRead(true, auth.venueId());
  }

  void openNotification(NotificationModel item) {
    data.markRead(item);

    if (item.chatId != null) {
      final ChatModel chat = data.chatById(item.chatId!);
      data.markChatRead(chat, true);
      Get.to(() => ManagerChatRoomScreen(chatId: chat.id));
    } else if (item.bookingId != null) {
      Get.to(() => RequestDetailScreen(bookingId: item.bookingId!));
    }
  }
}
