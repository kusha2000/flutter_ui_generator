import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Flutter Generator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Text("AI Flutter Generator"),
      ),
    );
  }
}
