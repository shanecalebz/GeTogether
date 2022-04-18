import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:getogether/Randomizer/suggestions.dart';
import 'package:confetti/confetti.dart';
import '../utils/constants.dart';

class Wheel extends StatefulWidget {
  int selectionIndex;
  int categoryIndex;
  List<String> categoryList;

  Wheel(
      {required this.selectionIndex,
      required this.categoryIndex,
      required this.categoryList});

  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  TextEditingController textEditingController = new TextEditingController();
  StreamController<int> controller = StreamController<int>();
  List<String> userInput = [];
  bool showTextInput = true;
  double selectedTextOpacity = 0.0;
  double fortuneWheelOpacity = 1.0;
  late int count;
  var itemIndex = 0;

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
                  color: Colors.orange
                      as Color, // <-- changing the color of the indicator
                ),
              ),
            ],
            items: [
              for (int i = 0;
                  i <
                      widget.categoryList[widget.categoryIndex]
                          .split(',')
                          .length;
                  i++)
                if (i != 0)
                  FortuneItem(
                    child: Text(
                      widget.categoryList[widget.categoryIndex].split(',')[i],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: FortuneItemStyle(
                      color: ((i % 2) == 0) ? Colors.grey[800] as Color : Colors.grey[600] as Color,
                      borderColor: Colors.black,
                      borderWidth: 0,
                    ),
                  )
            ],
          ),
        ),
      );
    } else if (widget.categoryIndex == (widget.categoryList.length - 1)) {
      userInput.clear();
      for (String input in textEditingController.text.split('/')) {
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
                  color: Colors.orange as Color,
                ),
              ),
            ],
            items: [
              for (int i = 0; i < userInput.length; i++)
                FortuneItem(
                  child: Text(
                    userInput[i],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.0,
                      fontFamily: 'JosefinSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FortuneItemStyle(
                    color: ((i % 2) == 0) ? Colors.grey[800] as Color : Colors.grey[600] as Color,
                    borderColor: Colors.black,
                    borderWidth: 0,
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
    if (widget.categoryIndex == (widget.categoryList.length - 1) && showTextInput == true) {
      return Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
            padding: EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            child: TextFormField(
              controller: textEditingController,
              textInputAction: TextInputAction.done,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'JosefinSans',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Enter inputs here, separated by commas.",
                hintStyle: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'JosefinSans',
                  fontWeight: FontWeight.bold,
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
      setState(() {});
    });
    _controllerCenterRight = ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenterLeft = ConfettiController(duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.removeListener(() {});
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    super.dispose();
  }

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
                      widget.categoryList[widget.categoryIndex].split(',')[0],
                  )
              ),
              widget.categoryIndex == (widget.categoryList.length - 1) ? Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (_) => Suggestions(
                                  selectionIndex: widget.selectionIndex)))
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            if (textEditingController.text.isEmpty) {
                              textEditingController.text = value;
                            } else if (textEditingController.text.substring(
                                textEditingController.text.length - 1) ==
                                ",") {
                              textEditingController.text =
                                  textEditingController.text + value;
                            } else {
                              textEditingController.text =
                                  textEditingController.text + "," + value;
                            }
                          });
                        }
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      child: Icon(
                        Icons.lightbulb,
                        color: Colors.white,
                        size: 23.5,
                      ),
                    ),
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      body: Padding(
      padding: EdgeInsets.only(top: 80.0, bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ConfettiWidget(
                  confettiController: _controllerCenterLeft,
                  blastDirection: 0, // radial value - RIGHT
                  emissionFrequency: 0.6,
                  minimumSize: const Size(10, 10), // set the minimum potential size for the confetti (width, height)
                  maximumSize: const Size(30, 30), // set the maximum potential size for the confetti (width, height)
                  numberOfParticles: 3,
                  gravity: 0.6,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ConfettiWidget(
                    confettiController: _controllerCenterRight,
                    blastDirection: -3.142, // radial value - RIGHT
                    emissionFrequency: 0.6,
                    minimumSize: const Size(10, 10), // set the minimum potential size for the confetti (width, height)
                    maximumSize: const Size(30, 30), // set the maximum potential size for the confetti (width, height)
                    numberOfParticles: 3,
                    gravity: 0.6,
                  ),
                ),
                AnimatedOpacity(
                    opacity: fortuneWheelOpacity,
                    duration: Duration(milliseconds: 250),
                    child: Column(
                      children: [
                        buildFortuneWheel(),
                      ],
                    )
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                            opacity: selectedTextOpacity,
                            duration: Duration(milliseconds: 250),
                            child: Column(
                              children: [
                                if (widget.categoryIndex == (widget.categoryList.length - 1))
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Text("You got",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'JosefinSans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              )),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                child: Text(userInput[itemIndex],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      decoration: TextDecoration.underline,
                                                      color: Colors.black,
                                                      fontSize: 40.0,
                                                      fontFamily: 'JosefinSans',
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                else
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Text("You got",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'JosefinSans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              )),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                child: Text(
                                                    widget.categoryList[widget.categoryIndex]
                                                        .split(',')[itemIndex + 1],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      decoration: TextDecoration.underline,
                                                      color: Colors.black,
                                                      fontSize: 40.0,
                                                      fontFamily: 'JosefinSans',
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
                  if (fortuneWheelOpacity == 1.0) {
                    setState(() {
                      showTextInput = false;
                    });
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
                        fortuneWheelOpacity = 0.0;
                        selectedTextOpacity = 1.0;
                        _controllerCenterLeft.play();
                        _controllerCenterRight.play();
                      });
                    });
                  } else {
                    setState(() {
                      fortuneWheelOpacity = 1.0;
                      selectedTextOpacity = 0.0;
                      showTextInput = true;
                    });
                  }
                },
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      fortuneWheelOpacity == 1.0 ? "SPIN" : "CLOSE",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.bold,
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
    ));
  }
}