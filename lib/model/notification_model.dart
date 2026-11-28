class NotificationModel {
  bool forManager; // true = for a venue manager, false = for a customer
  String? venueId; // manager notifications: which venue's manager sees it
  String? customerName; // customer notifications: which customer sees it
  // Decides the icon: request, counter, accepted, declined, payment,
  // review or message
  String iconType;
  String title;
  String message;
  String group; // 'TODAY', 'YESTERDAY' or 'EARLIER'
  String time; // for example 'Just now', '11:02 am', '23 Nov'
  bool isUnread;
  String? bookingId; // opens this booking when tapped
  String? chatId; // opens this chat when tapped

  NotificationModel({
    required this.forManager,
    required this.iconType,
    required this.title,
    required this.message,
    required this.group,
    required this.time,
    this.venueId,
    this.customerName,
    this.isUnread = true,
    this.bookingId,
    this.chatId,
  });
}
