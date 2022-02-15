import 'package:flutter/material.dart';
import 'reusable_card.dart';
import 'styles.dart';

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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            flex: 5,
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
          )
        ],
      ),
    );
  }
}
