//import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterClone/models/userModel.dart';
import 'package:twitterClone/screens/homePage.dart';

// import 'package:provider/provider.dart';
// import 'package:twitterClone/models/userModel.dart';
import 'package:twitterClone/screens/loginPage.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  //bool isSigned = false;

//   @override
//   void initState() {
// //     FirebaseAuth.instance.authStateChanges().listen((event) {
// //       if (event == null) {
// //         setState(() {
// //           isSigned = true;
// //         });
// //       } else {
// //         setState(() {
// //           isSigned = false;
// //         });
// //       }
// //     });
// //   super.initState();

// // }

    @override
    Widget build(BuildContext context) {
      final user = Provider.of<UserModel>(context);

      if (user != null) {
        print("You are not registered $user");

        return LoginPage();
      } else {
        print("You are registered $user");
        return HomePage();
      }

      //return Scaffold(body: (isSigned == true) ? LoginPage() : HomePage());
    }
  }

