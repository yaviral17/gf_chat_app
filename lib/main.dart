import 'package:flutter/material.dart';
import 'package:gf_chat_app/app.dart';
import 'package:gf_chat_app/models/message.model.dart';
import 'package:gf_chat_app/models/room.model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RoomAdapter());
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox('rooms'); // Open the Hive box

  runApp(const MyApp());
}
