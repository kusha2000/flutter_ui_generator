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
    'Welcome, Admin!',
    style: Theme.of(context).textTheme.headlineSmall,
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
    children: [
    Text(
    'User Management',
    style: Theme.of(context).textTheme.titleLarge,
    ),
    const SizedBox(height: 8),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Search Users',
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    ),
    child: Text(
    'Manage Users',
    style: TextStyle(color: Colors.white),
    ),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 24),
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
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
    Row(
    children: [
    Expanded(
    child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.blue[100],
    borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
    children: [
    Text(
    'Total Users',
    style: Theme.of(context).textTheme.bodyLarge,
    ),
    Text(
    '10,000',
    style: Theme.of(context).textTheme.headlineMedium,
    ),
    ],
    ),
    ),
    ),
    Expanded(
    child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.green[100],
    borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
    children: [
    Text(
    'Active Users',
    style: Theme.of(context).textTheme.bodyLarge,
    ),
    Text(
    '7,500',
    style: Theme.of(context).textTheme.headlineMedium,
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    ),
    child: Text(
    'View Analytics',
    style: TextStyle(color: Colors.white),
    ),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 24),
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
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
    ListTile(
    title: Text('General Settings'),
    trailing: Icon(Icons.arrow_forward_ios),
    onTap: () {},
    ),
    ListTile(
    title: Text('Security'),
    trailing: Icon(Icons.arrow_forward_ios),
    onTap: () {},
    ),
    ListTile(
    title: Text('Notifications'),
    trailing: Icon(Icons.arrow_forward_ios),
    onTap: () {},
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