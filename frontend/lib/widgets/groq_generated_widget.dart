import 'package:flutter/material.dart';

class GroqGeneratedWidget extends StatelessWidget {
  const GroqGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
    body: Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: SafeArea(
    child: Center(
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    Icon(
    Icons.flutter_dash,
    size: size.width * 0.3,
    color: Theme.of(context).colorScheme.primary,
    ),
    const SizedBox(height: 24),
    const Text(
    'Welcome to MyApp',
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    const SizedBox(height: 16),
    const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}