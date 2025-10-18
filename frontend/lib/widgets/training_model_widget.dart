import 'package:flutter/material.dart';

class GeneratedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text('Admin Dashboard', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Icon(Icons.notifications, color: Colors.grey[600]),
          SizedBox(width: 16),
          CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/40'),
            radius: 18,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Users', '2,134', Colors.blue)),
                SizedBox(width: 12),
                Expanded(child: _buildStatCard('Revenue', '\$67,430', Colors.green)),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard('Orders', '1,056', Colors.red)),
                SizedBox(width: 12),
                Expanded(child: _buildStatCard('Growth', '15.3%', Colors.purple)),
              ],
            ),
            SizedBox(height: 24),
            Text('Recent Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ...List.generate(5, (index) => _buildActivityItem('User ${index + 1} performed action', '${index + 1}m ago')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/40'),
            radius: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity, style: TextStyle(fontWeight: FontWeight.w500)),
                Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}