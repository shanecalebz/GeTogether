import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getogether/group_chats/group_chat_screen.dart';
import 'package:getogether/qrscanner/qr_scanner.dart';
import 'package:getogether/screens/history.dart';
import '../Randomizer/randomizer_home.dart';
import '../finance/finance_features.dart';
import '../qrscanner/calculate_total_price.dart';
import '../utils/constants.dart';
import 'create_group/add_members.dart';
import 'group_beforechat.dart';
import 'group_beforefinance.dart';

class GroupFeatureScreen extends StatefulWidget {
  final Function goToNotifications;
  GroupFeatureScreen({required this.goToNotifications});

  @override
  _GroupFeatureScreenState createState() => _GroupFeatureScreenState();
}

class _GroupFeatureScreenState extends State<GroupFeatureScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];
  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("GeTogether")),
        backgroundColor: Palette.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 60.0) / 2,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupBeforeChatScreen()));
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
                                Icons.chat_outlined,
                                size: 45.0,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              "Group Chat",
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
                Container(
                  width: (MediaQuery.of(context).size.width - 60.0) / 2,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => RandomizerHome()));
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
                              "Randomizer",
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 60.0) / 2,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupBeforeFinanceScreen(goToNotifications: widget.goToNotifications)));
                        },
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      size: 40.0,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Icon(
                                        Icons.attach_money,
                                        size: 40.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 36.0),
                                      child: Icon(
                                        Icons.attach_money,
                                        size: 40.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "Finance",
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
                  Container(
                    width: (MediaQuery.of(context).size.width - 60.0) / 2,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => QRScanner()));
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
                                  Icons.qr_code,
                                  size: 50.0,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "QR Scanner",
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 60.0) / 2,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddMembersInGroup()));
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
                                  Icons.add,
                                  size: 45.0,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Create Group",
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
                  Container(
                    width: (MediaQuery.of(context).size.width - 60.0) / 2,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => History()));
                        },
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.5),
                                child: Icon(
                                  Icons.list_alt,
                                  size: 45.0,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Payment History",
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
          ],
        )
      )
    );

    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("GeTogether")),
          backgroundColor: Palette.primaryColor,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: size.height,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 75,
                          width: 350,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => RandomizerHome()),
                            ),
                            child: Text('Randomizer'),
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                  fontSize: 50,
                                  fontFamily: 'JosefinSans',
                                  fontWeight: FontWeight.bold),
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Color(0xFFF5F6F9),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 75,
                          width: 350,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => AddMembersInGroup()),
                            ),
                            child: Text('Create Group'),
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                  fontSize: 50,
                                  fontFamily: 'JosefinSans',
                                  fontWeight: FontWeight.bold),
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Color(0xFFF5F6F9),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 75,
                          width: 350,
                          child: TextButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => QRScanner()));
                              if (result != null) {
                                final result2 = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            CalculateTotalPrice(menu: result)));
                                if (result2 != null) {
                                  widget.goToNotifications();
                                }
                              }
                            },
                            child: Text('QR + Calculator'),
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'JosefinSans',
                                  fontWeight: FontWeight.bold),
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Color(0xFFF5F6F9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
