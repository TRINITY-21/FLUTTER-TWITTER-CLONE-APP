import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitterClone/screens/pages/viewUsersPage.dart';
import 'package:twitterClone/utils/googleFont.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Future searchResultSnapshot(String searchValue) async {
  //   QuerySnapshot usersSnapshot =
  //      await db.where('username', isGreaterThanOrEqualTo: searchValue).get();

  //   // setState(() {
  //   //   searchResultSnapshot = users;
  //   // });

  //   print(usersSnapshot);

  // String s;

  Future<QuerySnapshot> searchResultSnapshot;
  searchUser(String searchValue) {
    final users =
        db.where('username', isGreaterThanOrEqualTo: searchValue).get();

    setState(() {
      searchResultSnapshot = users;
    });

    // print(users);
  }


  
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B2939),
      appBar: AppBar(
        title: TextFormField(
          style: googleFont(15, Colors.white),
          decoration: InputDecoration(
            filled: true,
            hintText: "Search for users",
            hintStyle: TextStyle(color: Colors.white),
            fillColor: Color(0xff1B2939),
            labelStyle: googleFont(15, Colors.purple, FontWeight.w300),
          ),
          onFieldSubmitted: searchUser,
        ),
      ),
      body: searchResultSnapshot == null
          ? Center(
              child: Text('Search users',
                  style: googleFont(30, Colors.white, FontWeight.w200)),
            )
          : SingleChildScrollView(
              child: FutureBuilder(
                  // stream: db.where('username', isEqualTo: s).snapshots(),
                  future: searchResultSnapshot,
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(150.0),
                        child: Center(
                          child: CircularProgressIndicator()
                          ),
                      );
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot usersSnap =
                              snapshot.data.docs[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    usersSnap.data()['profilePic']),
                                backgroundColor: Colors.white,
                              ),
                              title: Text(usersSnap.data()['username']),
                            trailing: Container(
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                    return ViewUsersPage( viewId : usersSnap.data()['uid']);
                                  }));
                                },
                                    child: Center(
                                  child: Text("View", textAlign: TextAlign.justify, style:googleFont(12,Colors.white))),
                              ),
                              height: 64,
                              width: 64,
                              margin: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color:Color(0xFF243B55),
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            ),
                          );
                        });
                  }),
            ),
    );
  }
}
