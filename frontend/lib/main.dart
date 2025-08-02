import 'package:flutter/material.dart';
import 'package:frontend/Screens/test_gemini_ui_generation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Flutter Generator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TestGeminiUIGeneration(),
    );
  }
}
