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
          const SizedBox(height: 32),
          SettingsGroup(
            title: 'FEEDBACK',
            children: <Widget>[
              const SizedBox(height: 8),
              buildReportBug(),
              buildSendFeedback(),
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
    onTap: () {},
  );

  Widget buildDeleteAccount() => SimpleSettingsTile(
    title: 'Delete Account',
    subtitle: '',
    leading: IconWidget(icon: Icons.delete, color: Colors.pink),
    onTap: () {},
  );

  Widget buildReportBug() => SimpleSettingsTile(
    title: 'Report A Bug',
    subtitle: '',
    leading: IconWidget(icon: Icons.bug_report, color: Colors.teal),
    onTap: () {},
  );

  Widget buildSendFeedback() => SimpleSettingsTile(
    title: 'Send Feedback',
    subtitle: '',
    leading: IconWidget(icon: Icons.thumb_up, color: Colors.purple),
    onTap: () {},
  );
}
