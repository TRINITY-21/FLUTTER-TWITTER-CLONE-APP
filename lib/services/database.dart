import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterClone/services/databaseUser.dart';

class DatabaseService {
  final CollectionReference _tweet =
      FirebaseFirestore.instance.collection("Tweets");

  /// get lenght of docs
  DatabaseUser databaseUser = DatabaseUser();
  //// get currentUser

  User user = FirebaseAuth.instance.currentUser;
  DatabaseUser db = DatabaseUser();
  //db.getAllDocs();

  /// add users to Colleection
  Future createTweet(
      String name,
      String tid,
      String profilePic,
      String uid,
      String tweet,
      String imgUrl,
      List likes,
      double commentCount,
      double shares,
      double type) async {
    return await _tweet.doc('Tweet ').set({
      'uid': uid,
      'tid': tid,
      "username": '',
      "tweet": tweet,
      'likes': [],
      'commentCount': 0,
      'shares': 0,
      'type': 1,
      'imgUrl':
          'https://cdn.pixabay.com/photo/2013/07/13/10/07/man-156584__340.png',
      "profilePic":
          'https://cdn.pixabay.com/photo/2013/07/13/10/07/man-156584__340.png',
    });
  }
}
