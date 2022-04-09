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
        title: Center(child: Text("GeTogether")),
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