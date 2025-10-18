import 'package:flutter/material.dart';

class CohereGeneratedWidget extends StatelessWidget {
  const CohereGeneratedWidget({super.key});

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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Welcome, Admin',
    style: Theme.of(context).textTheme.headlineSmall,
    ),
    const SizedBox(height: 16),
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    Text(
    'User Management',
    style: Theme.of(context).textTheme.titleLarge,
    ),
    const SizedBox(height: 8),
    Text(
    'Manage user accounts and permissions.',
    style: Theme.of(context).textTheme.bodyMedium,
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    ),
    child: const Text('Manage Users'),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 24),
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    Text(
    'Analytics',
    style: Theme.of(context).textTheme.titleLarge,
    ),
    const SizedBox(height: 8),
    Text(
    'View and analyze user engagement metrics.',
    style: Theme.of(context).textTheme.bodyMedium,
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    ),
    child: const Text('View Analytics'),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 24),
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    Text(
    'Settings',
    style: Theme.of(context).textTheme.titleLarge,
    ),
    const SizedBox(height: 8),
    Text(
    'Configure application settings.',
    style: Theme.of(context).textTheme.bodyMedium,
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    ),
    child: const Text('Open Settings'),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}