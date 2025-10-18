import 'package:flutter/material.dart';

class OpenRouterGeneratedWidget extends StatelessWidget {
  const OpenRouterGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Admin Dashboard'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    const SizedBox(height: 16),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    onPressed: () {},
    child: const Text('Manage Users'),
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    onPressed: () {},
    child: const Text('View Reports'),
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
    const ListTile(
    leading: Icon(Icons.people),
    title: Text('Total Users'),
    subtitle: Text('1000'),
    ),
    const ListTile(
    leading: Icon(Icons.file_copy),
    title: Text('Total Reports'),
    subtitle: Text('500'),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 16),
    TextButton(
    style: TextButton.styleFrom(
    foregroundColor: Theme.of(context).colorScheme.primary,
    ),
    onPressed: () {},
    child: const Text('Settings'),
    ),
    ],
    ),
    ),
    ),
    );
  }
}