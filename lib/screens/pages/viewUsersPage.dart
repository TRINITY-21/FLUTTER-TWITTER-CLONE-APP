import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:twitterClone/screens/commentsPage.dart';
import 'package:twitterClone/utils/googleFont.dart';

class ViewUsersPage extends StatefulWidget {
  final String viewId;
  ViewUsersPage({this.viewId});

  @override
  _ViewUsersPageState createState() => _ViewUsersPageState();
}

class _ViewUsersPageState extends State<ViewUsersPage> {
  Stream userStream;
  String uid;
  String profilePic;
  String username;
  bool dataInfo = false;
  int followers;
  // int notification;
  int following;
  bool isFollowing = false;

  Future getUserID() async {
    var user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user.uid;
    });
  }

  Future getUserTweets() async {
    // ignore: await_only_futures
    //final user = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await db.doc(widget.viewId).get();
    ////print(userTweet.data());
    print(userDoc.data());

    return userStream = tweetCol
        .where('username',
            isEqualTo: userDoc.data()['username'].toString().trim())
        .snapshots();
  }

  Future getUserInfo() async {
    // ignore: await_only_futures
    try {
      //final user = FirebaseAuth.instance.currentUser;

      DocumentSnapshot userDocu = await db.doc(widget.viewId).get();
      final follwersDoc =
          await db.doc(widget.viewId).collection('followers').get();

      final followingDoc =
          await db.doc(widget.viewId).collection('following').get();

      // final notificationDoc =
      //     await db.doc(uid).collection('notification').get();

      setState(() {
        username = userDocu.data()['username'];
        profilePic = userDocu.data()['profilePic'];
        dataInfo = true;
        followers = follwersDoc.docs.length;
        following = followingDoc.docs.length;
        // notification = notificationDoc.docs.length;
        // print(notification);
      });

      print(userDocu.data());
      print(profilePic);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  /// likes and dislikes

  likeTweet(String tid) async {
    final user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot userDoc = await tweetCol.doc(tid).get();

    if (userDoc.data()['likes'].contains(user.uid)) {
      tweetCol.doc(tid).update({
        'likes': FieldValue.arrayRemove([user.uid])
      });
    } else {
      tweetCol.doc(tid).update({
        'likes': FieldValue.arrayUnion([user.uid])
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

  /////  follow user

  followUser() async {
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await db.doc(user.uid).get();
    DocumentSnapshot userD = await db.doc(widget.viewId).get();

    DocumentSnapshot follow =
        await db.doc(widget.viewId).collection('followers').doc(user.uid).get();

    if (!follow.exists) {
      db.doc(widget.viewId).collection('followers').doc(user.uid).set({});
      db.doc(widget.viewId).collection('notification').doc(user.uid).set({
        'title': userD.data()['username'] + ' @tweetMe',
        'message':
            userDoc.data()['username'] + '@tweetMe started following you',
        'date': FieldValue.serverTimestamp(),
      });
      setState(() {
        followers++;
        // notification++;
        //following++;
        isFollowing = true;
      });
      print('followed');

      db.doc(user.uid).collection('following').doc(widget.viewId).set({});
      print('following');
    } else {
      db.doc(widget.viewId).collection('followers').doc(user.uid).delete();
      print('followed delete');
      db.doc(widget.viewId).collection('notification').doc(user.uid).delete();

      db.doc(user.uid).collection('following').doc(widget.viewId).delete();
      setState(() {
        followers--;
        // notification--;
        //following--;
        isFollowing = false;
      });
      print('following delete');
    }
  }

  ///////////  FCM MESSAGE  ////////////////

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // Future getToken() async {
  //   String token = await _firebaseMessaging.getToken();
  //   assert(token != null);
  //   print(token);
  // }

  @override
  void initState() {
    super.initState();
    getUserID();
    getUserTweets();
    getUserInfo();
    // getToken();

    ///////// firebase messaging test

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage:$message");
        showDialogNotification("Notification", "$message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        showDialogNotification("Notification", "$message");
      },
      onResume: (Map<String, dynamic> message) async {
        showDialogNotification("Notification", "$message");
      },
    );

    //// IOS permission
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );
    }
  }

  showDialogNotification(String title, String description) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              FlatButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                Text("Profile",
                    style: googleFont(20, Colors.white, FontWeight.w500)),
                SizedBox(width: 3),
                // Text("Me",
                //     style: googleFont(20, Colors.purple, FontWeight.bold)),
              ],
            ),
            Image(
              image: AssetImage('assets/logo.png'),
              //width: 50,
              height: 45,
            ),
          ]),
          actions: [
            InkWell(
              onTap: () async {
                //await authService.logout();
              },
              child: dataInfo == true
                  ? CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 20,
                      backgroundImage: NetworkImage(profilePic),
                    )
                  : Text(''),
            ),
          
          ],
        ),
        body: dataInfo == true
            ? SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Stack(children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.purple, Color(0xff1B2939)])),
                      child: Image(
                        image: NetworkImage(
                          profilePic,
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 5,
                      left: MediaQuery.of(context).size.width / 2 - 164,
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        profilePic,
                      ),
                      backgroundColor: Colors.purpleAccent,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 5,
                        left: MediaQuery.of(context).size.width / 2 + 124),
                    child: InkWell(
                        onTap: () {},
                        child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(colors: [
                                Colors.lightBlue,
                                Colors.purple,
                              ]),
                            ),
                            child: Center(
                                child: InkWell(
                              onTap: () {
                                followUser();
                              },
                              child: Text(
                                isFollowing == true ? "Unfollow" : "Follow",
                                style: googleFont(
                                    10, Colors.white, FontWeight.w500),
                              ),
                            )))),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3.5,
                    ),
                    child: Column(
                      children: [
                        Text(username.toUpperCase(),
                            textScaleFactor: 1.3,
                            style:
                                googleFont(20, Colors.white, FontWeight.w500)),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text("Following",
                                    style: googleFont(
                                        15, Colors.white, FontWeight.w300)),
                                Icon(Icons.mood, size: 14)
                              ],
                            ),
                            Row(
                              children: [
                                Text("Followers",
                                    style: googleFont(
                                        15, Colors.white, FontWeight.w300)),
                                Icon(Icons.accessibility_new, size: 14)
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(following.toString(),
                                style: googleFont(
                                    15, Colors.white, FontWeight.w400)),
                            Text(followers.toString(),
                                style: googleFont(
                                    15, Colors.white, FontWeight.w400)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.purple]),
                            ),
                            child: Center(
                              child: Text(
                                "Tweets",
                                style: googleFont(
                                    15, Colors.white, FontWeight.w500),
                              ),
                            )),
                        SizedBox(height: 20),
                        StreamBuilder(
                            stream: userStream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, i) {
                                    DocumentSnapshot tweetDoc =
                                        snapshot.data.docs[i];
                                    return Card(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                                tweetDoc.data()['profilePic']),
                                          ),
                                          title: Row(
                                            children: [
                                              Text(
                                                  tweetDoc
                                                      .data()['username']
                                                      .toLowerCase(),
                                                  style: googleFont(
                                                      20,
                                                      Colors.white,
                                                      FontWeight.w400)),
                                              SizedBox(width: 2),
                                              Text('@tweetMe',
                                                  style: googleFont(
                                                      15,
                                                      Colors.grey,
                                                      FontWeight.w300)),
                                            ],
                                          ),
                                          subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (tweetDoc.data()['type'] ==
                                                    1)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        '${tweetDoc.data()['tweet']}',
                                                        style: googleFont(
                                                            20,
                                                            Colors.white,
                                                            FontWeight.w300)),
                                                  ),
                                                SizedBox(height: 10),
                                                if (tweetDoc.data()['type'] ==
                                                    2)
                                                  Container(
                                                    width: double.infinity,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image(
                                                        image: NetworkImage(
                                                            tweetDoc.data()[
                                                                'image']),
                                                      ),
                                                    ),
                                                  ),
                                                if (tweetDoc.data()['type'] ==
                                                    3)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0.0,
                                                            bottom: 8.0),
                                                    child: Column(children: [
                                                      Text(
                                                          tweetDoc
                                                              .data()['tweet'],
                                                          style: googleFont(
                                                              20,
                                                              Colors.white,
                                                              FontWeight.w300)),
                                                      SizedBox(height: 15),
                                                      Container(
                                                        width: double.infinity,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image(
                                                            image: NetworkImage(
                                                                tweetDoc.data()[
                                                                    'image']),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                SizedBox(height: 15),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                // print(tweetDoc.data()['tid']);

                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                CommentPage(tid: tweetDoc.data()['tid'])));
                                                              },
                                                              child: Icon(Icons
                                                                  .comment)),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            tweetDoc
                                                                .data()[
                                                                    'commentCount']
                                                                .toString(),
                                                            style: googleFont(
                                                                20,
                                                                Colors.white,
                                                                FontWeight
                                                                    .w300),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                likeTweet(tweetDoc
                                                                        .data()[
                                                                    'tid']);
                                                                print(tweetDoc
                                                                        .data()[
                                                                    'tid']);
                                                              },
                                                              child: tweetDoc
                                                                      .data()[
                                                                          'likes']
                                                                      .contains(
                                                                          uid)
                                                                  ? Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: Colors
                                                                          .red)
                                                                  : Icon(Icons
                                                                      .favorite_border)),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            tweetDoc
                                                                .data()['likes']
                                                                .length
                                                                .toString(),
                                                            style: googleFont(
                                                                20,
                                                                Colors.white,
                                                                FontWeight
                                                                    .w300),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                shareTweets(
                                                                    tweetDoc.data()[
                                                                        'tid'],
                                                                    tweetDoc.data()[
                                                                        'tweet']);
                                                              },
                                                              child: Icon(
                                                                  Icons.share)),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            tweetDoc
                                                                .data()[
                                                                    'shares']
                                                                .toString(),
                                                            style: googleFont(
                                                                20,
                                                                Colors.white,
                                                                FontWeight
                                                                    .w300),
                                                          ),
                                                        ],
                                                      ),
                                                    ])
                                              ]),
                                        ));
                                  });
                            })
                      ],
                    ),
                  ),
                ]))
            : Center(child: CircularProgressIndicator()));
  }
}
