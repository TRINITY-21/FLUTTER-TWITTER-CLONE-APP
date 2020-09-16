import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:twitterClone/provider/userProvider.dart';
import 'package:twitterClone/screens/navigationPage.dart';
import 'package:twitterClone/services/authService.dart';
import 'package:twitterClone/services/databaseUser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     _showItemDialog(message);
    //   },
    //   onBackgroundMessage: myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     _navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     _navigateToItemDetail(message);
    //   },
    // );

    
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          StreamProvider(create: (context) => AuthService().user),
          StreamProvider(create: (context) => DatabaseUser().userDoc),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Twitter Clone',
          theme: ThemeData(
              primaryColor: Color(0xff15202C),
              primaryColorDark: Color(0xff1B2939),
              accentColor: Color(0xff1CA1F1),
              iconTheme: IconThemeData(color: Color(0xff1CA1F1))),
          home: NavigationPage(),
        ));
  }
}
