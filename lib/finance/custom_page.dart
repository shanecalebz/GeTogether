import 'package:flutter/material.dart';
import 'package:getogether/finance/custom_input_page.dart';
import 'widgets.dart';
import 'reusable_card.dart';
import 'user_data.dart';
import 'percentage_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomInput extends StatefulWidget {
  final String groupChatId, groupName;
  final Function goToNotifications;
  const CustomInput(
      {required this.groupChatId,
      required this.groupName,
      required this.goToNotifications,
      Key? key})
      : super(key: key);
  static String id = 'custom_page';

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  List membersList = [];
  List membersListFinal = [];
  bool isLoading = true;

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

      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] != _auth.currentUser!.uid) {
          membersListFinal.add(membersList[i]);
          TextEditingController controller = TextEditingController();
          myControllers.add(controller);
        }
      }
      for (int i = 0; i < myControllers.length; i++) {
        myControllers[i].addListener(() {calculateTotal();});
      }

      isLoading = false;
      setState(() {});
    });
  }

  double totalPrice = 0;

  void calculateTotal() {
    totalPrice = 0;
    for (int i = 0; i < myControllers.length; i++) {
      setState(() {
        totalPrice += double.parse(myControllers[i].text);
      });
    }
  }


  List<TextEditingController> myControllers = [];
  var userData = UserData.getData;

  // This is the default bill amount
  static const defaultBillAmount = 0.0;

  // This is the default tip percentage
  static const defaultNumberOfPeople = 1;

  // This is the TextEditingController which is used to keep track of the change in bill amount
  final _billAmountController =
      TextEditingController(text: defaultBillAmount.toString());

  // This is the TextEditingController which is used to keep track of the change in tip percentage
  final _numberOfPeopleController =
      TextEditingController(text: defaultNumberOfPeople.toString());

  // This stores the latest value of bill amount calculated
  double _billAmount = defaultBillAmount;

  // This stores the latest value of tip percentage calculated
  int _numberOfPeople = defaultNumberOfPeople;

  _getFinalAmount() => _billAmount / userData.length;

  _onBillAmountChanged() {
    setState(() {
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
        title: Text('Custom Input (${widget.groupName})'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bill Amount",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("\$" + totalPrice.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              )
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
      /*
          Row(
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    Navigator.pushNamed(context, EqualInput.id);
                  },
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
          ),
          */
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
                          padding: (index == (membersListFinal.length - 1)) ? const EdgeInsets.only(bottom: 80.0) : const EdgeInsets.all(0.0),
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
                                                    Text(membersListFinal[index]
                                                        ['name']),
                                                    Spacer(),
                                                    Text('\$ '),
                                                    SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: TextField(
                                                        keyboardType: TextInputType.number,
                                                        controller:
                                                            myControllers[index],
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
        backgroundColor: Colors.blueAccent,
        label: Text("Submit"),
        onPressed: () {
          /*for (int i = 0; i < membersListFinal.length; i++) {
            print(
                "${membersListFinal[i]['name']} pays \$${(double.parse(myControllers[i].text)).toStringAsFixed(2)}.");
          }*/

          // CREATE STRING
          String temp = "";
          for (int i = 0; i < membersListFinal.length; i++) {
            temp += membersListFinal[i]['uid'] + "," + membersListFinal[i]['name'] + "," +
                (double.parse(myControllers[i].text)).toStringAsFixed(2) + ",no,no;";
          }
          // OWNER ONLY
          for (int i = 0; i < membersList.length; i++) {
            if (membersList[i]['uid'] == _auth.currentUser!.uid) {
              temp += membersList[i]['uid'] + "," + membersList[i]['name'] + ",0.00,no,yes";
              break;
            }
          }

          // APPEND TO FIRESTORE
          _firestore.collection('notifications').add({
            'test': temp,
            'eventTime': DateTime.now().millisecondsSinceEpoch.toString()
          });
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          widget.goToNotifications();
        },
        tooltip: "Create Group",
      ),
    );
  }

  @override
  void dispose() {
    // To make sure we are not leaking anything, dispose any used TextEditingController
    // when this widget is cleared from the memory.
    _billAmountController.dispose();
    _numberOfPeopleController.dispose();
    for (int i = 0; i < myControllers.length; i++) {
      myControllers[i].dispose();
    }
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
