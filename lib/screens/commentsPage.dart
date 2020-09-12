import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterClone/utils/googleFont.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class CommentPage extends StatefulWidget {
  final String tid;
  CommentPage({this.tid});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  addComments() async {
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await db.doc(user.uid).get();
    tweetCol.doc(widget.tid).collection('comments').doc().set({
      'comments': commentsController.text,
      'username': userDoc.data()['username'],
      'profilePic': userDoc.data()['profilePic'],
      'uid': userDoc.data()['uid'],
      'time': DateTime.now(),
    });
    DocumentSnapshot userCount = await tweetCol.doc(widget.tid).get();
    tweetCol
        .doc(widget.tid)
        .update({'commentCount': userCount.data()['commentCount'] + 1});
        
    commentsController.clear();
  }

  final commentsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
      
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text("CommentsPage", style: googleFont(20)),
        // ),
        body: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    tweetCol.doc(widget.tid).collection('comments').snapshots(),

                /// returns all the snapshots
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, i) {
                        DocumentSnapshot commentsDoc = snapshot.data.docs[i];
                        return Card(
                          color: Colors.grey[100],
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  commentsDoc.data()['profilePic']),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        commentsDoc.data()['username'],
                                        style: googleFont(18,Colors.blue),
                                      ),
                              
                              Text('@tweetMe',
                                  style: googleFont(
                                      15,Colors.grey, FontWeight.w300)),
                            
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    commentsDoc.data()['comments'],
                                    style: googleFont(18,Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Text(timeAgo
                                .format(commentsDoc.data()['time'].toDate())
                                .toString()),
                          ),
                        );
                      });
                },
              ),
            ),
            Divider(),
            ListTile(
              title: TextFormField(
                 style:googleFont(18, Colors.white),
                controller: commentsController,
                decoration: InputDecoration(
                  hintText: "Add Comment",
                  hintStyle: googleFont(18, Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              trailing: OutlineButton(
                onPressed: () {
                  addComments();
                  print(widget.tid);
                },
                borderSide: BorderSide.none,
                child: Text("Tweet", style:  googleFont(16, Colors.white)
                ),
                

              ),
              leading: Icon(Icons.add_comment, color:Colors.white),
            ),
          ],
        ),
      ),
    ));
  }
}
