import 'package:flutter/material.dart';

class CohereGeneratedWidget extends StatelessWidget {
  const CohereGeneratedWidget({super.key});

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
    Text(
    'Recent Notifications',
    style: Theme.of(context).textTheme.bodyLarge,
    ),
    SizedBox(height: 16.0),
    ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 5,
    itemBuilder: (context, index) {
      return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
      leading: const Icon(Icons.notifications),
      title: Text('Notification $index'),
      subtitle: Text('This is a sample notification description.'),
      trailing: const Icon(Icons.arrow_forward_ios),
      ),
      );
    },
    ),
    Text(
    'Earlier Notifications',
    style: Theme.of(context).textTheme.bodyLarge,
    ),
    SizedBox(height: 16.0),
    ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 3,
    itemBuilder: (context, index) {
      return InkWell(
      onTap: () {},
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
      children: [
      const Icon(Icons.notifications_active),
      SizedBox(width: 16.0),
      Expanded(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text('Old Notification $index'),
      Text(
      'This is an older notification from a few days ago.',
      style: Theme.of(context).textTheme.bodyLarge,
      ),
      ],
      ),
      ),
      ],
      ),
      ),
      );
    },
    ),
    ],
    ),
    ),
    ),
    );
  }
}