
import 'package:get/get.dart';
import 'package:gf_chat_app/models/message.model.dart';
import 'package:gf_chat_app/models/room.model.dart';
import 'package:hive/hive.dart';

class HomeController extends GetxController {
  RxList<Room> rooms = <Room>[
    Room(roomId: "abcd", messages: []),
  ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadRooms();
  }

  void addRoom(Room room) {
    rooms.add(room);
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
    // store in Room list into hive

    Hive.box('rooms').clear();
    Hive.box('rooms').addAll(rooms);
  }

  void loadRooms() {
    // load rooms from hive
    final box = Hive.box('rooms');
    if (box.isNotEmpty) {
      rooms = box.values.toList().cast<Room>().obs;
    }
  }
}
