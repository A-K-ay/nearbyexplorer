import 'package:flutter_svg/flutter_svg.dart';
import 'package:nearbyexplorer/core/widgets/showToast.dart';
import '../../../core/widgets/circularImageIcon.dart';

import '../../mainscreen/ui/mainScreen.dart';

import '../../../core/services/authentication.dart';
import '../../../core/services/fireBackend.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController resetPassword = TextEditingController();
  bool isSignUp = false;
  bool showProgressIndicator = false;
  final AuthService authService = AuthService();
  final FireBackendServices fireBackendServices = FireBackendServices();
  final formkey = GlobalKey<FormState>();
  FToast fToast;
  googleSignIn() async {
    setState(() {
      showProgressIndicator = true;
    });
    bool issigned = await AuthService().signInWithGoogle(context);
    if (issigned == false) {
      print("Error in the login sytem");
      setState(() {
        showProgressIndicator = false;
      });
      _showToast("Google Sign In Error");
    } else {
      await authService.updateUserNameSharedPrefrences();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
    }
  }

  facebookSignIn() async {
    setState(() {
      showProgressIndicator = true;
    });
    bool issigned = await AuthService().signInWithFacebook(context);
    if (issigned == null) {
      _showToast("Sign In Error");
      setState(() {
        showProgressIndicator = false;
      });
    }

    if (issigned == false) {
      print("Error in the login sytem");
      setState(() {
        showProgressIndicator = false;
      });
      _showToast("Sign In Error");
    } else {
      await authService.updateUserNameSharedPrefrences();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast(String txt) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Constants.kCLightBlue,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outlined,
            color: Colors.redAccent,
          ),
          SizedBox(
            width: 12.0,
          ),
          SizedBox(width: 200, child: Text(txt)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void showGoogleSigninerror() {
    _showToast("Google Sign In error.Use email SignUp");
  }

  signIn() async {
    if (formkey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        showProgressIndicator = true;
      });
      await authService
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        if (value == null) {
          print("Error in the login sytem either no account like that of no ");
          setState(() {
            setState(() {
              showProgressIndicator = false;
            });
          });
          _showToast("No Such User Exists");
        }
      });
      await authService.updateUserNameSharedPrefrences();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
      setState(() {
        showProgressIndicator = false;
      });
    }
  }

  signUp() async {
    if (formkey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        showProgressIndicator = true;
      });
      await authService
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        if (value == false) {
          print("there was an error");
          setState(() {
            showProgressIndicator = false;
          });
          _showToast("User Exists already");
        }
      });
      Map<String, String> userMap = {
        "userName": usernameController.text,
        "email": emailController.text
      };
      await fireBackendServices.uploadUserInfo(userMap);
      await authService.updateUserNameSharedPrefrences();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
      setState(() {
        showProgressIndicator = false;
      });
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              controller: resetPassword,
              decoration: InputDecoration(hintText: "email "),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  authService.resetPass(resetPassword.text);
                  Navigator.pop(context);
                  _showToast(
                      "Please Check your email for a reset password link");
                },
              ),
            ],
          );
        });
  }

  String codeDialog;
  String valueText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showProgressIndicator,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: isSignUp ? 40 : 60,
                      ),
                      Text(
                        isSignUp ? "Sign Up" : "Welcome \nBack",
                        style: GoogleFonts.ptSerif(
                            fontStyle: FontStyle.normal, fontSize: 30),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            isSignUp
                                ? TextFormField(
                                    onChanged: (value) {},
                                    onFieldSubmitted: (val) {
                                      isSignUp ? signUp() : signIn();
                                    },
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          gapPadding: 0,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40.0)),
                                          borderSide: BorderSide(width: 2)),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText: "Username",
                                      hintText: " Enter your username",
                                    ),
                                    validator: (val) {
                                      return val.isEmpty || val.length < 3
                                          ? "Enter Username 3+ characters"
                                          : null;
                                    },
                                  )
                                : SizedBox(),
                            isSignUp
                                ? SizedBox(
                                    height: 40,
                                  )
                                : SizedBox(),
                            TextFormField(
                              onChanged: (value) {},
                              onFieldSubmitted: (val) {
                                isSignUp ? signUp() : signIn();
                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    gapPadding: 0,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40.0)),
                                    borderSide: BorderSide(width: 2)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Email",
                                hintText: "Enter your email",
                              ),
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Enter a correct email";
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              onChanged: (value) {},
                              onFieldSubmitted: (val) {
                                isSignUp ? signUp() : signIn();
                              },
                              controller: passwordController,
                              keyboardAppearance: Brightness.dark,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    gapPadding: 0,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40.0)),
                                    borderSide: BorderSide(width: 2)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Password",
                                hintText: "Enter your password",
                              ),
                              validator: (val) {
                                return val.length < 6
                                    ? "Password must be more than 6 characters"
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isSignUp ? "Sign Up " : "Sign in",
                            style: GoogleFonts.ptSerif(
                                fontStyle: FontStyle.normal, fontSize: 24),
                          ),
                          GestureDetector(
                            onTap: isSignUp ? signUp : signIn,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Constants.kCColorDarkBLue,
                                boxShadow: [
                                  //background color of box
                                  BoxShadow(
                                    color: Constants.kCLightBlue,
                                    blurRadius: 5.0, // soften the shadow
                                    spreadRadius: .5, //extend the shadow
                                    offset: Offset(
                                      2.0, // Move to right 10  horizontally
                                      2.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: isSignUp ? 20 : 40,
                      ),
                      Row(children: <Widget>[
                        Expanded(child: Divider()),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "OR",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(child: Divider()),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircularSVGIcon(
                            url: "assets/icons/google-icon.svg",
                            rad: 50,
                            height: 50,
                            fuc: googleSignIn,
                          ),
                          CircularSVGIcon(
                            url: "assets/icons/facebook-2.svg",
                            rad: 50,
                            height: 50,
                            fuc: facebookSignIn,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: isSignUp ? 40 : 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isSignUp = !isSignUp;
                              });
                            },
                            child: Text(
                              !isSignUp ? "Sign up" : "Sign In",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          isSignUp
                              ? SizedBox()
                              : TextButton(
                                  onPressed: () {
                                    _displayTextInputDialog(context);
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic),
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
        ),
      ),
    );
  }
}
