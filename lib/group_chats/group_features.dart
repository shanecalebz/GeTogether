import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getogether/group_chats/group_chat_screen.dart';
import 'package:getogether/qrscanner/qr_scanner.dart';
import '../Randomizer/randomizer_home.dart';
import 'create_group/add_members.dart';
import 'group_beforechat.dart';

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
          automaticallyImplyLeading: false,
        ),
        body: Container(
            height: size.height,
            width: size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 100,
                      width: 350,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GroupBeforeChatScreen(),
                          ),
                        ),
                        child: Text('Group Chat'),
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize:35),
                            primary: Colors.white,
                            backgroundColor: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 100,
                      width: 350,
                      child: TextButton(
                        onPressed: () {
                          print('you clicked me');
                        },
                        child: Text('Finance'),
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 35),
                            primary: Colors.white,
                            backgroundColor: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 100,
                      width: 350,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RandomizerHome()),
                        ),
                        child: Text('Randomizer'),
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 35),
                            primary: Colors.white,
                            backgroundColor: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 100,
                      width: 350,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => AddMembersInGroup()),
                        ),
                        child: Text('Create Group'),
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 35),
                            primary: Colors.white,
                            backgroundColor: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 100,
                      width: 350,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => QRScanner()),
                        ),
                        child: Text('QR + Calculator'),
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 35),
                            primary: Colors.white,
                            backgroundColor: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
