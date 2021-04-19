import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearbyexplorer/screens/Signin/ui/signinScreen.dart';
import 'screens/mainscreen/ui/mainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  FirebaseAuth _auth = FirebaseAuth.instance;
  getCurrentUser() {
    return _auth.currentUser != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nearby Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.ptSerifTextTheme(),
        ),
        home: getCurrentUser() ? MainScreen() : LoginScreen());
  }
}
