import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_chat_app/models/message.model.dart';
import 'package:gf_chat_app/models/room.model.dart';

class HomeController extends GetxController {
  RxList<Room> rooms = <Room>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadRooms();
  }

  void addRoom(Room room) {
    rooms.add(room);
    persistRooms();
  }

  void removeRoom(Room room) {
    rooms.remove(room);
  }

  void addMessageToRoom(Room room, Message message) {
    final index = rooms.indexOf(room);
    rooms[index].addMessage(message);
  }

  void removeMessageFromRoom(Room room, Message message) {
    final index = rooms.indexOf(room);
    rooms[index].removeMessage(message);
  }

  void persistRooms() {
    Map<String, dynamic> roomsJson = {};
    rooms.forEach((room) {
      roomsJson[room.roomId] = room.toJson();
    });
    GetStorage().write('rooms', roomsJson);
  }

  void loadRooms() {
    final roomsJson = GetStorage().read('rooms');
    if (roomsJson != null) {
      rooms.clear();
      roomsJson.forEach((key, value) {
        rooms.add(Room.fromJson(value));
      });
    }
  }
}
