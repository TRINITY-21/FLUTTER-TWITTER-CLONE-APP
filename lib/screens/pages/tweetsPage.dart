import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterClone/screens/commentsPage.dart';
import 'package:twitterClone/screens/pages/addTweetPage.dart';
import 'package:twitterClone/screens/pages/viewUsersPage.dart';
import 'package:twitterClone/utils/googleFont.dart';

class TweetsPage extends StatefulWidget {
  TweetsPage({Key key}) : super(key: key);

  @override
  _TweetsPageState createState() => _TweetsPageState();
}

class _TweetsPageState extends State<TweetsPage> {
  String uid;
  int _counter;
  ///////////   Firebase Cloud Messaging implementation
  Future _incrementCounter() async {
    final user = FirebaseAuth.instance.currentUser;
    final notificationNum = await db.doc(user.uid).collection('notification').get();

    setState(() {
      _counter = notificationNum.docs.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserID();
    _incrementCounter();

    ///////// firebase messaging test

    //   _firebaseMessaging.configure(
    //     onMessage: (Map<String, dynamic> message) async {
    //       print("onMessage:$message");
    //       showDialog(
    //           context: context,
    //           builder: (context) {
    //             return AlertDialog(
    //               title: Text(message['notification']['title']),
    //               content: Text(message['notification']['body']),
    //               actions: [
    //                 FlatButton(
    //                   child: Text('ok'),
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                 )
    //               ],
    //             );
    //           });
    //     },
    //     // onLaunch: (Map<String, dynamic> message) async {
    //     //   setState(() {
    //     //     _message = '$message';
    //     //   });
    //     // },
    //     // onResume: (Map<String, dynamic> message) async {
    //     //   setState(() {
    //     //     _message = '$message';
    //     //   });
    //     // },
    //   );

    //   getToken();

    //   print(_token);
    //   print(_message);
    // }
  }

  Future getUserID() async {
    // ignore: await_only_futures
    final user = await FirebaseAuth.instance.currentUser;

    return uid = user.uid;
  }

  /// likes and dislikes

  likeTweet(String tid) async {
    DocumentSnapshot userDoc = await tweetCol.doc(tid).get();

    if (userDoc.data()['likes'].contains(uid)) {
      tweetCol.doc(tid).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      tweetCol.doc(tid).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  /// sharing of posts
  shareTweets(String tid, String tweet) async {
    Share.text("TweetMe", tweet, 'text/plain');
    //// update shares count
    DocumentSnapshot shareDoc = await tweetCol.doc(tid).get();
    tweetCol.doc(tid).update({'shares': shareDoc.data()['shares'] + 1});
  }

//// notification icon

  Widget myAppBarIcon() {
    return Container(
      width: 30,
      height: 30,
      child: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: Colors.white,
            size: 30,
          ),
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 5),
            child: Container(
              width: 115,
              height: 15,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffc32c37),
                  border: Border.all(color: Colors.white, width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    _counter.toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white12,
        floatingActionButton: FloatingActionButton(
          splashColor: Color(0xFF020E16),
          backgroundColor: Color(0xFF13536E),
          focusColor: Colors.teal,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => AddTweetPage()),
            );
          },
          child: Icon(Icons.add),
          tooltip: "Add Tweet",
        ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                Text("Tweet",
                    style: googleFont(20, Colors.white, FontWeight.w500)),
                SizedBox(width: 2),
                Text("Me",
                    style: googleFont(20, Colors.purple, FontWeight.bold)),
              ],
            ),
            Image(
              image: AssetImage('assets/logo.png'),
              //width: 50,
              height: 45,
            ),
            SizedBox(width: 30),
            myAppBarIcon(),
          ]),
          // actions: [
          //   InkWell(
          //       onTap: () async{
          //         //await authService.logout();
          //       },
          //       child: CircleAvatar(
          //                  backgroundColor: Colors.white,
          //                   radius: 20,
          //                   backgroundImage:
          //                       NetworkImage('https://cdn.pixabay.com/photo/2013/07/13/10/07/man-156584__340.png'),
          //                 ),
          //   ),
          // ],
        ),
        body: StreamBuilder(
            stream: tweetCol.orderBy('username').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i) {
                    DocumentSnapshot tweetDoc = snapshot.data.docs[i];
                    return Card(
                        color: Theme.of(context).primaryColorDark,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple,
                            backgroundImage:
                                NetworkImage(tweetDoc.data()['profilePic']),
                          ),
                          title: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ViewUsersPage(
                                              viewId: tweetDoc.data()['uid'],
                                            )),
                                  );
                                },
                                child: Text(
                                    '${tweetDoc.data()['username']}'
                                        .toLowerCase(),
                                    style: googleFont(
                                        20, Colors.white, FontWeight.w400)),
                              ),
                              SizedBox(width: 2),
                              Text('@tweetMe',
                                  style: googleFont(
                                      15, Colors.grey, FontWeight.w300)),
                            ],
                          ),
                          subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (tweetDoc.data()['type'] == 1)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${tweetDoc.data()['tweet']}',
                                        style: googleFont(
                                            20, Colors.white, FontWeight.w300)),
                                  ),
                                SizedBox(height: 10),
                                if (tweetDoc.data()['type'] == 2)
                                  Container(
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image(
                                        image: NetworkImage(
                                            tweetDoc.data()['image']),
                                      ),
                                    ),
                                  ),
                                if (tweetDoc.data()['type'] == 3)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, bottom: 8.0),
                                    child: Column(children: [
                                      Text(tweetDoc.data()['tweet'],
                                          style: googleFont(20, Colors.white,
                                              FontWeight.w300)),
                                      SizedBox(height: 15),
                                      Container(
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image(
                                            image: NetworkImage(
                                                tweetDoc.data()['image']),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                SizedBox(height: 15),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                // print(tweetDoc.data()['tid']);

                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CommentPage(
                                                                tid: tweetDoc
                                                                        .data()[
                                                                    'tid'])));
                                              },
                                              child: Icon(Icons.comment)),
                                          SizedBox(width: 5),
                                          Text(
                                            tweetDoc
                                                .data()['commentCount']
                                                .toString(),
                                            style: googleFont(20, Colors.white,
                                                FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                likeTweet(
                                                    tweetDoc.data()['tid']);
                                                print(tweetDoc.data()['tid']);
                                              },
                                              child: tweetDoc
                                                      .data()['likes']
                                                      .contains(uid)
                                                  ? Icon(Icons.favorite,
                                                      color: Colors.red)
                                                  : Icon(
                                                      Icons.favorite_border)),
                                          SizedBox(width: 5),
                                          Text(
                                            tweetDoc
                                                .data()['likes']
                                                .length
                                                .toString(),
                                            style: googleFont(20, Colors.white,
                                                FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                shareTweets(
                                                    tweetDoc.data()['tid'],
                                                    tweetDoc.data()['tweet']);
                                              },
                                              child: Icon(Icons.share)),
                                          SizedBox(width: 5),
                                          Text(
                                            tweetDoc
                                                .data()['shares']
                                                .toString(),
                                            style: googleFont(20, Colors.white,
                                                FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ])
                              ]),
                        ));
                  });
            }));
  }
}
