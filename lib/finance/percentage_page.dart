import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'custom_input_page.dart';
import 'user_data.dart';
import 'widgets.dart';
import 'reusable_card.dart';
import 'custom_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PercentageInput extends StatefulWidget {
  static String id = 'percentage_page';
  final String groupChatId, groupName;
  final Function goToNotifications;
  const PercentageInput(
      {required this.groupChatId,
      required this.groupName,
      required this.goToNotifications,
      Key? key})
      : super(key: key);

  @override
  State<PercentageInput> createState() => _PercentageInputState();
}

class _PercentageInputState extends State<PercentageInput> {
  List membersList = [];
  List membersListFinal = [];
  bool isLoading = true;
  late Timer timer;
  bool snackBarShown = false;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    getGroupDetails();
    _billAmountController.addListener(_onBillAmountChanged);
    _numberOfPeopleController.addListener(_onNumberOfPeopleChanged);
  }

  Future getGroupDetails() async {
    await _firestore.collection('groups').doc(widget.groupChatId).get().then((chatMap) {
      membersList = chatMap['members'];

      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] != _auth.currentUser!.uid) {
          membersListFinal.add(membersList[i]);
          TextEditingController controller = TextEditingController();
          percControllers.add(controller);
        }
      }

      for (int i = 0; i < percControllers.length; i++) {
        percControllers[i].text = "0";
        percControllers[i].addListener(() {
          checkPercentage();
        });
      }

      isLoading = false;
      setState(() {});
    });
  }

  bool percentageValidated = false;
  double totalPercentage = 0;

  void checkPercentage() {
    totalPercentage = 0;
    for (int i = 0; i < percControllers.length; i++) {
      totalPercentage += double.parse(percControllers[i].text);
    }

    // ENSURE USER INPUT DOES NOT EXCEED 100%
    for (int i = 0; i < percControllers.length; i++) {
      if (double.parse(percControllers[i].text) > 100.00) {
        if (snackBarShown == false) {
          // SHOW SNACKBAR
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.warning,
                    size: 14.0,
                    color: Colors.white,
                  ),
                ),
                Text("Invalid Percentage",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ));
          snackBarShown = true;
          timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer timer) {
            snackBarShown = false;
            timer.cancel();
          });
        }
      }
    }

    // VALIDATE TOTAL PERCENTAGE
    percentageValidated = false;
    if (totalPercentage == 100.00 &&
        double.parse(double.parse(_billAmountController.text).toStringAsFixed(2)) > 0) {
      percentageValidated = true;
    }

    setState(() {});
  }

  List<TextEditingController> percControllers = [];
  var userData = UserData.getData;

  // This is the default bill amount
  static const defaultBillAmount = 0.0;

  // This is the default percentage
  static const defaultNumberOfPeople = 1;

  // This is the TextEditingController which is used to keep track of the change in bill amount
  final _billAmountController = TextEditingController(text: defaultBillAmount.toStringAsFixed(2));

  // This is the TextEditingController which is used to keep track of the change in tip percentage
  final _numberOfPeopleController = TextEditingController(text: defaultNumberOfPeople.toString());

  // This stores the latest value of bill amount calculated
  double _billAmount = defaultBillAmount;

  // This stores the latest value of tip percentage calculated
  int _numberOfPeople = defaultNumberOfPeople;

  _getFinalAmount() => _billAmount / userData.length;

  _onBillAmountChanged() {
    setState(() {
      _billAmount = double.tryParse(_billAmountController.text) ?? 0.0;
    });

    // VALIDATE TOTAL PERCENTAGE
    percentageValidated = false;
    if (totalPercentage == 100.00 &&
        double.parse(double.parse(_billAmountController.text).toStringAsFixed(2)) > 0) {
      percentageValidated = true;
    }
  }

  _onNumberOfPeopleChanged() {
    setState(() {
      _numberOfPeople = int.tryParse(_numberOfPeopleController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.primaryColor,
        title: Text('Percentage Input (${widget.groupName})'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          TextFormField(
            key: Key("billAmount"),
            controller: _billAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'Enter the Bill Amount',
              labelText: 'Bill Amount',
              labelStyle: TextStyle(
                fontSize: 25.0,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
              ),
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
            ),
          ),
/*          TextField(
            onChanged: (value) {
              // Do something here with the user input
            },
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: kTextFieldDecoration.copyWith(hintText: "Enter amount"),
          ),*/
          SizedBox(
            height: 20,
          ),
          /*TextFormField(
            key: Key("numberOfPeople"),
            controller: _numberOfPeopleController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter the number of people splitting',
              labelText: 'Number Of People',
              labelStyle: TextStyle(
                fontSize: 25.0,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
              ),
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),*/
          /*Row(
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                  onPress: () {},
                  colour: Colors.blueAccent,
                  cardChild: Text(
                    'Equally',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    Navigator.pushNamed(context, CustomInput.id);
                  },
                  colour: Colors.blueAccent,
                  cardChild: Text(
                    'Custom',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    Navigator.pushNamed(context, PercentageInput.id);
                  },
                  colour: Colors.blueAccent,
                  cardChild: Text(
                    'By %',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),*/
          SizedBox(
            height: 20.0,
          ),
          Container(
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: membersListFinal.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: (index == membersListFinal.length - 1)
                              ? const EdgeInsets.only(bottom: 80.0)
                              : const EdgeInsets.only(bottom: 0.0),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            height: 135,
                            width: double.maxFinite,
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              top: 5,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(membersListFinal[index]['name']),
                                                    Spacer(),
                                                    SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        keyboardType: TextInputType.number,
                                                        controller: percControllers[index],
                                                      ),
                                                    ),
                                                    Text(" %"),
                                                    Spacer(),
                                                    Container(
                                                      margin: EdgeInsets.all(15),
                                                      padding: EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                        border: Border.all(color: Colors.white),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          calculateFinalAmount(index),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: percentageValidated ? Color(0XFFFEA828) : Colors.grey,
        label: Text("Submit"),
        onPressed: () {
          if (percentageValidated == true) {
            /*for (int i = 0; i < membersListFinal.length; i++) {
            print(
                "${membersListFinal[i]['name']} pays \$${_billAmount * (double.parse(percControllers[i].text)) / 100}.");
          }*/

            // CREATE STRING
            String temp = "";
            for (int i = 0; i < membersListFinal.length; i++) {
              if (double.parse((_billAmount * (double.parse(percControllers[i].text)) / 100)
                      .toStringAsFixed(2)) >
                  0.00) {
                temp += membersListFinal[i]['uid'] +
                    "," +
                    membersListFinal[i]['name'] +
                    "," +
                    (_billAmount * (double.parse(percControllers[i].text)) / 100)
                        .toStringAsFixed(2) +
                    ",no,no;";
              }
            }
            // OWNER ONLY
            for (int i = 0; i < membersList.length; i++) {
              if (membersList[i]['uid'] == _auth.currentUser!.uid) {
                temp += membersList[i]['uid'] + "," + membersList[i]['name'] + ",0.00,no,yes";
                break;
              }
            }
            // APPEND TO FIRESTORE
            _firestore
                .collection('notifications')
                .add({'test': temp, 'eventTime': DateTime.now().millisecondsSinceEpoch.toString()});
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            widget.goToNotifications();
          } else {
            // SHOW SNACKBAR
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  totalPercentage == 100.00
                      ? _billAmount < 0.00
                          ? "Amount cannot be negative!"
                          : "Invalid Bill Amount"
                      : "Percentage does not add up to 100%",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              duration: Duration(seconds: 3),
              backgroundColor: Color(0XFFFEA828),
            ));
          }
        },
        tooltip: "Create Group",
      ),
    );
  }

  Widget calculateFinalAmount(int index) {
    if (percControllers[index].text.isEmpty) {
      return AmountText(
        'Amount Payable: \$0',
        key: Key('finalAmount'),
      );
    } else {
      return AmountText(
        'Amount Payable: \$${(_billAmount * (double.parse(percControllers[index].text)) / 100).toStringAsFixed(2)}',
        key: Key('finalAmount'),
      );
    }
  }

  @override
  void dispose() {
    // To make sure we are not leaking anything, dispose any used TextEditingController
    // when this widget is cleared from the memory.
    _billAmountController.dispose();
    _numberOfPeopleController.dispose();
    for (int i = 0; i < percControllers.length; i++) {
      percControllers[i].dispose();
    }
    timer.cancel();
    super.dispose();
  }
}

class AmountText extends StatelessWidget {
  final String text;

  const AmountText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
          fontSize: 12,
        ),
      ),
    );
  }
}
