import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterClone/screens/commentsPage.dart';
import 'package:twitterClone/screens/pages/editPage.dart';
import 'package:twitterClone/utils/googleFont.dart';

class ProfilePage extends StatefulWidget {
  final String id;
  final String tid;
  final String userId;
  ProfilePage({this.id, this.tid, this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String uid;
  Stream userStream;
  String profilePic;
  String username;
  bool dataInfo = false;
  int following;
  int followers;

  Future getUserID() async {
    var user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user.uid;
    });
  }

  ///  user tweets
  Future getUserTweets() async {
    // ignore: await_only_futures
    //final user = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await db.doc(uid).get();
    ////print(userTweet.data());
    print(userDoc.data());

    return userStream = tweetCol
        .where('username',
            isEqualTo: userDoc.data()['username'].toString().trim())
        .snapshots();
  }

  ///  user tweets
  Future getUserInfo() async {
    // ignore: await_only_futures
    try {
      //final user = FirebaseAuth.instance.currentUser;

      DocumentSnapshot userDocu = await db.doc(uid).get();
      setState(() {
        username = userDocu.data()['username'];
        profilePic = userDocu.data()['profilePic'];
        dataInfo = true;
        //uid = userDocu.data()['uid'];
      });

      print(userDocu.data());
      //print(profilePic);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  ////////////   followers

  @override
  void initState() {
    super.initState();
    getUserID();
    getUserTweets();
    getUserInfo();
    followInfo();
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

  followInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final followingDoc = await db.doc(user.uid).collection('following').get();
    final followersDoc = await db.doc(user.uid).collection('followers').get();

    setState(() {
      following = followingDoc.docs.length;
      followers = followersDoc.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
     showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SettingsForm(),
      ));
    });
    }

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
                SizedBox(width: 2),
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
            )
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
                      backgroundColor: Colors.purple,
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
                                _showSettingsPanel();
                                // Navigator.of(
                                //     context)
                                // .push(MaterialPageRoute(
                                //     builder:
                                //         (context) =>
                                //             SettingsForm()) );
                              },
                              child: Text(
                                "Edit Profile",
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
                        SizedBox(height: 20),
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
                                            backgroundColor: Colors.purple,
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
