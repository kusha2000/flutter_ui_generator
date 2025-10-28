import 'package:flutter/material.dart';

class GeneratedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF008080), Color(0xFF800080)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(
                  Icons.videogame_asset,
                  size: 50,
                  color: Color(0xFFFF1493),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'RetroGame',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'PressStart2P',
                  color: Color(0xFFFFFF00),
                ),
              ),
              Spacer(flex: 3),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF1493)),
                strokeWidth: 3,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}