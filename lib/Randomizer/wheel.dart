import 'dart:async';
import 'package:chat_app/Randomizer/suggestions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';


class Wheel extends StatefulWidget {

  int selectionIndex;
  int categoryIndex;
  List<String> categoryList;

  Wheel({required this.selectionIndex, required this.categoryIndex, required this.categoryList});

  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<Wheel> {

  TextEditingController textEditingController = new TextEditingController();
  StreamController<int> controller = StreamController<int>();
  List<String> userInput = [];
  double selectedTextOpacity = 0.0;
  late int count;
  var itemIndex = 0;

  Widget buildNavigation() {
    if (widget.categoryIndex == (widget.categoryList.length - 1)) {
      return Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (_) => Suggestions(selectionIndex: widget.selectionIndex))).then((value) {
                    if (value != null) {
                      setState(() {
                        if (textEditingController.text.isEmpty) {
                          textEditingController.text = value;
                        } else if (textEditingController.text.substring(textEditingController.text.length - 1) == ","){
                          textEditingController.text = textEditingController.text  + value;
                        } else {
                          textEditingController.text = textEditingController.text  + "," + value;
                        }
                      });
                    }
                  });
                },
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.lightbulb,
                      color: Colors.yellow[800],
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(15.0))
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildFortuneWheel() {
    if (widget.categoryIndex != (widget.categoryList.length - 1)) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: FortuneWheel(
            animateFirst: false,
            selected: controller.stream,
            indicators: <FortuneIndicator>[
              FortuneIndicator(
                alignment: Alignment.topCenter,
                // <-- changing the position of the indicator
                child: TriangleIndicator(
                  color: Colors.blue as Color, // <-- changing the color of the indicator
                ),
              ),
            ],
            items: [
              for (int i = 0; i < widget.categoryList[widget.categoryIndex].split(',').length; i++)
                if (i != 0)
                  FortuneItem(
                    child: Text(
                      widget.categoryList[widget.categoryIndex].split(',')[i],
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                    style: FortuneItemStyle(
                      color: Colors.white,
                      borderColor: Colors.black,
                      borderWidth: 1, // <-- custom circle slice stroke width
                    ),
                  )
            ],
          ),
        ),
      );
    }
    else if (widget.categoryIndex == (widget.categoryList.length - 1)) {
      userInput.clear();
      for (String input in textEditingController.text.split(',')) {
        userInput.add(input);
      }
      while (userInput.length < 2) {
        userInput.add("");
      }
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
          child: FortuneWheel(
            animateFirst: false,
            selected: controller.stream,
            indicators: <FortuneIndicator>[
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: TriangleIndicator(
                  color: Colors.blue as Color,
                ),
              ),
            ],
            items: [
              for (int i = 0; i < userInput.length; i++)
                FortuneItem(
                  child: Text(
                    userInput[i],
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                  style: FortuneItemStyle(
                    color: Colors.white,
                    borderColor: Colors.black,
                    borderWidth: 1, // <-- custom circle slice stroke width
                  ),
                )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildTextInput() {
    if (widget.categoryIndex == (widget.categoryList.length - 1)) {
      return Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            child: TextFormField(
              controller: textEditingController,
              textInputAction: TextInputAction.done,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              decoration:
              InputDecoration(
                hintText: "Enter inputs here, separated by commas.",
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(5.0),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    textEditingController.addListener(() {
      setState((){});
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.removeListener((){});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 80.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildNavigation(),
              buildFortuneWheel(),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Center(
                  child: AnimatedOpacity(
                      opacity: selectedTextOpacity,
                      duration: Duration(milliseconds: 250),
                      child: Column(
                        children: [
                          if (widget.categoryIndex == (widget.categoryList.length - 1))
                            Column(
                              children: [
                                Text(
                                    "You got",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    )
                                ),
                                Text(
                                    userInput[itemIndex],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    )
                                )
                              ],
                            )
                          else
                            Column(
                              children: [
                                Text(
                                    "You got",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    )
                                ),
                                Text(
                                    widget.categoryList[widget.categoryIndex].split(',')[itemIndex + 1],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    )
                                )
                              ],
                            )
                        ],
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: buildTextInput(),
              ),
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (widget.categoryIndex == (widget.categoryList.length - 1)) {
                        itemIndex = Fortune.randomInt(0, userInput.length);
                        controller.add(itemIndex);
                      } else {
                        itemIndex = Fortune.randomInt(0, widget.categoryList[widget.categoryIndex].split(',').length - 1);
                        controller.add(itemIndex);
                      }

                      // DISPLAY
                      Future.delayed(const Duration(milliseconds: 4500), () {
                        setState(() {
                          selectedTextOpacity = 1.0;
                          Future.delayed(const Duration(milliseconds: 2000), () {
                            setState(() {
                              selectedTextOpacity = 0.0;
                            });
                          });
                        });
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(15.0))
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "SPIN",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}