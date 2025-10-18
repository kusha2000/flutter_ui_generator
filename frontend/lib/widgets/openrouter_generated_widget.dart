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
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
    children: [
    const Icon(Icons.home, size: 24),
    const SizedBox(width: 8),
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
    Text('Total Users', style: TextStyle(fontSize: 16)),
    Text('1000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    ],
    ),
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
    child: Row(
    children: [
    const Icon(Icons.search, size: 24),
    const SizedBox(width: 8),
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
    Text('Total Searches', style: TextStyle(fontSize: 16)),
    Text('5000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    ],
    ),
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
    child: const Text('Manage Users'),
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.white,
    ),
    onPressed: () {},
    child: const Text('Manage Settings'),
    ),
    const SizedBox(height: 16),
    ListTile(
    leading: const Icon(Icons.logout),
    title: const Text('Logout'),
    onTap: () {},
    ),
    ],
    ),
    ),
    ),
    );
  }
}