import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_chat_app/Servces/wbsocker.servce.dart';
import 'package:gf_chat_app/controller/home.controller.dart';
import 'package:gf_chat_app/models/message.model.dart';
import 'package:gf_chat_app/models/room.model.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.roomId,
  });
  final String roomId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketService _webSocketService;
  final TextEditingController smsController = TextEditingController();
  final controller = Get.put(HomeController());
  late Room room;

  @override
  void initState() {
    super.initState();
    room = controller.rooms.firstWhere(
      (element) => element.roomId == widget.roomId,
      orElse: () => Room(roomId: widget.roomId, messages: []),
    );

    _webSocketService = WebSocketService(room.roomId);
    _webSocketService.stream.listen((message) {
      try {
        final decodedMessage = jsonDecode(message);
        if (decodedMessage is Map<String, dynamic> &&
            decodedMessage.values.every((value) => value is String)) {
          final messageData = decodedMessage.cast<String, String>();
          if (messageData.containsKey('message') &&
              messageData.containsKey('username')) {
            for (int i = 0; i < controller.rooms.length; i++) {
              if (controller.rooms[i].roomId == room.roomId) {
                controller.rooms[i].messages.add(
                  Message(
                    id: Uuid().v4(),
                    message: messageData['message']!,
                    sender: messageData['username']!,
                    receiver: 'username',
                    timestamp: DateTime.now().toIso8601String(),
                    roomId: room.roomId,
                  ),
                );
                setState(() {});
              }
            }
          } else {
            print('Received message is missing required fields');
          }
        } else {
          print('Received message is not a Map<String, String>');
        }
      } catch (e) {
        print('Error decoding message: $e');
      }
    });
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  void _sendMessage(Message message) {
    if (smsController.text.isNotEmpty) {
      _webSocketService.sendMessage(message);
      smsController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Id ${room.roomId}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: room.messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(room.messages[index].sender),
                    subtitle: Text(room.messages[index].message),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: smsController,
                      decoration:
                          const InputDecoration(hintText: 'Enter message'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (smsController.text.isNotEmpty) {
                        final message = Message(
                          id: Uuid().v4(),
                          message: smsController.text,
                          sender: 'Me',
                          receiver: 'username',
                          timestamp: DateTime.now().toIso8601String(),
                          roomId: room.roomId,
                        );
                        room.messages.add(message);
                        _sendMessage(message);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
