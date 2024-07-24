import 'package:get_storage/get_storage.dart';

class Message {
  String id;
  String message;
  String sender;
  String receiver;
  String timestamp;
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
