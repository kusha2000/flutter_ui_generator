import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
    appBar: AppBar(
    backgroundColor: colorScheme.primary,
    title: Text(
    'Dashboard',
    style: textTheme.headlineSmall?.copyWith(color: colorScheme.onPrimary),
    ),
    centerTitle: false,
    actions: [
    IconButton(
    icon: Icon(Icons.notifications_none, color: colorScheme.onPrimary),
    onPressed: () {},
    ),
    IconButton(
    icon: Icon(Icons.settings, color: colorScheme.onPrimary),
    onPressed: () {},
    ),
    const SizedBox(width: 8),
    ],
    elevation: 4,
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Welcome Card
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.only(bottom: 24),
    child: Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [colorScheme.primary.withOpacity(0.8), colorScheme.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
    children: [
    CircleAvatar(
    radius: 32,
    backgroundColor: colorScheme.onPrimary,
    child: Icon(Icons.person, size: 40, color: colorScheme.primary),
    ),
    const SizedBox(width: 16),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Welcome Back, John!',
    style: textTheme.headlineSmall?.copyWith(
    color: colorScheme.onPrimary,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 4),
    Text(
    'Here\'s your daily overview.',
    style: textTheme.bodyMedium?.copyWith(
    color: colorScheme.onPrimary.withOpacity(0.8),
    ),
    ),
    ],
    ),
    ),
    IconButton(
    icon: Icon(Icons.edit, color: colorScheme.onPrimary),
    onPressed: () {},
    ),
    ],
    ),
    ),
    ),

    // Quick Stats Grid
    Text(
    'Quick Stats',
    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16),
    GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 4 : 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    children: [
    _buildStatCard(
    context,
    icon: Icons.trending_up,
    title: 'Sales',
    value: '\$12,450',
    color: colorScheme.tertiary,
    ),
    _buildStatCard(
    context,
    icon: Icons.shopping_cart,
    title: 'Orders',
    value: '3,210',
    color: colorScheme.secondary,
    ),
    _buildStatCard(
    context,
    icon: Icons.people,
    title: 'Users',
    value: '1,890',
    color: colorScheme.error,
    ),
    _buildStatCard(
    context,
    icon: Icons.attach_money,
    title: 'Revenue',
    value: '\$8,760',
    color: colorScheme.surfaceTint,
    ),
    ],
    ),

    const SizedBox(height: 32),

    // Recent Activity
    Text(
    'Recent Activity',
    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16),
    Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
    children: [
    _buildActivityListTile(
    context,
    icon: Icons.check_circle_outline,
    title: 'Order #12345 confirmed',
    subtitle: 'New order from Jane Doe',
    time: '2 min ago',
    color: Colors.green,
    ),
    Divider(height: 0, indent: 16, endIndent: 16, color: colorScheme.outlineVariant),
    _buildActivityListTile(
    context,
    icon: Icons.payment,
    title: 'Payment processed',
    subtitle: 'Subscription renewal for John Smith',
    time: '1 hour ago',
    color: Colors.blue,
    ),
    Divider(height: 0, indent: 16, endIndent: 16, color: colorScheme.outlineVariant),
    _buildActivityListTile(
    context,
    icon: Icons.person_add,
    title: 'New user registered',
    subtitle: 'Welcome, Alice Johnson!',
    time: '3 hours ago',
    color: Colors.purple,
    ),
    Divider(height: 0, indent: 16, endIndent: 16, color: colorScheme.outlineVariant),
    _buildActivityListTile(
    context,
    icon: Icons.warning_amber,
    title: 'Low stock alert',
    subtitle: 'Product X is running low',
    time: 'Yesterday',
    color: Colors.orange,
    ),
    ],
    ),
    ),

    const SizedBox(height: 32),

    // Call to Action Button
    Center(
    child: ElevatedButton.icon(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: colorScheme.secondary,
    foregroundColor: colorScheme.onSecondary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    ),
    icon: const Icon(Icons.add_circle_outline, size: 24),
    label: Text(
    'Add New Item',
    style: textTheme.titleMedium?.copyWith(color: colorScheme.onSecondary),
    ),
    ),
    ),
    const SizedBox(height: 16),
    ],
    ),
    ),
    );
  }

  Widget _buildStatCard(
  BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;

  return Card(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: InkWell(
  onTap: () {
    // Handle tap
  },
  borderRadius: BorderRadius.circular(12),
  child: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Container(
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
  color: color.withOpacity(0.15),
  borderRadius: BorderRadius.circular(8),
  ),
  child: Icon(icon, color: color, size: 28),
  ),
  const SizedBox(height: 12),
  Text(
  title,
  style: textTheme.titleMedium?.copyWith(
  fontWeight: FontWeight.w500,
  color: colorScheme.onSurface,
  ),
  ),
  Text(
  value,
  style: textTheme.headlineSmall?.copyWith(
  fontWeight: FontWeight.bold,
  color: colorScheme.primary,
  ),
  ),
  ],
  ),
  ),
  ),
  );
}

Widget _buildActivityListTile(
BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required String time,
  required Color color,
}) {
final ColorScheme colorScheme = Theme.of(context).colorScheme;
final TextTheme textTheme = Theme.of(context).textTheme;

return ListTile(
leading: CircleAvatar(
backgroundColor: color.withOpacity(0.15),
child: Icon(icon, color: color),
),
title: Text(
title,
style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
),
subtitle: Text(
subtitle,
style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
),
trailing: Text(
time,
style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
),
onTap: () {
  // Handle activity tap
},
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
);
}
}