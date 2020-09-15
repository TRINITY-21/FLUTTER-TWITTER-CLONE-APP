import 'package:flutter/cupertino.dart';
import 'package:twitterClone/models/userModel.dart';
import 'package:twitterClone/services/databaseUser.dart';

class EditProfile with ChangeNotifier {
  DatabaseUser db = DatabaseUser();
  String username;
  String profilePic;

  EditProfile({this.username, this.profilePic});

  //// getters
  String get name => username;
  String get profile => profilePic;

  /// setters;
  changeName(String value) {
    username = value;
    notifyListeners();
  }

  changeProfile(String value) {
    profilePic = value;
    notifyListeners();
  }

  editUser() {
    final user = UserModel(name: name, profilePic: profilePic);
    db.updateUser(user);
  }
}
