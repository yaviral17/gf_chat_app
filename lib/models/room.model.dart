import 'package:get_storage/get_storage.dart';
import 'package:gf_chat_app/models/message.model.dart';

class Room {
  String roomId;
  List<Message> messages;

  Room({
    required this.roomId,
    required this.messages,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      messages: List<Message>.from(
        json['messages'].map(
          (x) => Message.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomId'] = roomId;
    data['messages'] = messages.map((x) => x.toJson()).toList();
    return data;
  }

  void addMessage(Message message) {
    messages.add(message);
  }

  void removeMessage(Message message) {
    messages.remove(message);
  }
}
