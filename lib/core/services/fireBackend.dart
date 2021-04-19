import 'package:cloud_firestore/cloud_firestore.dart';

class FireBackendServices {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  getUserByUsername(String username) {
    firebaseFirestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  getUserNameByEmail(String email) async {
    QuerySnapshot sp = await firebaseFirestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    // print(sp.docs[0].data());
    return sp.docs[0]['userName'];
  }

  uploadUserInfo(userMap) {
    firebaseFirestore.collection('users').add(userMap).catchError((e) {
      print(e);
    });
  }

  searchByName(String searchField) {
    return firebaseFirestore
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  createChatRoom(chatRoomap, chatRoomId) {
    firebaseFirestore
        .collection("ChatRooms")
        .doc(chatRoomId)
        .set(chatRoomap)
        .catchError((e) {
      print(e);
    });
  }

  getChatRooms(String itIsMyName) {
    print('getchatrooms run');
    return firebaseFirestore
        .collection("ChatRooms")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  getMessages(String chatRoomId) {
    return firebaseFirestore
        .collection("ChatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();
  }

  addMessages(String chatRoomId, messageMap) {
    firebaseFirestore
        .collection("ChatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }
}
