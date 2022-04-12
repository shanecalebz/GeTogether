import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getogether/finance/equal_input.dart';
import '../utils/constants.dart';
import 'group_chat_room.dart';
import 'package:getogether/finance/finance_features.dart';

class GroupBeforeFinanceScreen extends StatefulWidget {
  final Function goToNotifications;
  GroupBeforeFinanceScreen({required this.goToNotifications});

  @override
  _GroupBeforeFinanceScreenState createState() =>
      _GroupBeforeFinanceScreenState();
}

class _GroupBeforeFinanceScreenState extends State<GroupBeforeFinanceScreen> {
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
        backgroundColor: Palette.primaryColor,
        title: Text("Select Group"),
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => FinanceFeatureScreen(
                              groupName: groupList[index]['name'],
                              groupChatId: groupList[index]['id'],
                              goToNotifications: widget.goToNotifications,
                            )),
                  ),
                  leading: Icon(Icons.group),
                  title: Text(groupList[index]['name']),
                );
              },
            ),
    );
  }
}
