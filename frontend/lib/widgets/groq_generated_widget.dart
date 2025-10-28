import 'package:flutter/material.dart';

class GroqGeneratedWidget extends StatelessWidget {
  const GroqGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
    backgroundColor: Colors.transparent,
    body: Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: Center(
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    const Icon(
    Icons.flash_on,
    size: 96,
    color: Colors.white,
    ),
    const SizedBox(height: 24),
    Text(
    'Groq App',
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 16),
    SizedBox(
    width: size.width * 0.6,
    child: LinearProgressIndicator(
    backgroundColor: Colors.white24,
    color: Theme.of(context).colorScheme.secondary,
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}