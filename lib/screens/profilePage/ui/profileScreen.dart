import 'package:flutter/material.dart';

import 'package:nearbyexplorer/core/Responsive.dart';
import 'package:nearbyexplorer/core/constants.dart';
import 'package:nearbyexplorer/core/models/user.dart';
import 'package:nearbyexplorer/core/services/authentication.dart';
import 'package:nearbyexplorer/screens/Signin/ui/signinScreen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Icon(Icons.person_add),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: globalUser.photoURL != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(globalUser.photoURL, height: 80))
                      : Icon(
                          Icons.person,
                          size: 40,
                        ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(220),
                      child: Text(
                        globalUser.displayName,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(220),
                      child: Text(
                        globalUser.email,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            ListTile(
                leading: Icon(Icons.bookmark_border),
                minLeadingWidth: 1,
                title: Text(
                  "Previous Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                )),
            ListTile(
                leading: Icon(Icons.hourglass_disabled),
                minLeadingWidth: 1,
                title: Text(
                  "Your Favourites",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                )),
            ListTile(
                leading: Icon(Icons.quick_contacts_dialer),
                minLeadingWidth: 1,
                title: Text(
                  "Contact Us",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                )),
            ListTile(
                leading: Icon(Icons.settings),
                minLeadingWidth: 1,
                title: Text(
                  "Settings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                )),
            GestureDetector(
              onTap: () {
                AuthService().signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: ListTile(
                  leading: Icon(Icons.logout, color: Constants.kCColorDarkBLue),
                  minLeadingWidth: 1,
                  title: Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Constants.kCColorDarkBLue),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
