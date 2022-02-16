import 'package:flutter/material.dart';
import 'reusable_card.dart';
import 'styles.dart';
import 'groups_page.dart';
import 'settings_page.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.people_outline),
        leadingWidth: 60,
        title: Text('Quickview'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.notifications),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text('No new notifications'),
              )
            ],
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'UPCOMING',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ReusableCard(
                    colour: Color(0xFFE9D8A6),
                    cardChild: Column(
                      children: <Widget>[
                        Text(
                          'DATE',
                          style: kSubGroupHeaderStyle,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: Color(0xFFE9D8A6),
                    cardChild: Column(
                      children: <Widget>[
                        Text(
                          'GROUP',
                          style: kSubGroupHeaderStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: Color(0xFFE9D8A6),
                    cardChild: Column(
                      children: <Widget>[
                        Text(
                          'STATUS',
                          style: kSubGroupHeaderStyle,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: BottomButton(
                  buttonIcon: Icon(
                    Icons.people,
                    size: 30.0,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/groups');
                  },
                ),
              ),
              Expanded(
                child: BottomButton(
                  buttonIcon: Icon(
                    Icons.home,
                    size: 30.0,
                  ),
                ),
              ),
              Expanded(
                child: BottomButton(
                  buttonIcon: Icon(
                    Icons.settings,
                    size: 30.0,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  BottomButton({required this.buttonIcon, this.onTap});

  final VoidCallback? onTap;
  final Icon buttonIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: buttonIcon,
        ),
        color: Color(0xFF8ecae6),
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.only(bottom: 20.0),
        width: double.infinity,
        height: 80.0,
      ),
    );
  }
}
