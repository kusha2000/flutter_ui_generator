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
    colors: [Color(0xFF6366F1), Color(0xFF3B3DF0)],
    ),
    ),
    ),
    Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text(
    'Welcome to Cohere App',
    style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    const SizedBox(height: 24),
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: 8,
    offset: Offset(0, 4),
    ),
    ],
    ),
    child: Row(
    children: [
    const Icon(Icons.search, color: Color(0xFF6366F1)),
    const SizedBox(width: 16),
    Expanded(
    child: TextFormField(
    decoration: InputDecoration(
    hintText: 'Search for something...',
    border: InputBorder.none,
    hintStyle: TextStyle(color: Colors.grey),
    ),
    ),
    ),
    ],
    ),
    ),
    const SizedBox(height: 32),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6366F1),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
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