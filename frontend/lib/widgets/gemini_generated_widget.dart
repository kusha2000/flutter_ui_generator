import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);

    // Sample data for dashboard
    final List<Map<String, dynamic>> stats = [
    {'title': 'Total Users', 'value': '1,234', 'icon': Icons.people_alt, 'color': colorScheme.primary},
    {'title': 'Total Orders', 'value': '567', 'icon': Icons.shopping_cart, 'color': colorScheme.secondary},
    {'title': 'Revenue', 'value': '\$12,345', 'icon': Icons.attach_money, 'color': colorScheme.tertiary},
    {'title': 'Products', 'value': '89', 'icon': Icons.inventory_2, 'color': colorScheme.error},
    ];

    final List<Map<String, String>> recentActivities = [
    {'action': 'User John Doe registered', 'time': '2 hours ago'},
    {'action': 'Order #1001 placed by Jane Smith', 'time': '5 hours ago'},
    {'action': 'Product "Laptop Pro" updated', 'time': '1 day ago'},
    {'action': 'Admin password changed', 'time': '2 days ago'},
    {'action': 'New category "Electronics" added', 'time': '3 days ago'},
    ];

    return Scaffold(
    appBar: AppBar(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    title: const Text('Admin Dashboard'),
    centerTitle: false,
    elevation: 4.0,
    actions: [
    IconButton(
    icon: const Icon(Icons.notifications_none),
    onPressed: () {
      // Handle notifications
    },
    tooltip: 'Notifications',
    ),
    IconButton(
    icon: const Icon(Icons.settings),
    onPressed: () {
      // Handle settings
    },
    tooltip: 'Settings',
    ),
    const SizedBox(width: 8.0),
    ],
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Welcome Card
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24.0),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [colorScheme.primary.withOpacity(0.8), colorScheme.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12.0),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Welcome, Admin!',
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
    color: colorScheme.onPrimary,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 8.0),
    Text(
    'Here\'s an overview of your system.',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
    color: colorScheme.onPrimary.withOpacity(0.9),
    ),
    ),
    const SizedBox(height: 16.0),
    Align(
    alignment: Alignment.bottomRight,
    child: CircleAvatar(
    radius: 30,
    backgroundColor: colorScheme.onPrimary.withOpacity(0.2),
    child: Icon(Icons.person, size: 36, color: colorScheme.onPrimary),
    ),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 24.0),

    // Key Metrics Section
    Text(
    'Key Metrics',
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16.0),
    GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: screenSize.width > 600 ? 4 : 2, // Responsive grid
    crossAxisSpacing: 16.0,
    mainAxisSpacing: 16.0,
    childAspectRatio: 1.2, // Adjust aspect ratio for card height
    ),
    itemCount: stats.length,
    itemBuilder: (context, index) {
      final stat = stats[index];
      return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Icon(stat['icon'] as IconData, size: 36, color: stat['color'] as Color),
      const SizedBox(height: 8.0),
      Text(
      stat['title'] as String,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
      ),
      ),
      Text(
      stat['value'] as String,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: stat['color'] as Color,
      ),
      ),
      ],
      ),
      ),
      );
    },
    ),
    const SizedBox(height: 24.0),

    // Recent Activity Section
    Text(
    'Recent Activity',
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Column(
    children: [
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
    'Latest Actions',
    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
    ),
    ),
    const Divider(height: 1, indent: 16.0, endIndent: 16.0),
    ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: recentActivities.length,
    itemBuilder: (context, index) {
      final activity = recentActivities[index];
      return ListTile(
      leading: Icon(Icons.info_outline, color: colorScheme.primary),
      title: Text(activity['action']!),
      subtitle: Text(activity['time']!),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
      onTap: () {
        // Handle activity tap
      },
      );
    },
    ),
    ],
    ),
    ),
    const SizedBox(height: 24.0),

    // Quick Actions Section
    Text(
    'Quick Actions',
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Wrap(
    spacing: 16.0, // horizontal space
    runSpacing: 16.0, // vertical space
    children: [
    ElevatedButton.icon(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 2,
    ),
    icon: const Icon(Icons.add_circle_outline),
    label: const Text('Add New User'),
    ),
    ElevatedButton.icon(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: colorScheme.secondary,
    foregroundColor: colorScheme.onSecondary,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 2,
    ),
    icon: const Icon(Icons.shopping_bag_outlined),
    label: const Text('Manage Orders'),
    ),
    OutlinedButton.icon(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
    foregroundColor: colorScheme.onSurface,
    side: BorderSide(color: colorScheme.outline),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    icon: const Icon(Icons.category_outlined),
    label: const Text('Edit Products'),
    ),
    OutlinedButton.icon(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
    foregroundColor: colorScheme.onSurface,
    side: BorderSide(color: colorScheme.outline),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    icon: const Icon(Icons.bar_chart),
    label: const Text('View Reports'),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 24.0),

    // Sales Overview Chart Placeholder Section
    Text(
    'Sales Overview',
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Monthly Sales Trend',
    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16.0),
    Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
    color: colorScheme.surfaceVariant.withOpacity(0.5),
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
    ),
    alignment: Alignment.center,
    child: Text(
    'Chart Placeholder',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
    ),
    ),
    const SizedBox(height: 8.0),
    Text(
    'Data updated as of ${DateTime.now().toLocal().toString().split(' ')[0]}',
    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 16.0), // Final spacing
    ],
    ),
    ),
    );
  }
}