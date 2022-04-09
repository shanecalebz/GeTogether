import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int count = 0;
  int index = 0;
  late int checkBoxValueIndex;
  late bool onlyOwner;
  late Timer timer;
  bool currentUserInGroup = false;
  List<String> userList = [];
  List<String> checkBoxValue = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer timer) {
      setState(() {
        getNotifications();
      });
      timer.cancel();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  void getNotifications() {
    userList.clear();
    checkBoxValue.clear();
    index = 0;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore.collection('notifications').get().then((value) => value.docs.forEach((element) {
      // CHECK IF CURRENT USER EXISTS IN NOTIFICATION
      currentUserInGroup = false;
      for (String users in element.data()['test'].split(';')) {
        // CHECK IF CURRENT USER IS IN THE GROUP
        if (_auth.currentUser?.uid == users.split(',')[0]) {
          currentUserInGroup = true;
        }
      }

      if (currentUserInGroup == true) {
        for (String users in element.data()['test'].split(';')) {
          setState(() {
            userList.add(index.toString() + "," + users + "," + element.id + "," + element.data()['eventTime']);
            if (_auth.currentUser!.uid == userList.last.split(',')[1] && userList.last.split(',')[5] == "no" && userList.last.split(',')[4] == "no") {
              checkBoxValue.add((userList.length - 1).toString() + ",false");
            }
          });
        }
        index++;
      }
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getNotifications();
    });
  }

  Widget buildCheckbox(int j) {

    checkBoxValueIndex = -1;
    for (int i = 0; i < checkBoxValue.length; i++) {
     if (checkBoxValue[i].split(',')[0] == j.toString()) {
       checkBoxValueIndex = i;
     }
    }

    if (checkBoxValueIndex != -1) {
      return Checkbox(
          value: checkBoxValue[checkBoxValueIndex].split(',')[1].toString() == "true",
          onChanged: (value) async {
            // UPDATE FIRESTORE
            String temp = "";
            for (int z = 0; z < userList.length; z++) {
              if (userList[z].split(',')[0] == userList[j].split(',')[0]) {
                if (_auth.currentUser!.uid != userList[z].split(',')[1]) {
                  temp += userList[z].split(',')[1] + "," + userList[z].split(',')[2] + "," + userList[z].split(',')[3] + "," +
                      userList[z].split(',')[4] + "," + userList[z].split(',')[5] + ";";
                }
              }
            }
            temp = temp.substring(0, temp.length - 1);

            // CHECK IF OWNER ONLY
            onlyOwner = true;
            for (String user in temp.split(';')) {
              if (user.split(',')[4] == "no") {
                onlyOwner = false;
              }
            }

            if (onlyOwner == true) {
              // DELETE DOCUMENT
              await _firestore.collection('notifications').doc(userList[j].split(',')[6]).delete();
            } else {
              // UPDATE DOCUMENT
              await _firestore.collection('notifications').doc(userList[j].split(',')[6]).update({'test': temp});
            }

            // SHOW SNACKBAR
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Settled",
                  style: TextStyle(
                    color: Colors.white,
                  )
              ),
              duration: Duration(seconds: 3),
              backgroundColor: Color(0XFFFEA828),
            ));

            // SET CHECKBOX VALUE TO TRUE
            setState(() {
              for (int i = 0; i < checkBoxValue.length; i++) {
                if (checkBoxValue[i].split(',')[0] == j.toString()) {
                  checkBoxValue[i] = checkBoxValue[i].split(',')[0] + ",true";
                }
              }
            });

            // START TIMER
            startTimer();
          }
      );
    } else {
      return Container();
    }
  }

  Widget buildYouOwe() {

    count = 0;
    for (int j = 0; j < userList.length; j++) {
      if (_auth.currentUser!.uid == userList[j].split(',')[1] && userList[j].split(',')[5] == "no" && userList[j].split(',')[4] == "no") {
        for (int i = 0; i < userList.length; i++) {
          if (userList[i].split(',')[0] == userList[j].split(',')[0] && userList[i].split(',')[5] == "yes") {
            count++;
          }
        }
      }
    }

    if (count == 0) {
      return const Center(
        child: Text("Bills Settled")
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: 8.0,
              ),
              for (int j = 0; j < userList.length; j++)
                if (_auth.currentUser!.uid == userList[j].split(',')[1] && userList[j].split(',')[5] == "no" && userList[j].split(',')[4] == "no")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (int i = 0; i < userList.length; i++)
                                  if (userList[i].split(',')[0] == userList[j].split(',')[0] && userList[i].split(',')[5] == "yes")
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userList[i].split(',')[2],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(DateFormat('dd MMM yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(userList[i].split(',')[7].toString())))),
                                      ],
                                    ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Text("\$" + userList[j].split(',')[3]),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: buildCheckbox(j),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
            ],
          ),
        ),
      );
    }
  }

  Widget buildTheyOwe() {

    count = 0;
    for (int j = 0; j < userList.length; j++) {
      if (_auth.currentUser!.uid == userList[j].split(',')[1] && userList[j].split(',')[5] == "yes" && userList[j].split(',')[4] == "no") {
        for (int i = 0; i < userList.length; i++) {
          if (userList[i].split(',')[0] == userList[j].split(',')[0] && userList[i].split(',')[5] == "no") {
            count++;
          }
        }
      }
    }

    if (count == 0) {
      return const Center(
        child: Text("Bills Settled")
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              for (int j = 0; j < userList.length; j++)
                if (_auth.currentUser!.uid == userList[j].split(',')[1] && userList[j].split(',')[5] == "yes" && userList[j].split(',')[4] == "no")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < userList.length; i++)
                        if (userList[i].split(',')[0] == userList[j].split(',')[0] && userList[i].split(',')[5] == "no")
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userList[i].split(',')[2],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(DateFormat('dd MMM yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(userList[i].split(',')[7].toString())))),
                                        ],
                                      ),
                                      Text("\$" + userList[j].split(',')[3]),
                                    ],
                                  ),
                                )
                            ),
                          ),
                    ],
                  )
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFFFEA828),
          bottom: TabBar(
            tabs: [
              Tab(text: "You Owe"),
              Tab(text: "They Owe"),
            ]
          ),
          title: Text("GeTogether"),
        ),
        body: TabBarView(
          children: [
            buildYouOwe(),
            buildTheyOwe(),
          ],
        )
      ),
    );
  }
}