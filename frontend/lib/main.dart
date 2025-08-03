import 'package:flutter/material.dart';
import 'package:frontend/Screens/voice_to_text_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Flutter Generator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VoiceToTextScreen(),
    );
  }
}
