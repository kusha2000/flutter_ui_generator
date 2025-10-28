import 'package:flutter/material.dart';

class GeneratedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            'Notifications',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 10,
        itemBuilder: (context, index) {
          bool isUnread = index % 2 == 0;
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100]!,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: pastelColors[index % pastelColors.length],
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  if (isUnread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                'User ${index + 1}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              subtitle: Text(
                'New message received...',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              trailing: Text(
                '${index + 1} min ago',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }

  static  List<Color> pastelColors = [
    Colors.pink[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.yellow[100]!,
  ];
}