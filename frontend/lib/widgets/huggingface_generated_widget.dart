import 'package:flutter/material.dart';

class HuggingFaceGeneratedWidget extends StatelessWidget {
  const HuggingFaceGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
    body: Container(
    width: size.width,
    height: size.height,
    decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
    ),
    ),
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Image.asset(
    'assets/images/logo.png',
    width: 100,
    height: 100,
    ),
    const SizedBox(height: 32),
    const CircularProgressIndicator(
    color: Colors.white,
    ),
    const SizedBox(height: 16),
    const Text(
    'Loading...',
    style: TextStyle(color: Colors.white, fontSize: 18),
    ),
    ],
    ),
    ),
    ),
    );
  }
}