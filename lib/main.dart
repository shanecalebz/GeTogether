import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getogether/Authenticate/Autheticate.dart';
import 'package:getogether/Authenticate/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GeTogether());
}

class GeTogether extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeTogether',
      debugShowCheckedModeBanner: false,
      /*
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Color(0xFF1B0376),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      */
      home: Authenticate(),
    );
  }
}
