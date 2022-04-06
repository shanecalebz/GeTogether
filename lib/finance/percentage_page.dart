import 'package:flutter/material.dart';
import 'custom_input_page.dart';
import 'user_data.dart';
import 'widgets.dart';
import 'reusable_card.dart';
import 'custom_page.dart';

class PercentageInput extends StatefulWidget {
  static String id = 'percentage_page';

  @override
  State<PercentageInput> createState() => _PercentageInputState();
}

class _PercentageInputState extends State<PercentageInput> {
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

  @override
  void initState() {
    super.initState();
    _billAmountController.addListener(_onBillAmountChanged);
    _numberOfPeopleController.addListener(_onNumberOfPeopleChanged);
  }

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
        title: Text('Percentage Input'),
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
                      itemCount: userData.length,
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
                                                  userIcon(userData[index]),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  userName(userData[index]),
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
                                                          'Amount Payable: ${_getFinalAmount()}',
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
        onPressed: () {},
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
