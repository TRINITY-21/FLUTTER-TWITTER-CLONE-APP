import 'package:flutter/material.dart';
import 'package:twitterClone/screens/pages/profilePage.dart';
import 'package:twitterClone/screens/pages/searchPage.dart';
import 'package:twitterClone/screens/pages/tweetsPage.dart';
// import 'package:twitterClone/utils/googleFont.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List pageOptions = [
    TweetsPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).primaryColor,

      body: pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              size: 30.0,
            ),
            title: Text(
              'Tweets',
              style: TextStyle(fontSize: 15),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30.0,
            ),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30.0,
            ),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:  Color(0xff1CA1F1),
        unselectedItemColor:Theme.of(context).primaryColorDark,

      ),
    );
  }
}
