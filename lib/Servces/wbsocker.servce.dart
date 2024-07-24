import 'dart:convert';

import 'package:gf_chat_app/models/message.model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String roomId;
  late WebSocketChannel channel;

  WebSocketService(this.roomId) {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.31.102:8000/api/chat/$roomId'),
    );
  }

  Stream get stream => channel.stream;

  void sendMessage(Message message) {
    final msg = {
      'username': message.sender,
      'message': message.message,
      'roomId': message.roomId,
    };
    channel.sink.add(jsonEncode(msg));
  }

  void dispose() {
    channel.sink.close();
  }
}
