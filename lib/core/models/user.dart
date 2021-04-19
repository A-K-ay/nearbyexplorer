import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  String uid;
  String email;
  String displayName;
  String photoURL;
  String rating;

  MyUser(
      {this.uid,
      this.displayName = "",
      this.email = "",
      this.photoURL,
      this.rating});

  updatDetails({String e, String u, String imgUrl}) {
    email = e;
    displayName = u;
    if (imgUrl != null) {
      photoURL = imgUrl;
    }
  }
}

MyUser globalUser = MyUser();
