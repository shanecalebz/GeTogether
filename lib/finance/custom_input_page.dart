import 'package:flutter/material.dart';
import 'package:getogether/finance/custom_page.dart';
import 'package:getogether/finance/percentage_page.dart';
import 'package:getogether/finance/reusable_card.dart';
import 'package:getogether/finance/constants.dart';
import 'user_data.dart';
import 'widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getogether/group_chats/group_info.dart';

class EqualInput extends StatefulWidget {
  static String id = 'equal_page';
  final String groupChatId, groupName;
  final Function goToNotifications;
  const EqualInput(
      {required this.groupChatId, required this.groupName, required this.goToNotifications, Key? key})
      : super(key: key);

  @override
  State<EqualInput> createState() => _EqualInputState();
}

class _EqualInputState extends State<EqualInput> {
  List membersList = [];
  List groupList = [];
  bool isLoading = true;
  bool billAmountValidated = false;

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
    await _firestore
        .collection('groups')
        .doc(widget.groupChatId)
        .get()
        .then((chatMap) {
      membersList = chatMap['members'];
      print(membersList);
      isLoading = false;
      setState(() {});
    });
  }

  final myController = TextEditingController();
  var userData = UserData.getData;

  // This is the default bill amount
  static const defaultBillAmount = 0.00;

  // This is the default tip percentage
  static const defaultNumberOfPeople = 1;

  // This is the TextEditingController which is used to keep track of the change in bill amount
  final _billAmountController =
      TextEditingController(text: defaultBillAmount.toStringAsFixed(2));

  // This is the TextEditingController which is used to keep track of the change in tip percentage
  final _numberOfPeopleController =
      TextEditingController(text: defaultNumberOfPeople.toString());

  // This stores the latest value of bill amount calculated
  double _billAmount = defaultBillAmount;

  // This stores the latest value of tip percentage calculated
  int _numberOfPeople = defaultNumberOfPeople;

  _getFinalAmount() => (_billAmount / membersList.length).toStringAsFixed(2);

  _onBillAmountChanged() {
    setState(() {

      // VALIDATE THE AMOUNT
      billAmountValidated = false;
      if (_billAmountController.text.isNotEmpty) {
        if (double.parse(_billAmountController.text) > 0.00) {
          billAmountValidated = true;
        }
      }

      _billAmount = double.tryParse(_billAmountController.text) ?? 0.0;
    });
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
        title: Text('Equal Input (${widget.groupName})'),
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
          Row(
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
                    Navigator.pushNamed(context, EqualInput.id);
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
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      itemCount: membersList.length,
                      itemBuilder: (context, index) {
                        return Container(
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
                                                  //userIcon(userData[index]),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(membersList[index]
                                                      ['name']),
                                                  Spacer(),
                                                  Container(
                                                    margin: EdgeInsets.all(15),
                                                    padding: EdgeInsets.all(15),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.white),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        AmountText(
                                                          'Amount Payable: \$ ${_getFinalAmount()}',
                                                          key: Key(
                                                              'finalAmount'),
                                                        )
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: billAmountValidated ? Color(0XFFFEA828) : Colors.grey,
        label: Text("Submit"),
        onPressed: () {// CREATE STRING
          String temp = "";
          if (_billAmount == 0 || _billAmount < 0) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Invalid Bill Amount",
                  style: TextStyle(
                    color: Colors.white,
                  )
              ),
              duration: Duration(seconds: 3),
              backgroundColor: Color(0XFFFEA828),
            )
            );
          }
        else {
            for (int i = 0; i < membersList.length; i++) {
              if (_auth.currentUser?.uid == membersList[i]['uid']) {
                temp +=
                    membersList[i]['uid'] + "," + membersList[i]['name'] + "," +
                        (_billAmount / membersList.length).toStringAsFixed(2) +
                        ",no,yes";
              } else {
                temp +=
                    membersList[i]['uid'] + "," + membersList[i]['name'] + "," +
                        (_billAmount / membersList.length).toStringAsFixed(2) +
                        ",no,no";
              }
              if (i != (membersList.length - 1)) {
                temp += ";";
              }
            }
            // APPEND TO FIRESTORE
            _firestore.collection('notifications').add(
                {'test': temp, 'eventTime': DateTime
                    .now()
                    .millisecondsSinceEpoch
                    .toString()});
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            widget.goToNotifications();
          }
        },
        tooltip: "Submit",
      ),
    );
  }

  @override
  void dispose() {
    // To make sure we are not leaking anything, dispose any used TextEditingController
    // when this widget is cleared from the memory.
    _billAmountController.dispose();
    _numberOfPeopleController.dispose();
    myController.dispose();
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
