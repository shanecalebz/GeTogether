import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getogether/group_chats/group_chat_screen.dart';
import '../Randomizer/randomizer_home.dart';
import 'package:getogether/group_chats/create_group/add_members.dart';
import 'package:getogether/group_chats/group_beforechat.dart';
import 'package:getogether/finance/equal_input.dart';
import 'package:getogether/finance/percentage_page.dart';
import 'package:getogether/finance/custom_page.dart';

import '../utils/constants.dart';

class FinanceFeatureScreen extends StatefulWidget {
  static String id = 'equal_page';
  final String groupChatId, groupName;
  final Function goToNotifications;
  const FinanceFeatureScreen(
      {required this.groupChatId,
      required this.groupName,
      required this.goToNotifications,
      Key? key})
      : super(key: key);

  @override
  _FinanceFeatureScreenState createState() => _FinanceFeatureScreenState();
}

class _FinanceFeatureScreenState extends State<FinanceFeatureScreen> {
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

    await _firestore.collection('users').doc(uid).collection('groups').get().then((value) {
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
          backgroundColor: Palette.primaryColor,
          title: Text(widget.groupName),
          //automaticallyImplyLeading: false,
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
                    height: 180.0,
                    width: 180.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EqualInput(
                                  groupChatId: widget.groupChatId,
                                  groupName: widget.groupName,
                                  goToNotifications: widget.goToNotifications,
                                ),
                              )
                          );
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
                                  Icons.safety_divider,
                                  size: 45.0,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Equal Input",
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Container(
                    height: 180.0,
                    width: 180.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CustomInput(
                                groupName: widget.groupName,
                                groupChatId: widget.groupChatId,
                                goToNotifications: widget.goToNotifications,
                              ),
                            ),
                          );
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
                                  Icons.edit,
                                  size: 45.0,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Custom Input",
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
                  height: 180.0,
                  width: 180.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => PercentageInput(
                                groupName: widget.groupName,
                                groupChatId: widget.groupChatId,
                                goToNotifications: widget.goToNotifications,
                              )),
                        );
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
                                Icons.percent_rounded,
                                size: 45.0,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              "Percentage Input",
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
