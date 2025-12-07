import 'package:flutter/material.dart';

class GeneratedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.account_balance, color: Colors.blue[800]),
        title: Text('Insights', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600)),
        actions: [
          Icon(Icons.settings, color: Colors.blue[800]),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back, Lisa!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMetricCard('6,789', 'Sales', LinearGradient(colors: [Colors.blue[200]!, Colors.blue[600]!]), Icons.trending_up),
                _buildMetricCard('3,456', 'Users', LinearGradient(colors: [Colors.blue[200]!, Colors.blue[600]!]), Icons.person_add),
                _buildMetricCard('85%', 'Performance', LinearGradient(colors: [Colors.blue[200]!, Colors.blue[600]!]), Icons.star),
                _buildMetricCard('30K', 'Revenue', LinearGradient(colors: [Colors.blue[200]!, Colors.blue[600]!]), Icons.monetization_on),
              ],
            ),
            SizedBox(height: 24),
            Text('Recent Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
            SizedBox(height: 12),
            _buildActivityItem(Icons.shopping_cart, 'Sale Closed', 'Order #2345', '2 min ago'),
            _buildActivityItem(Icons.person, 'User Added', 'Lisa Kim joined', '5 min ago'),
            _buildActivityItem(Icons.payment, 'Payment', '999.99', '10 min ago'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String value, String label, LinearGradient gradient, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              Icon(Icons.more_vert, color: Colors.white70, size: 16),
            ],
          ),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String subtitle, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue[100],
            child: Icon(icon, color: Colors.blue[800], size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        ],
      ),
    );
  }
}