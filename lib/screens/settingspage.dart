import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:getogether/screens/profile.dart';
import 'package:getogether/widgets/icon_widget.dart';
import '../Authenticate/Methods.dart';
import '../utils/constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.primaryColor,
          title: Text('Settings'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            )
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(10.0),
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
        title: 'Log Out',
        subtitle: '',
        leading: IconWidget(icon: Icons.logout_outlined, color: Colors.pink),
        onTap: () => logOut(context),
      );

  Widget buildDeleteAccount() => SimpleSettingsTile(
        title: 'Profile',
        subtitle: '',
        leading: IconWidget(icon: Icons.person_outline, color: Colors.pink),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ProfileView())),
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
