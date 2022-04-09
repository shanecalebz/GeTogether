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

  void getUserInfo() async {
    await _firestore
        .collection('users')
        .where("email", isEqualTo: _auth.currentUser!.email)
        .get()
        .then((value) {
      setState(() {
        currentUserName = value.docs[0].data()['name'];
        _username.text = currentUserName;
        if (value.docs[0].data()['bio'] != null ||
            value.docs[0].data()['bio'].toString().isNotEmpty) {
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
        centerTitle: true,
        title: Text("GeTogether"),
        backgroundColor: Palette.primaryColor,
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
                maxLines: null,
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
                color: Colors.white,
                splashColor: Colors.grey.shade50,
                onPressed: () {
                  // UPDATE FIRESTORE
                  _firestore
                      .collection('users')
                      .doc(_auth.currentUser?.uid)
                      .update({'name': "${_username.text}"});
                  _firestore
                      .collection('users')
                      .doc(_auth.currentUser?.uid)
                      .update({'bio': "${_bio.text}"});

                  // UPDATE AUTHENTICATION PROFILE
                  _auth.currentUser?.updateDisplayName(_username.text);
                  Navigator.pop(context);
                },
                child: Text("Save Profile"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("GeTogether")),
        backgroundColor: Palette.primaryColor,
      ),
      body: Column(
        children: <Widget>[
          ProfilePic(),
          Text("${_auth.currentUser?.displayName}",
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
                  hintText: "${_auth.currentUser?.displayName}"),
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
                  hintText: "${_auth.currentUser?.displayName}"),
              controller: _bio,
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Colors.white,
              splashColor: Colors.grey.shade50,
              onPressed: () {
                _firestore
                    .collection('users')
                    .doc(_auth.currentUser?.uid)
                    .update({'name': "${_username.text}"});
                _firestore
                    .collection('users')
                    .doc(_auth.currentUser?.uid)
                    .update({'bio': "${_bio.text}"});
                Navigator.pop(context);
              },
              child: Text("Save Profile"),
            ),
          )
        ],
      ),
    );
  }
}

Widget build(BuildContext context) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return FutureBuilder<DocumentSnapshot>(
    future: users.doc("bio").get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }

      if (snapshot.hasData && !snapshot.data!.exists) {
        return Text("Document does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Text(" ${data['bio']} ");
      }

      return Text("loading");
    },
  );
}
*/

/*TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Username :",
                            labelStyle: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            hintText: "Tap to change username"),
                                                    controller: controllerNickname,
                        onChanged: (value) {
                          nickname = value;
                        },
                      ),

                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Bio:"),
                      ),
                    ),
                    SizedBox(height: 20.0),
                     */

/*  Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Username:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'AdamSilverButton',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      width: 400,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white70,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade50, spreadRadius: 3),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Bio:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'My name is Adam and I am  a freelance mobile app developper.\n'
                              'if you need any mobile app for your company then contact me for more informations',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white70,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade50, spreadRadius: 3),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        color: Colors.white,
                        splashColor: Colors.grey.shade50,
                        onPressed: () {
                          // TODO: Save somehow
                          Navigator.pop(context);
                        },
                        child: Text("Save Profile"),
                      ),
                    )
                  ],
                ),
              ))*/
