import 'dart:developer';

import 'package:get/get.dart';
import 'package:gf_chat_app/Servces/generatenme.service.dart';
import 'package:gf_chat_app/models/message.model.dart';
import 'package:gf_chat_app/models/room.model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxList<Room> rooms = <Room>[
    Room(roomId: "abcd", messages: []),
  ].obs;

  String username = '';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadRooms();
    getUserName().then((value) {
      username = value;
      log('Username: $username');
    });
  }

  Future<String> getUserName() async {
    final pref = await SharedPreferences.getInstance();
    String? usr = pref.getString('username');
    if (usr == null) {
      final response = await getRandomUserData();
      String title = response['results'][0]['name']['title'];
      String first = response['results'][0]['name']['first'];
      String last = response['results'][0]['name']['last'];
      usr = '$title $first $last';
    }
    return usr;
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
    SharedPreferences.getInstance().then((pref) {
      pref.setString('username', username);
    });
  }

  void loadRooms() {
    // load rooms from hive
    final box = Hive.box('rooms');
    if (box.isNotEmpty) {
      rooms = box.values.toList().cast<Room>().obs;
    }
  }
}
