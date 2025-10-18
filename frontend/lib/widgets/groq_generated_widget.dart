import 'package:flutter/material.dart';

class GroqGeneratedWidget extends StatelessWidget {
  const GroqGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final stats = [
    {
      'title': 'Users',
      'value': '1,254',
      'icon': Icons.people,
      'color': const Color(0xFF4F46E5),
    },
    {
      'title': 'Revenue',
      'value': '\$23.4k',
      'icon': Icons.attach_money,
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Orders',
      'value': '342',
      'icon': Icons.shopping_cart,
      'color': const Color(0xFFF59E0B),
    },
    {
      'title': 'Feedback',
      'value': '87',
      'icon': Icons.feedback,
      'color': const Color(0xFFEF4444),
    },
    ];
    final recentActivities = [
    {
      'title': 'New user signup',
      'subtitle': 'John Doe',
      'time': '5 min ago',
      'icon': Icons.person_add,
    },
    {
      'title': 'Order placed',
      'subtitle': 'Order #1024',
      'time': '12 min ago',
      'icon': Icons.shopping_bag,
    },
    {
      'title': 'Payment received',
      'subtitle': '\$120.00',
      'time': '30 min ago',
      'icon': Icons.payment,
    },
    {
      'title': 'Bug reported',
      'subtitle': 'Login issue',
      'time': '1 hr ago',
      'icon': Icons.bug_report,
    },
    ];

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
    const Text(
    'Statistics',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16),
    Wrap(
    spacing: 16,
    runSpacing: 16,
    children: stats.map((stat) {
      return SizedBox(
      width: (size.width - 64) / 2,
      child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
      colors: [
      stat['color'] as Color,
      (stat['color'] as Color).withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
      children: [
      Icon(
      stat['icon'] as IconData,
      size: 40,
      color: Colors.white,
      ),
      const SizedBox(width: 12),
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
      stat['title'] as String,
      style: const TextStyle(
      color: Colors.white70,
      fontSize: 14,
      ),
      ),
      const SizedBox(height: 4),
      Text(
      stat['value'] as String,
      style: const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      ),
      ),
      ],
      ),
      ],
      ),
      ),
      ),
      );
    }).toList(),
    ),
    const SizedBox(height: 32),
    const Text(
    'Recent Activities',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16),
    ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: recentActivities.length,
    itemBuilder: (context, index) {
      final activity = recentActivities[index];
      return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
      leading: Icon(
      activity['icon'] as IconData,
      color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(activity['title'] as String),
      subtitle: Text(activity['subtitle'] as String),
      trailing: Text(
      activity['time'] as String,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      onTap: () {},
      ),
      );
    },
    ),
    const SizedBox(height: 24),
    Center(
    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    onPressed: () {},
    child: const Text('View Full Report'),
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}