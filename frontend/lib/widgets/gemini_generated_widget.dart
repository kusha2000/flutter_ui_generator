import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a modern color scheme for the splash screen
    const Color primaryColor = Color(0xFF6366F1); // Indigo 500
    const Color secondaryColor = Color(0xFF8B5CF6); // Violet 500
    const Color onPrimaryColor = Colors.white;
    const Color taglineColor = Color(0xFFE0E0E0); // Slightly off-white for contrast

    return Scaffold(
    body: Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    // App Icon/Logo
    Icon(
    Icons.rocket_launch, // A modern, engaging icon
    size: MediaQuery.sizeOf(context).width * 0.3, // Responsive size
    color: onPrimaryColor,
    ),
    const SizedBox(height: 24.0), // Spacing of 24 pixels
    // App Name
    const Text(
    'AstroLaunch', // Placeholder App Name
    style: TextStyle(
    color: onPrimaryColor,
    fontSize: 36.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
    ),
    ),
    const SizedBox(height: 16.0), // Spacing of 16 pixels
    // Optional: Tagline or version
    const Text(
    'Explore the Cosmos',
    style: TextStyle(
    color: taglineColor,
    fontSize: 18.0,
    fontStyle: FontStyle.italic,
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}