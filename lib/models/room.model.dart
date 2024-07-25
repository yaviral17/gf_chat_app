import 'package:gf_chat_app/models/message.model.dart';
import 'package:hive/hive.dart';

part 'room.model.g.dart';

@HiveType(typeId: 0)
class Room {
  @HiveField(0)
  String roomId;
  @HiveField(1)
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
