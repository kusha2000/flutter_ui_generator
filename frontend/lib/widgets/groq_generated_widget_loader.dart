import 'package:flutter/material.dart';

class GroqGeneratedWidget extends StatelessWidget {
  const GroqGeneratedWidget({super.key});

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
    Color(0xFF8B94FC),
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
    'Welcome',
    style: TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 32),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF8B94FC),
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    ),
    onPressed: () {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
      builder: (context) => const GroqGeneratedWidget(),
      ),
      );
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