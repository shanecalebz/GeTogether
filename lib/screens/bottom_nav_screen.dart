import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:getogether/group_chats/group_features.dart';
import 'package:getogether/utils/constants.dart';
import '../group_chats/group_chat_screen.dart';
import 'screens.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List _screens = [
    GroupFeatureScreen(),
    HomeScreen(),
    SettingsPage(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Palette.primaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.white,
        elevation: 0.0,
        items: [Icons.home, Icons.monetization_on_rounded, Icons.settings]
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    label: '',
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: _currentIndex == key
                            ? Colors.white70
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(value),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}
