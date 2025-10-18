import 'package:flutter/material.dart';

class HuggingFaceGeneratedWidget extends StatelessWidget {
  const HuggingFaceGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
    body: Center(
    child: Container(
    width: size.width * 0.8,
    height: size.height * 0.6,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16.0),
    gradient: LinearGradient(
    colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    boxShadow: [
    BoxShadow(
    color: colorScheme.onSurface.withOpacity(0.25),
    blurRadius: 8.0,
    offset: Offset.zero,
    ),
    ],
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Image.asset(
    'assets/logo.png',
    width: 100.0,
    height: 100.0,
    ),
    SizedBox(height: 16.0),
    const Text(
    'Welcome to Our App',
    style: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    SizedBox(height: 8.0),
    const Text(
    'Loading...',
    style: TextStyle(
    fontSize: 16.0,
    color: Colors.white,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}