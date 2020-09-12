import 'package:flutter/material.dart';
import 'package:twitterClone/models/userModel.dart';
import 'package:twitterClone/services/authService.dart';

class UserProvider with ChangeNotifier {
  final AuthService authService = AuthService();
  String _name;
  String _password;
  String _profilePic;
  String _email;

  /// getters

  String get name => _name;
  String get password => _password;
  String get email => _email;
  String get profilePic => _profilePic;

  /// setters

  changeName(String value) {
    _name = value;
    notifyListeners();
  }

  changeEmail(String value) {
    _email = value;
    notifyListeners();
  }

  changePassword(String value) {
    _password = value;
    notifyListeners();
  }

  changePic(String value) {
    _profilePic = value;
    notifyListeners();
  }

  saveUser() {
    var users = UserModel(name: name, password: password, email: email);
    authService.createUser(users);
    print("$name,$password,$email");
  }

  signIn() {
    var users = UserModel(password: password, email: email);
    authService.signIn(users);
    print("$password,$email");
  }

  // createTweet() {
  //   var tweets = Tweets();
  //   _db.createTweet(tid:tid, profilePic, uid, tweet, imgUrl, likes, commentCount, shares, type)
  // }

  logout(String id){
    
  }
}
