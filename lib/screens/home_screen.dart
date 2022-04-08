import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getogether/utils/constants.dart';
import 'package:getogether/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int count = 0;
  int index = 0;
  bool currentUserInGroup = false;
  List<String> userList = [];
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userList.clear();
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
            userList.add(index.toString() + "," + users + element.id);
          });
        }
        index++;
      }
      }));
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
        child: Text("No Outstanding")
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
                                    Text(userList[i].split(',')[2]),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Text("\$" + userList[j].split(',')[3]),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: Checkbox(
                                          value: false,
                                          onChanged: (value) {
                                            // UPDATE FIRESTORE


                                            // SHOW SNACKBAR
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text(
                                                "Item Deleted",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )
                                              ),
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Color(0XFFFEA828),
                                            ));
                                          }
                                      ),
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
        child: Text("NOBODY OWES U SHIT")
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
                                      Text(userList[i].split(',')[2]),
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
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
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

  SliverToBoxAdapter _buildHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Palette.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'UPCOMING EVENTS',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your upcoming plans:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}