import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Define some sample data for the dashboard
    final List<Map<String, dynamic>> overviewMetrics = [
    {'icon': Icons.people_alt, 'title': 'Total Users', 'value': '1,234'},
    {'icon': Icons.shopping_cart, 'title': 'New Orders', 'value': '56'},
    {'icon': Icons.attach_money, 'title': 'Revenue', 'value': '\$12,345'},
    {'icon': Icons.bar_chart, 'title': 'Page Views', 'value': '78,901'},
    ];

    final List<Map<String, dynamic>> recentActivities = [
    {'icon': Icons.person_add, 'title': 'New user registered', 'subtitle': 'John Doe', 'time': '2 min ago'},
    {'icon': Icons.shopping_bag, 'title': 'Order #1234 placed', 'subtitle': 'Product X, Y', 'time': '1 hour ago'},
    {'icon': Icons.payment, 'title': 'Payment processed', 'subtitle': 'For Order #1233', 'time': '3 hours ago'},
    {'icon': Icons.settings, 'title': 'System update applied', 'subtitle': 'Version 2.1.0', 'time': 'Yesterday'},
    ];

    return Scaffold(
    appBar: AppBar(
    title: const Text(
    'Admin Dashboard',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white, // Text color for app bar
    ),
    ),
    backgroundColor: colorScheme.primary, // Using primary color for AppBar
    elevation: 4,
    actions: [
    IconButton(
    icon: const Icon(Icons.notifications, color: Colors.white),
    onPressed: () {
      // Handle notifications
    },
    ),
    IconButton(
    icon: const Icon(Icons.account_circle, color: Colors.white),
    onPressed: () {
      // Handle profile
    },
    ),
    const SizedBox(width: 8),
    ],
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Welcome Section
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.only(bottom: 24),
    child: Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    gradient: LinearGradient(
    colors: [colorScheme.primary.withOpacity(0.8), colorScheme.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: Row(
    children: [
    Icon(Icons.dashboard, size: 48, color: colorScheme.onPrimary),
    const SizedBox(width: 16),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Welcome Back, Admin!',
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: colorScheme.onPrimary,
    ),
    ),
    const SizedBox(height: 8),
    Text(
    'Here\'s a quick overview of your system.',
    style: TextStyle(
    fontSize: 16,
    color: colorScheme.onPrimary.withOpacity(0.9),
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    ),

    // Overview Metrics Section
    Text(
    'Overview',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: colorScheme.onSurface,
    ),
    ),
    const SizedBox(height: 16),
    GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: screenSize.width > 600 ? 4 : 2, // Responsive grid
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 1.5, // Adjust aspect ratio for card height
    ),
    itemCount: overviewMetrics.length,
    itemBuilder: (context, index) {
      final metric = overviewMetrics[index];
      return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Icon(metric['icon'] as IconData, size: 32, color: colorScheme.secondary),
      const SizedBox(height: 8),
      Text(
      metric['title'] as String,
      style: TextStyle(
      fontSize: 14,
      color: colorScheme.onSurface.withOpacity(0.7),
      ),
      ),
      Text(
      metric['value'] as String,
      style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
      ),
      ),
      ],
      ),
      ),
      );
    },
    ),

    const SizedBox(height: 32),

    // Recent Activity Section
    Text(
    'Recent Activity',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: colorScheme.onSurface,
    ),
    ),
    const SizedBox(height: 16),
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: recentActivities.length,
    itemBuilder: (context, index) {
      final activity = recentActivities[index];
      return Column(
      children: [
      ListTile(
      leading: Icon(activity['icon'] as IconData, color: colorScheme.secondary),
      title: Text(
      activity['title'] as String,
      style: TextStyle(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
      ),
      subtitle: Text(
      activity['subtitle'] as String,
      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
      ),
      trailing: Text(
      activity['time'] as String,
      style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)),
      ),
      onTap: () {
        // Handle activity tap
      },
      ),
      if (index < recentActivities.length - 1)
      Divider(height: 1, indent: 16, endIndent: 16, color: colorScheme.outlineVariant),
      ],
      );
    },
    ),
    ),

    const SizedBox(height: 32),

    // Quick Actions Section
    Text(
    'Quick Actions',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: colorScheme.onSurface,
    ),
    ),
    const SizedBox(height: 16),
    Wrap(
    spacing: 16, // Horizontal spacing
    runSpacing: 16, // Vertical spacing
    children: [
    ElevatedButton.icon(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 4,
    ),
    icon: const Icon(Icons.add),
    label: const Text('Add New User'),
    ),
    OutlinedButton.icon(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
    foregroundColor: colorScheme.primary,
    side: BorderSide(color: colorScheme.primary, width: 2),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    icon: const Icon(Icons.settings),
    label: const Text('System Settings'),
    ),
    TextButton.icon(
    onPressed: () {},
    style: TextButton.styleFrom(
    foregroundColor: colorScheme.secondary,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    icon: const Icon(Icons.report),
    label: const Text('View Reports'),
    ),
    ],
    ),
    ],
    ),
    ),
    );
  }
}