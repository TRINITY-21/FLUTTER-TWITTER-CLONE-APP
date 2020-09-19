
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitterClone/models/userDocModel.dart';


class DatabaseUser {
  String uid;

  final CollectionReference _db =
      FirebaseFirestore.instance.collection("Users");

  DatabaseUser({uid});

  Future createDoc(String uid, String name, String email, String profilePic, String fcmToken,
      String password) async {
    return await _db.doc(uid).set({
      'uid': uid,
      "username": name,
      "email": email,
      "profilePic":
          'https://cdn.pixabay.com/photo/2013/07/13/10/07/man-156584__340.png',
      'password': password
    });
  }

  // UserDoc Model
  UserDocModel _userDocModel(DocumentSnapshot snapshot) {
    return UserDocModel(
      uid: uid,
      name: snapshot.data()['name'],
      email: snapshot.data()['email'],
      password: snapshot.data()['password'],
      profilePic: snapshot.data()['profilePic'],
    );
  }

  Future getAllDocs() async {
    return _db.doc(uid).get();
  }

  /// Stream to listen to this change
  Stream<UserDocModel> get userDoc {
    return _db
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot snap) => _userDocModel(snap));
  }

  // ignore: unused_element
  List<UserDocModel> _userSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserDocModel(
        uid: uid,
        name: doc.data()['name'],
        email: doc.data()['email'],
        password: doc.data()['password'],
        profilePic: doc.data()['profilePic'],
      );
    }).toList();
  }

  Future updateUser(String name) async {
    return _db
        .doc(uid)
        .update({'username': name});
  }
}
