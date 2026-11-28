// One chat message.
class MessageModel {
  String text;
  bool byManager; // true = the venue sent it, false = the customer sent it
  DateTime sentAt;

  MessageModel({
    required this.text,
    required this.byManager,
    required this.sentAt,
  });
}

// One conversation between a customer and a venue.
// The customer sees it in Chat, the manager sees the same one in her Chat.
class ChatModel {
  String id; // for example 'c1'
  String venueId;
  String venueName;
  String venuePhoto; // DUMMY ONLY: colour of the circle
  String managerName;
  String customerName;
  String? bookingId; // the booking this chat is about (can be null)
  List<MessageModel> messages;
  int unreadForCustomer;
  int unreadForManager;

  ChatModel({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.venuePhoto,
    required this.managerName,
    required this.customerName,
    required this.messages,
    this.bookingId,
    this.unreadForCustomer = 0,
    this.unreadForManager = 0,
  });

  // The last message text, shown in the chat list
  String lastText() {
    if (messages.isEmpty) {
      return 'No messages yet';
    }
    return messages.last.text;
  }

  // The time of the last message, for example '4:32 pm'
  DateTime? lastTime() {
    if (messages.isEmpty) {
      return null;
    }
    return messages.last.sentAt;
  }
}
