import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import 'package:twitterClone/utils/googleFont.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  String uid;
  String profilePic;
  String username;
  bool userInfo = false;



  final TextEditingController _usernameController = TextEditingController();

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
              child: Text("camera", style: googleFont(20, Color(0xFF13536E))),
            ),
            SimpleDialogOption(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: Text("gallery", style: googleFont(20, Color(0xFF13536E))),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("cancel", style: googleFont(20, Color(0xFF13536E))),
            ),
          ]);
        });
  }

  File imgPath;
  String downloadUrl;
  //bool uploading = false;

  Future uploadPic() async {
    // ignore: await_only_futures

    StorageUploadTask _storeUpload = tweetImg.child(uid).putFile(imgPath);
    StorageTaskSnapshot _storageTask = await _storeUpload.onComplete;
    String downloadUrl = await _storageTask.ref.getDownloadURL();
    return downloadUrl;
  }

  getImage(ImageSource imgSource) async {
    try {
      final image = await ImagePicker().getImage(source: imgSource);
      setState(() {
        imgPath = File(image.path);
        print(imgPath);
      });
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
    }
  }



  @override
  void initState() {
    
  

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return userInfo == true
        ? Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Icon(Icons.person_add),
                    SizedBox(width: 10),
                    Text(
                      "Update Profile",
                      style: googleFont(
                          20, Theme.of(context).primaryColor, FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20.0, right: 20),
                    child: TextFormField(
                      //initialValue: '',
                      controller: _usernameController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: false,
                      onChanged: (value) {
                       
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter a Name";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Username",
                        labelStyle:
                            googleFont(15, Colors.purple, FontWeight.w300),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon:
                            Icon(Icons.person_add, color: Colors.purple),
                      ),
                    )),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: InkWell(
                    onTap: () {
                      optionDialog();
                    },
                    child: CircleAvatar(
                      backgroundImage: downloadUrl == null
                          ? NetworkImage(profilePic)
                          : NetworkImage(downloadUrl),
                      backgroundColor: Colors.purple,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                    color: Colors.purple[400],
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        

                        Navigator.pop(context);
                      }
                    }),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
