import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:flutter_spinkit/flutter_spinkit.dart';
googleFont(double size, [Color color, FontWeight fw]) {
  return GoogleFonts.montserrat(fontSize: size, fontWeight: fw, color: color);
}

var defaultImage =
    'https://cdn.pixabay.com/photo/2013/07/13/10/07/man-156584__340.png';

final CollectionReference db = FirebaseFirestore.instance.collection("Users");

final CollectionReference tweetCol =
    FirebaseFirestore.instance.collection("Tweets");

final StorageReference tweetImg =
    FirebaseStorage.instance.ref().child("ImageOfTweet");



const textInputDecoration = InputDecoration(
 
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);



class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      color:Colors.brown[700],
      child:Center(
        child:SpinKitThreeBounce(
          color:Colors.white70,
          size:50,
        ),
      ),
    );
  }
}