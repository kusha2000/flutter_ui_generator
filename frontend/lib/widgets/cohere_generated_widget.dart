import 'package:flutter/material.dart';

class CohereGeneratedWidget extends StatelessWidget {
  const CohereGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Stack(
    fit: StackFit.expand,
    children: [
    Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF3B3D99)],
    ),
    ),
    ),
    Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text(
    'Welcome to Cohere',
    style: TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 16),
    Text(
    'Explore the world of AI',
    style: TextStyle(
    color: Colors.white.withOpacity(0.8),
    fontSize: 18,
    ),
    ),
    const SizedBox(height: 32),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: const Color(0xFF6366F1),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    ),
    onPressed: () {},
    child: const Text('Get Started'),
    ),
    ],
    ),
    ],
    ),
    );
  }
}