import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
    appBar: AppBar(
    title: const Text(
    'Notifications',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    backgroundColor: colorScheme.surfaceContainerHigh,
    foregroundColor: colorScheme.onSurface,
    elevation: 4,
    shadowColor: colorScheme.shadow.withOpacity(0.2),
    centerTitle: true,
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Today',
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
    color: colorScheme.onSurface,
    ),
    ),
    const SizedBox(height: 16),
    _buildNotificationCard(
    context,
    icon: Icons.message,
    iconColor: colorScheme.primary,
    title: 'New Message from Alex',
    subtitle: 'Hey, I just sent you the updated project files. Let me know what you think.',
    time: '2 min ago',
    ),
    const SizedBox(height: 12),
    _buildNotificationCard(
    context,
    icon: Icons.update,
    iconColor: colorScheme.secondary,
    title: 'App Update Available',
    subtitle: 'Version 2.1.0 is now available with new features and bug fixes. Update now!',
    time: '15 min ago',
    ),
    const SizedBox(height: 12),
    _buildNotificationCard(
    context,
    icon: Icons.event,
    iconColor: colorScheme.tertiary,
    title: 'Meeting Reminder',
    subtitle: 'Your daily stand-up meeting starts in 10 minutes. Join the call.',
    time: '30 min ago',
    ),
    const SizedBox(height: 24),
    Text(
    'Yesterday',
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
    color: colorScheme.onSurface,
    ),
    ),
    const SizedBox(height: 16),
    _buildNotificationCard(
    context,
    icon: Icons.star,
    iconColor: colorScheme.error,
    title: 'New Achievement Unlocked!',
    subtitle: 'Congratulations! You completed the "Daily Streak" challenge.',
    time: 'Yesterday, 5: 30 PM',
    ),
    const SizedBox(height: 12),
    _buildNotificationCard(
    context,
    icon: Icons.shopping_bag,
    iconColor: colorScheme.surfaceTint,
    title: 'Special Offer Just For You',
    subtitle: 'Get 20% off on your next purchase. Limited time offer!',
    time: 'Yesterday, 10: 00 AM',
    ),
    const SizedBox(height: 12),
    _buildNotificationCard(
    context,
    icon: Icons.security,
    iconColor: colorScheme.onSurfaceVariant,
    title: 'Security Alert',
    subtitle: 'Unusual login activity detected from an unknown device. Review your account.',
    time: 'Yesterday, 8: 00 AM',
    ),
    ],
    ),
    ),
    );
  }

  Widget _buildNotificationCard(
  BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  return Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  ),
  margin: EdgeInsets.zero,
  child: InkWell(
  onTap: () {
    // Handle notification tap
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Tapped on: $title')),
    );
  },
  borderRadius: BorderRadius.circular(12),
  child: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  CircleAvatar(
  radius: 24,
  backgroundColor: iconColor.withOpacity(0.15),
  child: Icon(
  icon,
  color: iconColor,
  size: 24,
  ),
  ),
  const SizedBox(width: 16),
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  title,
  style: Theme.of(context).textTheme.titleMedium?.copyWith(
  fontWeight: FontWeight.bold,
  color: colorScheme.onSurface,
  ),
  ),
  const SizedBox(height: 4),
  Text(
  subtitle,
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  color: colorScheme.onSurfaceVariant,
  ),
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  ),
  const SizedBox(height: 8),
  Text(
  time,
  style: Theme.of(context).textTheme.bodySmall?.copyWith(
  color: colorScheme.outline,
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  ),
  ),
  );
}
}