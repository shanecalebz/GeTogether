import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getogether/utils/profile_pic.dart';
import '../utils/constants.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final TextEditingController _username = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  String currentUserName = "";
  String currentUserBio = "";
  late String groupID;
  late String notificationID;
  late bool userExistsInGroup;

  void getUserInfo() async {
    await _firestore
        .collection('users')
        .where("email", isEqualTo: _auth.currentUser!.email)
        .get()
        .then((value) {
      setState(() {
        currentUserName = value.docs[0].data()['name'];
        _username.text = currentUserName;
        if (value.docs[0].data()['bio'] != null || value.docs[0].data()['bio'].toString().isNotEmpty) {
          currentUserBio = value.docs[0].data()['bio'];
          _bio.text = currentUserBio;
        } else {
          currentUserBio = "Add a bio!";
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.primaryColor,
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
                    "Profile"
                )
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            ProfilePic(),
            Text(currentUserName,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            SizedBox(height: 10),
            Divider(
              thickness: 2,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Username :",
                    labelStyle:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    hintText: currentUserName),
                controller: _username,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Bio:",
                    labelStyle:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    hintText: currentUserBio),
                controller: _bio,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                color: Palette.primaryColor,
                splashColor: Colors.grey.shade50,
                onPressed: () async {
                  // UPDATE "USER" COLLECTION
                  _firestore.collection('users').doc(_auth.currentUser?.uid).update({'name': "${_username.text}"});
                  _firestore.collection('users').doc(_auth.currentUser?.uid).update({'bio': "${_bio.text}"});

                  // UPDATE "NOTIFICATION COLLECTION
                  await _firestore.collection("notifications").get().then((eventData) {
                    eventData.docs.map((DocumentSnapshot document) async {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      notificationID = document.id;
                      userExistsInGroup = false;
                      for (String user in data['test'].split(';')) {
                        if (user.split(',')[0] == _auth.currentUser!.uid) {
                          userExistsInGroup = true;
                        }
                      }
                      if (userExistsInGroup == true) {
                        String temp = "";
                        for (String user in data['test'].split(';')) {
                          if (user.split(',')[0] == _auth.currentUser!.uid) {
                            temp += user.split(',')[0] + "," + _username.text;
                            for (int z = 2; z < user.split(',').length; z++) {
                              temp += "," + user.split(',')[z];
                            }
                            temp += ";";
                          } else {
                            temp += user + ";";
                          }
                        }
                        temp = temp.substring(0, temp.length - 1);
                        await _firestore.collection('notifications').doc(notificationID).update({'test': temp});
                      }
                    }).toList();
                  });

                  // UPDATE "GROUP" COLLECTION
                  await _firestore.collection('groups').get().then((eventData) {
                    final eventDataFinal = eventData.docs.map((doc) => doc.data()).toList();
                    for (int i = 0; i < eventDataFinal.length; i++) {
                      groupID = eventDataFinal[i]['id'];
                      final List<Map<String, dynamic>> groupMap = [];
                      userExistsInGroup = false;
                      for (int j = 0; j < eventDataFinal[i]['members'].length; j++) {
                        if (eventDataFinal[i]['members'][j]['uid'] == _auth.currentUser!.uid) {
                          userExistsInGroup = true;
                        }
                      }
                      if (userExistsInGroup == true) {
                        for (int j = 0; j < eventDataFinal[i]['members'].length; j++) {
                          if (eventDataFinal[i]['members'][j]['uid'] == _auth.currentUser!.uid) {
                            groupMap.add({
                              "email": eventDataFinal[i]['members'][j]['email'],
                              "isAdmin": eventDataFinal[i]['members'][j]['isAdmin'],
                              "name": "${_username.text}",
                              "uid": eventDataFinal[i]['members'][j]['uid'],
                            });
                          } else {
                            groupMap.add({
                              "email": eventDataFinal[i]['members'][j]['email'],
                              "isAdmin": eventDataFinal[i]['members'][j]['isAdmin'],
                              "name": eventDataFinal[i]['members'][j]['name'],
                              "uid": eventDataFinal[i]['members'][j]['uid'],
                            });
                          }
                        }
                        _firestore.collection('groups').doc(groupID).set({
                          "members": groupMap,
                          "id": groupID,
                        });
                      }
                    }
                  });

                  // UPDATE AUTHENTICATION PROFILE
                  _auth.currentUser?.updateDisplayName(_username.text);
                  Navigator.pop(context);
                },
                child: Text(
                  "Save Profile",
                  style: TextStyle(
                    color: Colors.white,
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