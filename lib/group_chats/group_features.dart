import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getogether/group_chats/group_chat_screen.dart';
import 'package:getogether/qrscanner/qr_scanner.dart';
import '../Randomizer/randomizer_home.dart';
import '../finance/finance_features.dart';
import '../qrscanner/calculate_total_price.dart';
import '../utils/constants.dart';
import 'create_group/add_members.dart';
import 'group_beforechat.dart';
import 'group_beforefinance.dart';

class GroupFeatureScreen extends StatefulWidget {
  const GroupFeatureScreen({Key? key}) : super(key: key);

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
                    builder: (_) => GroupBeforeChatScreen(),
                  ),
                ),
              child: Text('Group Chat'),
              style: TextButton.styleFrom(
                  textStyle: TextStyle(fontSize: 50, fontFamily: 'JosefinSans'),
                  primary: Colors.white,
                  backgroundColor: Colors.deepPurple),
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
                    builder: (_) => GroupBeforeFinanceScreen(),
                  ),
                ),
                child: Text('Finance'),
                style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: 50,fontFamily: 'JosefinSans'),
                    primary: Colors.white,
                    backgroundColor: Colors.deepPurple),
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
                          MaterialPageRoute(builder: (_) => RandomizerHome()),),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            CalculateTotalPrice(menu: result)));
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
