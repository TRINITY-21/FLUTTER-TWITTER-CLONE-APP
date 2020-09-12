class UserModel {
  String name;
  String password;
  String email;
  String uid;
  String profilePic;

  UserModel({this.name, this.password, this.email, this.profilePic, this.uid});

  UserModel.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['fullName'],
        email = data['email'],
        password = data['password'],
        profilePic = data['profilePic'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': name,
      'email': email,
      'password': password,
      'profilePic' :'https://cdn.pixabay.com/photo/2013/07/13/10/07/man-156584__340.png',

    };
  }
}
