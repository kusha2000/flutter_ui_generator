import 'package:flutter/material.dart';

class OpenRouterGeneratedWidget extends StatelessWidget {
  const OpenRouterGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
    Color(0xFF6366F1),
    Color(0xFF7F53AC),
    ],
    ),
    ),
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Icon(
    Icons.home,
    size: 64,
    color: Colors.white,
    ),
    const SizedBox(height: 16),
    const Text(
    'Welcome to our App',
    style: TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 32),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    ),
    onPressed: () {
      Navigator.pushReplacementNamed(context, '/home');
    },
    child: const Text('Get Started'),
    ),
    ],
    ),
    ),
    ),
    );
  }
}