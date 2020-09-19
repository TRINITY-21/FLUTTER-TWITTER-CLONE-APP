import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:twitterClone/models/userModel.dart';
import 'package:twitterClone/services/databaseUser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _firebaseMessaging =  FirebaseMessaging();

  ///User model to retrieve info needed from the user

  UserModel _userFromFirebase(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //// Register user

  Future createUser(UserModel users) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: users.email, password: users.password);
    
    String fcmToken = await _firebaseMessaging.getToken();

    User user = userCredential.user;

    /// add users to Colleection

    /// add fcm token to users collection

    DatabaseUser(uid: user.uid).createDoc(
        user.uid,
        users.name,
        users.email,
        fcmToken,
        'https://cdn.pixabay.com/photo/2013/07/13/10/07/man-156584__340.png',
        users.password
        );

    await user.reload();
    user = _auth.currentUser;

    return _userFromFirebase(user);
  }

  ///// Sign user in

  Future signIn(UserModel users) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: users.email, password: users.password);
    User user = userCredential.user;
    print(user.uid);
    return _userFromFirebase(user);
  }

  //// Sreams to listen to any changes

  Stream<UserModel> get user {
    return _auth.authStateChanges().map((User user) => _userFromFirebase(user));
  }

  // logout() {
  //   return _auth.signOut();
  // }

}
