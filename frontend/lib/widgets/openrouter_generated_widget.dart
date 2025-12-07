import 'package:flutter/material.dart';

class OpenRouterGeneratedWidget extends StatelessWidget {
  const OpenRouterGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text(
    'Modern Dashboard',
    style: TextStyle(fontSize: 20.0),
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
    leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    tooltip: 'Go Back',
    onPressed: () {},
    ),
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(height: 16.0),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: Theme.of(context).colorScheme.onSecondary,
    ),
    onPressed: () {},
    child: const Text('Create New Project'),
    ),
    const SizedBox(height: 16.0),
    const Text(
    'Recent Projects',
    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8.0),
    ListView(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: [
    ListTile(
    title: const Text('Project 1'),
    subtitle: const Text('Description of Project 1'),
    leading: const Icon(Icons.folder),
    ),
    ListTile(
    title: const Text('Project 2'),
    subtitle: const Text('Description of Project 2'),
    leading: const Icon(Icons.folder),
    ),
    ListTile(
    title: const Text('Project 3'),
    subtitle: const Text('Description of Project 3'),
    leading: const Icon(Icons.folder),
    ),
    ],
    ),
    const SizedBox(height: 16.0),
    const Text(
    'Statistics',
    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8.0),
    Row(
    children: [
    Expanded(
    child: Card(
    elevation: 2.0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    const Text(
    'Total Projects',
    style: TextStyle(fontSize: 16.0),
    ),
    const SizedBox(height: 8.0),
    const Text(
    '10',
    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
    ],
    ),
    ),
    ),
    ),
    const SizedBox(width: 16.0),
    Expanded(
    child: Card(
    elevation: 2.0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    const Text(
    'Completed Projects',
    style: TextStyle(fontSize: 16.0),
    ),
    const SizedBox(height: 8.0),
    const Text(
    '5',
    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
    );
  }
}