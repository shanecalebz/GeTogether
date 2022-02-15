import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(GeTogether());

class GeTogether extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme(
            primary: Color(0xFF005F73),
            primaryVariant: Color(0xFF04060d),
            secondary: Colors.purple,
            secondaryVariant: Color(0x800080),
            surface: Colors.white,
            background: Color(0xFF0A0E21),
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black,
            onBackground: Colors.white,
            onError: Colors.black,
            brightness: Brightness.light),
        scaffoldBackgroundColor: Color(0xFFE9D8A6),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
