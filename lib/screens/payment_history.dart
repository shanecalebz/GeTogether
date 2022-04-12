import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  int index = 0;
  int sortIndex = 0;
  List<String> userList = [];
  List<String> eventTime = [];
  List<String> sortedUserList = [];
  late bool currentUserIsOwner;
  late bool currentUserInGroup;
  String ownerName = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void getNotifications() {
    userList.clear();
    eventTime.clear();
    index = 0;
    sortIndex = 0;
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
        // CHECK IF CURRENT USER IS THE OWNER
        currentUserIsOwner = false;
        for (String users in element.data()['test'].split(';')) {
          if (_auth.currentUser?.uid == users.split(',')[0] && users.split(',')[4] == "yes") {
            currentUserIsOwner = true;
          }

          // GET OWNER NAME
          if (users.split(',')[4] == "yes") {
            ownerName = users.split(',')[1];
          }
        }

        if (currentUserIsOwner == true) {
          for (String users in element.data()['test'].split(';')) {
            if (users.split(',')[4] == "no" && users.split(',')[3] == "yes") {
              // SETTLED
              setState(() {
                if (users.split(',')[3] == "yes") {
                  eventTime.add(users.split(',')[7] + "," + sortIndex.toString());
                } else {
                  eventTime.add(element.data()['eventTime'] + "," + sortIndex.toString());
                }
                userList.add(index.toString() + "," + users + ",,1");
                sortIndex++;
              });
            }
          }
        } else {
          for (String users in element.data()['test'].split(';')) {
            if (_auth.currentUser?.uid == users.split(',')[0] && users.split(',')[3] == "yes") {
              // CURRENT USER HAS SETTLED HIS BILL
              setState(() {
                if (users.split(',')[3] == "yes") {
                  eventTime.add(users.split(',')[7] + "," + sortIndex.toString());
                } else {
                  eventTime.add(element.data()['eventTime'] + "," + sortIndex.toString());
                }
                userList.add(index.toString() + "," + users + "," + ownerName + ",0");
                sortIndex++;
              });
            }
          }
        }
        index++;
      }

      sortedUserList.clear();
      eventTime.sort((a,b) => b.compareTo(a));
      for (int i = 0; i < eventTime.length; i++) {
        sortedUserList.add(userList[int.parse(eventTime[i].split(',')[1])]);
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

  Widget buildWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Column(
              children: [
                for (int i = 0; i < sortedUserList.length; i++)
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
                                sortedUserList[i].split(',')[10] == "0" ?
                                Text(
                                  sortedUserList[i].split(',')[9],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ) :
                                Text(
                                  sortedUserList[i].split(',')[2],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(DateFormat('dd MMM yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(sortedUserList[i].split(',')[8].toString())))),
                              ],
                            ),
                            Text(
                              sortedUserList[i].split(',')[10] == "0" ? "- \$" + sortedUserList[i].split(',')[3] : "+ \$" + sortedUserList[i].split(',')[3],
                              style: TextStyle(
                                color: sortedUserList[i].split(',')[10] == "0" ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            )
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0XFFFEA828),
        title: Stack(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                size: 23.5,
                color: Colors.white,
              ),
            ),
            Center(
                child: Text(
                    "Payment History"
                )
            ),
          ],
        ),
      ),
      body: buildWidget(),
    );
  }
}
