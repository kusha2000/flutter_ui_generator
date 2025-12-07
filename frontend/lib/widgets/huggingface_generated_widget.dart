import 'package:flutter/material.dart';

class HuggingFaceGeneratedWidget extends StatelessWidget {
  const HuggingFaceGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Modern Dashboard'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    leading: IconButton(
    icon: const Icon(Icons.menu),
    tooltip: 'Menu',
    onPressed: () {},
    ),
    ),
    drawer: Drawer(
    child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
    const DrawerHeader(
    decoration: BoxDecoration(
    color: Colors.blue,
    ),
    child: Text(
    'Dashboard Menu',
    style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    ),
    ListTile(
    leading: const Icon(Icons.home),
    title: const Text('Home'),
    onTap: () {
      Navigator.pop(context);
    },
    ),
    ListTile(
    leading: const Icon(Icons.analytics),
    title: const Text('Analytics'),
    onTap: () {
      Navigator.pop(context);
    },
    ),
    ListTile(
    leading: const Icon(Icons.settings),
    title: const Text('Settings'),
    onTap: () {
      Navigator.pop(context);
    },
    ),
    ],
    ),
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Welcome to your Modern Dashboard',
    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 16.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Daily Summary',
    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Total Sales',
    style: TextStyle(fontSize: 16.0, color: Colors.grey),
    ),
    const Text(
    '\$12,000',
    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
    ],
    ),
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'New Users',
    style: TextStyle(fontSize: 16.0, color: Colors.grey),
    ),
    const Text(
    '250',
    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
    ],
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    SizedBox(height: 16.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Recent Activity',
    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    ListTile(
    leading: const CircleAvatar(
    backgroundImage: NetworkImage('https: //via.placeholder.com/50'),
    ),
    title: const Text('John Doe'),
    subtitle: const Text('Added a new project'),
    trailing: const Icon(Icons.arrow_forward_ios),
    ),
    ListTile(
    leading: const CircleAvatar(
    backgroundImage: NetworkImage('https: //via.placeholder.com/50'),
    ),
    title: const Text('Jane Smith'),
    subtitle: const Text('Completed a task'),
    trailing: const Icon(Icons.arrow_forward_ios),
    ),
    ],
    ),
    ),
    ),
    SizedBox(height: 16.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Notifications',
    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    ListTile(
    leading: const Icon(Icons.new_releases),
    title: const Text('Update Available'),
    subtitle: const Text('Check for latest features.'),
    trailing: const Icon(Icons.arrow_forward_ios),
    ),
    ListTile(
    leading: const Icon(Icons.warning_amber_rounded),
    title: const Text('Low Disk Space'),
    subtitle: const Text('Clean up some files to free up space.'),
    trailing: const Icon(Icons.arrow_forward_ios),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    );
  }
}