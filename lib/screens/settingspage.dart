import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState () => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(24.0),
        children: [
          SettingsGroup(
            title: 'GENERAL',
            children: <Widget>[],
          ),
        ],
      ),
    ),
  );
}