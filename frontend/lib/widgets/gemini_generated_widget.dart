import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: DecoratedBox(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [
    Color(0xFF4A148C), // Deep Purple
    Color(0xFF7B1FA2), // Medium Purple
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    const Icon(
    Icons.rocket_launch, // A modern, engaging icon
    color: Colors.white,
    size: 120.0,
    ),
    const SizedBox(height: 24.0), // Spacing
    const Text(
    'Gemini App',
    style: TextStyle(
    color: Colors.white,
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
    ),
    ),
    const SizedBox(height: 16.0), // Spacing
    const Text(
    'Your Future, Now.',
    style: TextStyle(
    color: Colors.white70,
    fontSize: 20.0,
    fontStyle: FontStyle.italic,
    ),
    ),
    const SizedBox(height: 48.0), // More spacing before indicator
    const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    strokeWidth: 4.0,
    ),
    ],
    ),
    ),
    ),
    );
  }
}