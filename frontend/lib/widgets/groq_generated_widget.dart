import 'package:flutter/material.dart';

class GroqGeneratedWidget extends StatelessWidget {
  const GroqGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Admin Dashboard'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    elevation: 4,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Overview',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),
    Row(
    children: [
    Expanded(
    child: Card(
    elevation: 2,
    color: Theme.of(context).colorScheme.secondaryContainer,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Users',
    style: TextStyle(fontSize: 16),
    ),
    const SizedBox(height: 8),
    Text(
    '100',
    style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.primary),
    ),
    ],
    ),
    ),
    ),
    ),
    const SizedBox(width: 16),
    Expanded(
    child: Card(
    elevation: 2,
    color: Theme.of(context).colorScheme.secondaryContainer,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Orders',
    style: TextStyle(fontSize: 16),
    ),
    const SizedBox(height: 8),
    Text(
    '500',
    style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.primary),
    ),
    ],
    ),
    ),
    ),
    ),
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
    borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Actions',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    onPressed: () {},
    child: const Text('Create User'),
    ),
    const SizedBox(height: 8),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    onPressed: () {},
    child: const Text('View Orders'),
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