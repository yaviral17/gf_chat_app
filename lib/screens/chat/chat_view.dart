import 'dart:convert';

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
                    id: const Uuid().v4(),
                    message: messageData['message']!,
                    sender: messageData['username']!,
                    receiver: '-',
                    timestamp: DateTime.now().toIso8601String(),
                    roomId: room.roomId,
                  ),
                );
                controller.persistRooms();
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
      controller.persistRooms();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text('Room Id ${room.roomId}'),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: room.messages.length,
                itemBuilder: (context, index) {
                  // return ListTile(
                  //   title: Text(room.messages[index].sender),
                  //   subtitle: Text(room.messages[index].message),
                  // );
                  bool isMe =
                      room.messages[index].sender == controller.username;
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        // height: 54,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        padding: const EdgeInsets.all(8.0),

                        decoration: BoxDecoration(
                          color: isMe
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer
                                  .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          room.messages[index].message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
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
                          id: const Uuid().v4(),
                          message: smsController.text,
                          sender: controller.username,
                          receiver: '-',
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
