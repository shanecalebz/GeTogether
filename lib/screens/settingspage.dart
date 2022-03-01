import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:getogether/widgets/icon_widget.dart';

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
            children: <Widget>[
              buildLogout(),
              buildDeleteAccount(),
            ],
          ),
        ],
      ),
    ),
  );

  Widget buildLogout() => SimpleSettingsTile(
    title: 'Logout',
    subtitle: '',
    leading: IconWidget(icon: Icons.logout, color: Colors.blueAccent),
    onTap: () => Utils.showSnackBar(context, 'Clicked Logout'),
  );

  Widget buildDeleteAccount() => SimpleSettingsTile(
    title: 'Logout',
    subtitle: '',
    leading: IconWidget(icon: Icons.delete, color: Colors.pink),
    onTap: () => Utils.showSnackBar(context, 'Clicked Delete Account'),
  );
}
