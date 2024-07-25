import 'package:hive/hive.dart';

part 'message.model.g.dart';

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  String id;
  @HiveField(1)
  String message;
  @HiveField(2)
  String sender;
  @HiveField(3)
  String receiver;
  @HiveField(4)
  String timestamp;
  @HiveField(5)
  String roomId;

  Message({
    required this.id,
    required this.message,
    required this.sender,
    required this.receiver,
    required this.timestamp,
    required this.roomId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      message: json['message'],
      sender: json['sender'],
      receiver: json['receiver'],
      timestamp: json['timestamp'],
      roomId: json['roomId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['timestamp'] = timestamp;
    data['roomId'] = roomId;
    return data;
  }
}
