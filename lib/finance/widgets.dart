import 'package:flutter/material.dart';

Widget userIcon(data) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Icon(
        data['icon'],
        size: 30,
      ),
    ),
  );
}

Widget userName(data) {
  return Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
        text: '${data['name']}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ),
  );
}

Widget userAmt(data) {
  return Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
        text: '${data['customAmt']}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 10,
        ),
      ),
    ),
  );
}
