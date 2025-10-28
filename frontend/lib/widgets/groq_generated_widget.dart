import 'package:flutter/material.dart';

class GroqGeneratedWidget extends StatelessWidget {
  const GroqGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.sizeOf(context);
    final notifications = [
      {
        'title': 'New Message',
        'body': 'You have received a new message from John.',
        'time': '2 min ago',
        'icon': Icons.message,
        'color': Color(0xFF4F46E5),
      },
      {
        'title': 'Update Available',
        'body': 'Version 2.0.1 is now available for download.',
        'time': '1 hour ago',
        'icon': Icons.system_update,
        'color': Color(0xFF10B981),
      },
      {
        'title': 'Reminder',
        'body': "Don't forget your meeting at 3 PM.",
        'time': '3 hours ago',
        'icon': Icons.calendar_today,
        'color': Color(0xFFF59E0B),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = notifications[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: n['color'] as Color,
                child: Icon(
                  n['icon'] as IconData,
                  color: Colors.white,
                ),
              ),
              title: Text(
                n['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(n['body'] as String),
                  const SizedBox(height: 4),
                  Text(
                    n['time'] as String,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  // Dismiss action placeholder
                },
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          // Add notification action placeholder
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
