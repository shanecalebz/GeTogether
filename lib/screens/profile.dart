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
          Expanded(
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
              ))
        ],
      ),
    );
  }
}

/*TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Username :",
                            labelStyle: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            hintText: "Tap to change username"),
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
