import 'package:flutter/material.dart';
import 'package:gf_chat_app/screens/chat/chat_view.dart';
import 'package:gf_chat_app/screens/home/home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GF Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/chat': (context) => const ChatPage(),
      },
      initialRoute: '/',
    );
  }
}
