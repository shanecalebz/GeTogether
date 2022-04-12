import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
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
        automaticallyImplyLeading: false,
        backgroundColor: Palette.primaryColor,
        title: Stack(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                size: 23.5,
                color: Colors.white,
              ),
            ),
            Center(
                child: Text(
                    "Activities"
                )
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30.0, bottom: 30.0, left: 30.0, right: 30.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Container(
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => Categories(selectionIndex: 0, selectionText: "What to Eat?")));
                      },
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.fastfood_outlined,
                                size: 45.0,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              "What to Eat?",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'JosefinSans',
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (_) => Categories(selectionIndex: 1, selectionText: "What to Do?")));
                    },
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.attractions,
                              size: 45.0,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "What to Do?",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'JosefinSans',
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
