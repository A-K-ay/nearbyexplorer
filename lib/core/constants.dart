import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff7B73F9);
Color kPrimaryLightColor = Color(0xff94949C);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
const kInputDecoration = InputDecoration(
  hintText: 'Enter your password.',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class Constants {
  static String myName = "yama";
  static const kCDarkestBlue = Color(0xff0e0401);
  static const kCColorDarkBLue = Color(0xff942b0e);
  static const kMediumBlue = Color(0xffeb5c34);
  static const kCBlueGrey = Color(0xff6497b1);
  static const kCLightBlue = Color(0xfff8f5f1);
  // static const kCDarkestBlue = Color(0xff011f4b);
  // static const kCColorDarkBLue = Color(0xff03396c);
  // static const kMediumBlue = Color(0xff005b96);
  // static const kCBlueGrey = Color(0xff6497b1);
  // static const kCLightBlue = Color(0xfff0f8ff);
  static bool isLocationdenied = false;
}
