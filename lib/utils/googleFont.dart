import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

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
