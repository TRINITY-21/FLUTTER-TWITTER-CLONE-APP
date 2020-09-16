import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitterClone/utils/googleFont.dart';

class AddTweetPage extends StatefulWidget {
  AddTweetPage({Key key}) : super(key: key);

  @override
  _AddTweetPageState createState() => _AddTweetPageState();
}

class _AddTweetPageState extends State<AddTweetPage> {
  final TextEditingController _textEditingController = TextEditingController();

  File imgPath;
  bool uploading = false;

  getImage(ImageSource imgSource) async {
    try {
      final image = await ImagePicker().getImage(source: imgSource);
      setState(() {
        imgPath = File(image.path);
      });
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
    }
  }

  optionDialog() {
    return showDialog(
      useSafeArea: true,
      barrierColor: Color(0xFF031A29),
        context: context,
        builder: (context) {
          return SimpleDialog(children: [
            SimpleDialogOption(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              child: ListTile(
                leading: Icon(Icons.camera),
                title: Text("camera", style: googleFont(20,Color(0xFF13536E))),

              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: ListTile(
                leading: Icon(Icons.folder_shared),
                title: Text("gallery", style: googleFont(20,Color(0xFF13536E))),

              ),            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(Icons.cancel),
                title: Text("cancel", style: googleFont(20,Color(0xFF13536E))),

              ),            ),
          ]);
        });
  }

  /////////////Upload pics

  Future uploadPic(String id) async {
    // ignore: await_only_futures
    StorageUploadTask _storeUpload = await tweetImg.child(id).putFile(imgPath);
    StorageTaskSnapshot _storageTask = await _storeUpload.onComplete;
    String downloadUrl = await _storageTask.ref.getDownloadURL();
    return downloadUrl;
  }

  ////////////////  Post Tweet
  postTweet() async {
    setState(() {
      uploading = true;
    });
    // ignore: await_only_futures
    var user = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await db.doc(user.uid).get();
    final doc = await tweetCol.get();
    final len = doc.docs.length;

    if (_textEditingController.text != '' && imgPath == null) {
      tweetCol.doc("Tweet $len").set({
        'username': userDoc.data()['username'],
        'profilePic': userDoc.data()['profilePic'],
        'uid': user.uid,
        'tid': 'Tweet $len',
        'tweet': _textEditingController.text,
        'likes': [],
        'commentCount': 0,
        'shares': 0,
        'type': 1
      });

      Navigator.pop(context);
    }

    if (_textEditingController.text == '' && imgPath != null) {
      String imageUrl = await uploadPic('Tweet $len');
      tweetCol.doc("Tweet $len").set({
        'username': userDoc.data()['username'],
        'profilePic': userDoc.data()['profilePic'],
        'uid': user.uid,
        'tid': 'Tweet $len',
        'image': imageUrl,
        'likes': [],
        'commentCount': 0,
        'shares': 0,
        'type': 2
      });

      Navigator.pop(context);
    }

    if (_textEditingController.text != '' && imgPath != null) {
      String imageUrl = await uploadPic('Tweet $len');
      tweetCol.doc("Tweet $len").set({
        'username': userDoc.data()['username'],
        'profilePic': userDoc.data()['profilePic'],
        'uid': user.uid,
        'tid': 'Tweet $len',
        'tweet': _textEditingController.text,
        'image': imageUrl,
        'likes': [],
        'commentCount': 0,
        'shares': 0,
        'type': 3
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    // final userDoc = Provider.of<UserDocModel>(context);

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            postTweet();
          },
           backgroundColor:  Color(0xFF13536E),
          child:Icon(Icons.publish,size:40),
        ),
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, size: 20.0)),
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Add Tweet",
                    style: googleFont(20, Colors.white, FontWeight.w500)),
                     Image(
                image: AssetImage('assets/logo.png'),
               //width: 50,
                height: 45,
              ),
              ],
            ),
          ),
          actions: [
            InkWell(
                onTap: () {
                  optionDialog();
                },
                child: Icon(
                  Icons.add_a_photo,
                  size: 40,
                  color: Colors.white,
                ))
          ],
          
        ),
        body: uploading == false
            ? Column(
                children: [
                  Expanded(
                    child: TextField(
                      style: googleFont(20, Colors.white, FontWeight.w200),
                      controller: _textEditingController,
                      maxLines: null,
                      
                      decoration: InputDecoration(
                        filled: true,

                        focusColor: Colors.grey,
                        
                        labelText: "What is happening now",
                        labelStyle:
                            googleFont(20, Colors.white, FontWeight.w300),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  imgPath == null
                      ? Container()
                      : MediaQuery.of(context).viewInsets.bottom > 0
                          ? Container()
                          : Image(
                              width: 400,
                              height: 300,
                              image: FileImage(imgPath),
                            )
                ],
              )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
                SizedBox(height: 10),
                Center(
                    child: Text(
                    "Uploading please wait",
                    style: googleFont(10, Colors.white,),
                  
                      ),
                   
                    ),
                    
              ],
            )
                );
  }
}
