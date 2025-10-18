import 'package:flutter/material.dart';

class HuggingFaceGeneratedWidget extends StatelessWidget {
  const HuggingFaceGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Admin Dashboard'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    drawer: Drawer(
    child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
    const DrawerHeader(
    decoration: BoxDecoration(
    gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
    ),
    child: Text(
    'Admin Menu',
    style: TextStyle(color: Colors.white, fontSize: 24),
    ),
    ),
    ListTile(
    leading: const Icon(Icons.dashboard),
    title: const Text('Dashboard'),
    onTap: () {
      Navigator.pop(context);
    },
    ),
    ListTile(
    leading:  Icon(Icons.abc),
    title: const Text('Users'),
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
    ListTile(
    leading: const Icon(Icons.logout),
    title: const Text('Logout'),
    onTap: () {
      Navigator.pop(context);
    },
    ),
    ],
    ),
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text(
    'Welcome to Admin Dashboard',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    ),
    ),
    const SizedBox(height: 16),
     Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text(
    'Recent Activities',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    ),
    ),
    const SizedBox(height: 16),
     Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text(
    'System Information',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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