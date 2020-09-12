import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterClone/screens/commentsPage.dart';
import 'package:twitterClone/utils/googleFont.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String uid;
  Stream userStream;
  String profilePic;
  String username;
  bool dataInfo = false;

  // final AuthService authService = AuthService();

  Future getUserID() async {
    // ignore: await_only_futures
    final user = await FirebaseAuth.instance.currentUser;

    return uid = user.uid;
  }

  ///  user tweets
  Future getUserTweets() async {
    // ignore: await_only_futures
    final user = await FirebaseAuth.instance.currentUser;
    //DocumentSnapshot userTweet = await tweetCol.doc(user.uid).get();
    //String utid = userTweet.data()['uid'];

    return userStream = tweetCol.where(user.uid).snapshots();
  }

  ///  user tweets
  Future getUserInfo() async {
    // ignore: await_only_futures
    final user = await FirebaseAuth.instance.currentUser;

    DocumentSnapshot userDoc = await tweetCol.doc(user.uid).get();
    setState(() {
      username = userDoc.data()['username'];
      profilePic = userDoc.data()['profilePic'];
      dataInfo = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserID();
    getUserTweets();
   getUserInfo();
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
                onTap: () async{
                  //await authService.logout();
                },
                child: CircleAvatar(
                           backgroundColor: Colors.white,
                            radius: 20,
                            backgroundImage:
                                NetworkImage('https://cdn.pixabay.com/photo/2013/07/13/10/07/man-156584__340.png'),
                          ),
            ),
          ],
        ),
        body: dataInfo == false ? SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [ Colors.purple,  Color(0xff1B2939)])
                        
                        ),

                        child: Image(image: NetworkImage(
                    defaultImage,
                  ),)
                    
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 5,
                  left: MediaQuery.of(context).size.width / 2 - 164,
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    defaultImage,
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              
              
               Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 5,
                  left: MediaQuery.of(context).size.width / 2 + 124
                ),
                child:  InkWell(
                        onTap: () {},
                        child: Container(
                          
                            width: MediaQuery.of(context).size.width / 4,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  colors: [ Colors.lightBlue,Colors.transparent,]),
                            ),
                            child: Center(
                              child: Text(
                                "Edit Profile",
                                style: googleFont(
                                    10, Colors.white, FontWeight.w500),
                              ),
                            ))),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3.5,
                ),
                child: Column(
                  children: [
                    Text('CHAOLU',
                        style: googleFont(20, Colors.white, FontWeight.w300)),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text("Following",
                                style:
                                    googleFont(12, Colors.white, FontWeight.w300)),
                                    Icon(Icons.mood, size:14)
                          ],
                        ),
                        Row(
                          children: [
                            Text("Followers",
                                style:
                                    googleFont(12, Colors.white, FontWeight.w300)),
                                     Icon(Icons.accessibility_new, size:14)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("12",
                            style:
                                googleFont(15, Colors.white, FontWeight.w400)),
                        Text("1",
                            style:
                                googleFont(15, Colors.white, FontWeight.w400)),
                      ],
                    ),
                    SizedBox(height: 20),
                    // InkWell(
                    //     onTap: () {},
                    //     child: Container(
                    //         width: MediaQuery.of(context).size.width / 4,
                    //         height: 50,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(25),
                    //           gradient: LinearGradient(
                    //               colors: [Colors.blue, Colors.lightBlue]),
                    //         ),
                    //         child: Center(
                    //           child: Text(
                    //             "Edit Profile",
                    //             style: googleFont(
                    //                 15, Colors.white, FontWeight.w500),
                    //           ),
                    //         ))),
                    SizedBox(height: 10),
                    Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.lightBlue]),
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
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                             itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, i) {
                            DocumentSnapshot tweetDoc = snapshot.data.docs[i];
                            return Card(
                            color: Theme.of(context).primaryColorDark,

                                child: ListTile(
                                  leading: CircleAvatar(
                                  backgroundColor: Colors.white,

                                    backgroundImage:
                                        NetworkImage(tweetDoc.data()['profilePic']),
                                  ),
                                  title: Row(
                                    children: [
                                      Text('${tweetDoc.data()['username']}'.toLowerCase(),
                                          style: googleFont(
                                              20, Colors.white, FontWeight.w400)),
                                      SizedBox(width:2),
                                      Text('@tweetMe',
                                          style: googleFont(
                                              15,Colors.grey, FontWeight.w300)),
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
                                                style: googleFont(20, Colors.white,
                                                    FontWeight.w300)),
                                          ),
                                        SizedBox(height: 10),
                                        if (tweetDoc.data()['type'] == 2)
                                        Container(
                                            width: double.infinity,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child:Image(
                                            image:
                                                NetworkImage(tweetDoc.data()['image']),),
                                          ),
                                        ),
                                        
                                        if (tweetDoc.data()['type'] == 3)
                                          Padding(
                                            padding:
                                        const EdgeInsets.only(top: 0.0, bottom: 8.0),
                                            child: Column(
                                                children: [
                                                  Text(tweetDoc.data()['tweet'],
                                                      style: googleFont(
                                                          20,
                                                          Colors.white,
                                                          FontWeight.w300)),
                                                  SizedBox(height: 15),

                                                  Container(
                                              width: double.infinity,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8.0),
                                                  child:Image(
                                              image:
                                                  NetworkImage(tweetDoc.data()['image']),),
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
                        })
                  ],
                ),
              ),
            ])) : Center(child: CircularProgressIndicator()));
  }
}
