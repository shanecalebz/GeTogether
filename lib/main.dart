import 'package:flutter/material.dart';
import 'screens/bottom_nav_screen.dart';

void main() => runApp(GeTogether());

class GeTogether extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeTogether',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Color(0xFF1B0376),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomNavScreen(),
    );
  }
}
