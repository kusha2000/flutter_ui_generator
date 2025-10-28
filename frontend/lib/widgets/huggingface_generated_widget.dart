import 'package:flutter/material.dart';

class HuggingFaceGeneratedWidget extends StatelessWidget {
  const HuggingFaceGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Notifications'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const ListTile(
    leading: CircleAvatar(
    backgroundImage: NetworkImage('https: //via.placeholder.com/50'),
    ),
    title: Text('John Doe'),
    subtitle: Text('New message received'),
    trailing: Icon(Icons.new_releases),
    ),
    const SizedBox(height: 16.0),
    const ListTile(
    leading: Icon(Icons.event_available),
    title: Text('Event Reminder'),
    subtitle: Text('Meeting at 3 PM tomorrow'),
    trailing: Icon(Icons.arrow_forward_ios),
    ),
    const SizedBox(height: 16.0),
    const ListTile(
    leading: Icon(Icons.notifications_active),
    title: Text('System Update'),
    subtitle: Text('Version 2.0 available'),
    trailing: Icon(Icons.download_done),
    ),
    ],
    ),
    ),
    ),
    );
  }
}