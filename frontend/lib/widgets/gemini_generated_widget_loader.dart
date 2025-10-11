import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Modern gradient from Indigo to Violet
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const FlutterLogo(
    size: 120.0,
    style: FlutterLogoStyle.horizontal,
    textColor: Colors.white,
    ),
    const SizedBox(height: 24.0), // Spacing
    Text(
    'My Awesome App',
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    ),
    ),
    const SizedBox(height: 16.0), // Spacing
    const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    strokeWidth: 3.0,
    ),
    const SizedBox(height: 16.0), // Spacing
    Text(
    'Loading your experience...',
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    color: Colors.white70,
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}