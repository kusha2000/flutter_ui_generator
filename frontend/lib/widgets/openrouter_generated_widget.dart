import 'package:flutter/material.dart';

class OpenRouterGeneratedWidget extends StatelessWidget {
  const OpenRouterGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Notifications'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    const SizedBox(height: 16),
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    Row(
    children: [
    const Icon(Icons.notifications, size: 24),
    const SizedBox(width: 8),
    const Text('New Message'),
    ],
    ),
    const SizedBox(height: 8),
    const Text('You have a new message from John Doe'),
    ],
    ),
    ),
    ),
    const SizedBox(height: 16),
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    Row(
    children: [
    const Icon(Icons.update, size: 24),
    const SizedBox(width: 8),
    const Text('App Update'),
    ],
    ),
    const SizedBox(height: 8),
    const Text('A new version of the app is available'),
    ],
    ),
    ),
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.white,
    ),
    onPressed: () {},
    child: const Text('Mark all as read'),
    ),
    ],
    ),
    ),
    ),
    );
  }
}