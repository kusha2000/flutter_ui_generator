import 'package:flutter/material.dart';

class HuggingFaceGeneratedWidget extends StatelessWidget {
  const HuggingFaceGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Admin Dashboard'),
    backgroundColor: const Color(0xFF6366F1),
    actions: [
    IconButton(
    icon: const Icon(Icons.notifications),
    onPressed: () {},
    ),
    IconButton(
    icon: const Icon(Icons.person),
    onPressed: () {},
    ),
    ],
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(height: 24.0),
    const Text(
    'Overview',
    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8.0),
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
    'Total Users',
    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8.0),
    const Text(
    '1,234',
    style: TextStyle(fontSize: 24.0),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 24.0),
    const Text(
    'Recent Activities',
    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8.0),
    ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 5,
    itemBuilder: (context, index) {
      return ListTile(
      leading: CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.account_circle),
      ),
      title: const Text('John Doe'),
      subtitle: const Text('Updated profile picture'),
      trailing: const Icon(Icons.arrow_forward_ios),
      );
    },
    ),
    const SizedBox(height: 24.0),
    const Text(
    'Settings',
    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8.0),
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
    'Dark Mode',
    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8.0),
    SwitchListTile(
    value: false,
    onChanged: (bool value) {},
    secondary: const Icon(Icons.dark_mode),
    title: const Text('Enable Dark Mode'),
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