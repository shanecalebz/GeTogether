import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getogether/group_chats/group_chat_screen.dart';
import '../Randomizer/randomizer_home.dart';
import 'package:getogether/group_chats/create_group/add_members.dart';
import 'package:getogether/group_chats/group_beforechat.dart';
import 'package:getogether/finance/custom_input_page.dart';
import 'package:getogether/finance/percentage_page.dart';
import 'package:getogether/finance/custom_page.dart';

class FinanceFeatureScreen extends StatefulWidget {
  static String id = 'equal_page';
  final String groupChatId, groupName;
  const FinanceFeatureScreen(
      {required this.groupChatId, required this.groupName, Key? key})
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
          title: Text(widget.groupName),
          automaticallyImplyLeading: false,
        ),
        body: Container(
            height: size.height,
            width: size.width,
            color: Colors.white,
            child: Column(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EqualInput(
                        groupChatId: widget.groupChatId,
                        groupName: widget.groupName,
                      ),
                    ),
                  ),
                  child: Text('Equal Input'),
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 68),
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlueAccent),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CustomInput(
                        groupName: widget.groupName,
                        groupChatId: widget.groupChatId,
                      ),
                    ),
                  ),
                  child: Text('Custom Input'),
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 68),
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlueAccent),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => PercentageInput(
                              groupName: widget.groupName,
                              groupChatId: widget.groupChatId,
                            )),
                  ),
                  child: Text('Percentage Input'),
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 68),
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlueAccent),
                ),
              ],
            )));
  }
}
