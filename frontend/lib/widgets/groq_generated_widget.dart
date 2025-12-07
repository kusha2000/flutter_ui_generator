import 'package:flutter/material.dart';

class GroqGeneratedWidget extends StatelessWidget {
  const GroqGeneratedWidget({super.key});

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
    icon: const Icon(Icons.menu),
    tooltip: 'Menu',
    onPressed: () {},
    ),
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Overview',
    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Statistics',
    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8.0),
    Row(
    children: [
    Expanded(
    child: ListTile(
    leading: const Icon(Icons.shopping_cart),
    title: const Text('Sales'),
    trailing: const Text('2500'),
    ),
    ),
    Expanded(
    child: ListTile(
    leading: const Icon(Icons.people),
    title: const Text('Customers'),
    trailing: const Text('500'),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 16.0),
    const Text(
    'Recent Activity',
    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
    shrinkWrap: true,
    children: [
    ListTile(
    leading: const Icon(Icons.person),
    title: const Text('John Doe'),
    subtitle: const Text('Joined the platform'),
    ),
    ListTile(
    leading: const Icon(Icons.shopping_cart),
    title: const Text('New order'),
    subtitle: const Text('Total: \$100'),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    bottomNavigationBar: BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    items: [
    BottomNavigationBarItem(
    icon: const Icon(Icons.dashboard),
    label: 'Dashboard',
    tooltip: 'Dashboard',
    ),
    BottomNavigationBarItem(
    icon: const Icon(Icons.settings),
    label: 'Settings',
    tooltip: 'Settings',
    ),
    BottomNavigationBarItem(
    icon: const Icon(Icons.info),
    label: 'Info',
    tooltip: 'Info',
    ),
    ],
    currentIndex: 0,
    onTap: (index) {},
    ),
    );
  }
}