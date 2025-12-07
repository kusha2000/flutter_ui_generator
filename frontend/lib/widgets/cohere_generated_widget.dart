import 'package:flutter/material.dart';

class CohereGeneratedWidget extends StatelessWidget {
  const CohereGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text(
    'Dashboard',
    style: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    backgroundColor: Colors.deepPurple,
    leading: IconButton(
    icon: const Icon(Icons.menu),
    tooltip: 'Menu',
    onPressed: () {},
    ),
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Welcome to Your Dashboard',
    style: Theme.of(context).textTheme.headlineMedium,
    ),
    const SizedBox(height: 16.0),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    _buildCard(
    color: Colors.blue,
    icon: Icons.trending_up,
    title: 'Sales',
    value: '12,456',
    ),
    _buildCard(
    color: Colors.green,
    icon: Icons.attach_money,
    title: 'Revenue',
    value: '\$78,900',
    ),
    _buildCard(
    color: Colors.amber,
    icon: Icons.person_add,
    title: 'Users',
    value: '3,200',
    ),
    ],
    ),
    const SizedBox(height: 24.0),
    Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    spreadRadius: 2.0,
    blurRadius: 8.0,
    ),
    ],
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Recent Activity',
    style: Theme.of(context).textTheme.titleMedium,
    ),
    const SizedBox(height: 16.0),
    ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 5,
    itemBuilder: (context, index) {
      return ListTile(
      leading: const Icon(Icons.circle),
      title: Text('Activity $index'),
      subtitle: Text('Details for activity $index'),
      );
    },
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

  Widget _buildCard({required Color color, required IconData icon, required String title, required String value}) {
    return Expanded(
    child: Card(
    color: color,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(icon, size: 36.0, color: Colors.white),
    const SizedBox(height: 16.0),
    Text(
    title,
    style: TextStyle(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    Text(
    value,
    style: TextStyle(
    color: Colors.white,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}