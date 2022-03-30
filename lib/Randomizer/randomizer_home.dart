import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'categories.dart';

class RandomizerHome extends StatefulWidget {
  @override
  _RandomizerHomeState createState() => _RandomizerHomeState();
}

class _RandomizerHomeState extends State<RandomizerHome> {
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
      body: Padding(
        padding:
            EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (_) => Categories(selectionIndex: 0)));
                  },
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  child: Container(
                    width: double.infinity,
                    height: 75.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: Center(
                      child: Text(
                        "What to Eat?",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => Categories(selectionIndex: 1)));
                },
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: Container(
                  width: double.infinity,
                  height: 75.0,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Center(
                    child: Text(
                      "What to Do?",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
