import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Define colors for specific UI elements to ensure WCAG contrast and diversity
    final Color primaryTextColor = colorScheme.onSurface;
    final Color cardBackgroundColor = colorScheme.surfaceContainerHigh; // A slightly elevated surface color
    final Color cardOnBackgroundColor = colorScheme.onSurfaceVariant; // Text color for card backgrounds

    // Specific colors for status indicators, ensuring good contrast
    const Color successColor = Color(0xFF4CAF50); // Green
    const Color warningColor = Color(0xFFFFC107); // Amber
    const Color infoColor = Color(0xFF2196F3);  // Blue

    return Scaffold(
    appBar: AppBar(
    title: Text(
    'Dashboard Overview',
    style: textTheme.titleLarge?.copyWith(
    color: colorScheme.onPrimary,
    fontSize: 24.0, // Accessible font size
    fontWeight: FontWeight.bold,
    ),
    ),
    backgroundColor: colorScheme.primary,
    elevation: 4.0,
    actions: [
    IconButton(
    icon: const Icon(Icons.notifications_none_outlined),
    tooltip: 'View Notifications',
    color: colorScheme.onPrimary,
    onPressed: () {},
    ),
    IconButton(
    icon: const Icon(Icons.search),
    tooltip: 'Search Dashboard',
    color: colorScheme.onPrimary,
    onPressed: () {},
    ),
    ],
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0), // Adequate spacing
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Welcome Section - Diverse Layout 1 (Gradient Card)
    Container(
    padding: const EdgeInsets.all(20.0),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [colorScheme.primary.withOpacity(0.9), colorScheme.primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 10,
    offset: const Offset(0, 5),
    ),
    ],
    ),
    child: Row(
    children: [
    CircleAvatar(
    radius: 32.0,
    backgroundColor: colorScheme.secondaryContainer,
    child: Icon(Icons.person, size: 36.0, color: colorScheme.onSecondaryContainer),
    ),
    const SizedBox(width: 16.0),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Welcome, Alex!',
    style: textTheme.headlineSmall?.copyWith(
    color: colorScheme.onPrimary, // Ensure contrast
    fontWeight: FontWeight.bold,
    fontSize: 20.0, // Accessible font size
    ),
    overflow: TextOverflow.ellipsis,
    ),
    const SizedBox(height: 4.0),
    Text(
    'Here\'s your daily overview.',
    style: textTheme.bodyMedium?.copyWith(
    color: colorScheme.onPrimary.withOpacity(0.9), // Ensure contrast
    fontSize: 16.0, // Accessible font size
    ),
    overflow: TextOverflow.ellipsis,
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    const SizedBox(height: 24.0),

    // Summary Cards Section - Diverse Layout 2 (Grid of Cards)
    Text(
    'Key Metrics',
    style: textTheme.titleLarge?.copyWith(
    color: primaryTextColor,
    fontWeight: FontWeight.bold,
    fontSize: 20.0, // Accessible font size
    ),
    ),
    const SizedBox(height: 16.0),
    GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    crossAxisSpacing: 16.0,
    mainAxisSpacing: 16.0,
    childAspectRatio: 1.2, // Adjust aspect ratio for card size
    children: [
    _buildSummaryCard(
    context,
    icon: Icons.trending_up,
    label: 'Total Sales',
    value: '\$12,450',
    change: '+12% today',
    iconColor: successColor,
    cardColor: cardBackgroundColor,
    textColor: cardOnBackgroundColor,
    ),
    _buildSummaryCard(
    context,
    icon: Icons.group,
    label: 'New Users',
    value: '1,200',
    change: '+5% this week',
    iconColor: infoColor,
    cardColor: cardBackgroundColor,
    textColor: cardOnBackgroundColor,
    ),
    _buildSummaryCard(
    context,
    icon: Icons.task_alt,
    label: 'Tasks Completed',
    value: '85/100',
    change: '7 pending',
    iconColor: warningColor,
    cardColor: cardBackgroundColor,
    textColor: cardOnBackgroundColor,
    ),
    _buildSummaryCard(
    context,
    icon: Icons.star_rate,
    label: 'Avg. Rating',
    value: '4.8/5',
    change: 'Excellent!',
    iconColor: colorScheme.tertiary,
    cardColor: cardBackgroundColor,
    textColor: cardOnBackgroundColor,
    ),
    ],
    ),
    const SizedBox(height: 24.0),

    // Recent Activity Section - Diverse Layout 3 (List within a Card)
    Text(
    'Recent Activity',
    style: textTheme.titleLarge?.copyWith(
    color: primaryTextColor,
    fontWeight: FontWeight.bold,
    fontSize: 20.0, // Accessible font size
    ),
    ),
    const SizedBox(height: 16.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    color: cardBackgroundColor,
    child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
    children: [
    _buildActivityTile(
    context,
    icon: Icons.check_circle,
    title: 'Order #12345 Processed',
    subtitle: 'Shipped to John Doe',
    time: '10 min ago',
    iconColor: successColor,
    textColor: cardOnBackgroundColor,
    ),
    Divider(indent: 16.0, endIndent: 16.0, color: colorScheme.outlineVariant),
    _buildActivityTile(
    context,
    icon: Icons.person_add,
    title: 'New User Registered',
    subtitle: 'Welcome, Jane Smith!',
    time: '1 hour ago',
    iconColor: infoColor,
    textColor: cardOnBackgroundColor,
    ),
    Divider(indent: 16.0, endIndent: 16.0, color: colorScheme.outlineVariant),
    _buildActivityTile(
    context,
    icon: Icons.warning,
    title: 'Low Stock Alert',
    subtitle: 'Product X needs restocking',
    time: '3 hours ago',
    iconColor: warningColor,
    textColor: cardOnBackgroundColor,
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 24.0),

    // Quick Actions Section - Diverse Layout 4 (Horizontal Scrollable Buttons)
    Text(
    'Quick Actions',
    style: textTheme.titleLarge?.copyWith(
    color: primaryTextColor,
    fontWeight: FontWeight.bold,
    fontSize: 20.0, // Accessible font size
    ),
    ),
    const SizedBox(height: 16.0),
    SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
    children: [
    _buildActionButton(
    context,
    label: 'Add New Item',
    icon: Icons.add_box,
    onPressed: () {},
    buttonColor: colorScheme.primary,
    textColor: colorScheme.onPrimary,
    ),
    const SizedBox(width: 12.0),
    _buildActionButton(
    context,
    label: 'Generate Report',
    icon: Icons.analytics,
    onPressed: () {},
    buttonColor: colorScheme.secondary,
    textColor: colorScheme.onSecondary,
    ),
    const SizedBox(width: 12.0),
    _buildActionButton(
    context,
    label: 'Manage Users',
    icon: Icons.people,
    onPressed: () {},
    buttonColor: colorScheme.tertiary,
    textColor: colorScheme.onTertiary,
    ),
    const SizedBox(width: 12.0),
    _buildActionButton(
    context,
    label: 'Settings',
    icon: Icons.settings,
    onPressed: () {},
    buttonColor: colorScheme.surfaceVariant,
    textColor: colorScheme.onSurfaceVariant,
    ),
    ],
    ),
    ),
    const SizedBox(height: 24.0),

    // Progress Tracker - Diverse Layout 5 (Linear Progress within a Card)
    Text(
    'Monthly Goal Progress',
    style: textTheme.titleLarge?.copyWith(
    color: primaryTextColor,
    fontWeight: FontWeight.bold,
    fontSize: 20.0, // Accessible font size
    ),
    ),
    const SizedBox(height: 16.0),
    Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    color: cardBackgroundColor,
    child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    'Sales Target',
    style: textTheme.titleMedium?.copyWith(
    color: cardOnBackgroundColor,
    fontSize: 18.0,
    ),
    ),
    Text(
    '75%',
    style: textTheme.titleMedium?.copyWith(
    color: cardOnBackgroundColor,
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    ),
    ),
    ],
    ),
    const SizedBox(height: 12.0),
    LinearProgressIndicator(
    value: 0.75,
    backgroundColor: colorScheme.surfaceVariant,
    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
    minHeight: 10.0,
    borderRadius: BorderRadius.circular(5.0),
    ),
    const SizedBox(height: 8.0),
    Text(
    'Achieved \$7,500 of \$10,000 goal.',
    style: textTheme.bodySmall?.copyWith(
    color: cardOnBackgroundColor.withOpacity(0.7),
    fontSize: 14.0,
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    bottomNavigationBar: BottomNavigationBar(
    currentIndex: 0, // Home is selected
    selectedItemColor: colorScheme.primary,
    unselectedItemColor: colorScheme.onSurfaceVariant.withOpacity(0.6),
    selectedLabelStyle: textTheme.labelSmall?.copyWith(fontSize: 12.0),
    unselectedLabelStyle: textTheme.labelSmall?.copyWith(fontSize: 12.0),
    type: BottomNavigationBarType.fixed, // Ensures all labels are visible
    items: const [
    BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home),
    label: 'Home',
    tooltip: 'Go to Home Dashboard',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.analytics_outlined),
    activeIcon: Icon(Icons.analytics),
    label: 'Analytics',
    tooltip: 'View Analytics Reports',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.person_outline),
    activeIcon: Icon(Icons.person),
    label: 'Profile',
    tooltip: 'Manage Your Profile',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.settings_outlined),
    activeIcon: Icon(Icons.settings),
    label: 'Settings',
    tooltip: 'Adjust Application Settings',
    ),
    ],
    onTap: (index) {
      // Handle navigation
    },
    ),
    );
  }

  // Helper method for Summary Cards
  Widget _buildSummaryCard(
  BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String change,
    required Color iconColor,
    required Color cardColor,
    required Color textColor,
  }) {
  final TextTheme textTheme = Theme.of(context).textTheme;
  return Card(
  elevation: 4.0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  color: cardColor,
  child: InkWell(
  onTap: () {
    // Handle card tap
  },
  borderRadius: BorderRadius.circular(12.0),
  child: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Icon(icon, size: 28.0, color: iconColor),
  const SizedBox(width: 8.0), // Spacing between icon and label
  Expanded(
  child: Text(
  label,
  style: textTheme.bodyLarge?.copyWith(
  color: textColor.withOpacity(0.8),
  fontSize: 16.0, // Accessible font size
  ),
  overflow: TextOverflow.ellipsis,
  ),
  ),
  ],
  ),
  const SizedBox(height: 8.0),
  Text(
  value,
  style: textTheme.headlineSmall?.copyWith(
  color: textColor,
  fontWeight: FontWeight.bold,
  fontSize: 20.0, // Accessible font size
  ),
  overflow: TextOverflow.ellipsis,
  ),
  Text(
  change,
  style: textTheme.bodySmall?.copyWith(
  color: textColor.withOpacity(0.6),
  fontSize: 14.0,
  ),
  overflow: TextOverflow.ellipsis,
  ),
  ],
  ),
  ),
  ),
  );
}

// Helper method for Activity List Tiles
Widget _buildActivityTile(
BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required String time,
  required Color iconColor,
  required Color textColor,
}) {
final TextTheme textTheme = Theme.of(context).textTheme;
return ListTile(
leading: Icon(icon, color: iconColor, size: 28.0),
title: Text(
title,
style: textTheme.titleMedium?.copyWith(
color: textColor,
fontSize: 16.0, // Accessible font size
),
overflow: TextOverflow.ellipsis,
),
subtitle: Text(
subtitle,
style: textTheme.bodyMedium?.copyWith(
color: textColor.withOpacity(0.7),
fontSize: 14.0,
),
overflow: TextOverflow.ellipsis,
),
trailing: Text(
time,
style: textTheme.bodySmall?.copyWith(
color: textColor.withOpacity(0.5),
fontSize: 12.0,
),
),
onTap: () {
  // Handle activity tap
},
contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
);
}

// Helper method for Quick Action Buttons
Widget _buildActionButton(
BuildContext context, {
  required String label,
  required IconData icon,
  required VoidCallback onPressed,
  required Color buttonColor,
  required Color textColor,
}) {
final TextTheme textTheme = Theme.of(context).textTheme;
return SizedBox(
height: 48.0, // Minimum touch target size
child: ElevatedButton.icon(
onPressed: onPressed,
style: ElevatedButton.styleFrom(
backgroundColor: buttonColor,
foregroundColor: textColor,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
padding: const EdgeInsets.symmetric(horizontal: 16.0),
elevation: 2.0,
),
icon: Icon(icon, size: 20.0),
label: Text(
label,
style: textTheme.labelLarge?.copyWith(
fontSize: 16.0, // Accessible font size
),
overflow: TextOverflow.ellipsis,
),
),
);
}
}