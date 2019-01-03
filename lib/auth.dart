import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmfx/screens/home.dart';

final GoogleSignIn _signIn = new GoogleSignIn();

abstract class BaseAuth {
  Future<FirebaseUser> currentUser();
  Future<FirebaseUser> signIn(BuildContext context);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences prefs;
  final Firestore firestore = Firestore.instance;

  Future<FirebaseUser> signIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _signIn.signIn();
    GoogleSignInAuthentication gsa = await googleSignInAccount.authentication;
    prefs = await SharedPreferences.getInstance();

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gsa.idToken, accessToken: gsa.accessToken);

    print("user:" + user.toString());

    if (user != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();

      final List<DocumentSnapshot> documents = result.documents;

      if (documents.length == 0) {
        Firestore.instance.collection('users').document(user.uid).setData({
          "nickname": user.displayName,
          "photoUrl": user.photoUrl,
          "id": user.uid
        });

        await prefs.setString('id', user.uid);
        await prefs.setString('nickname', user.displayName);
        await prefs.setString('photoUrl', user.photoUrl);
      } else {
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
      return user;
    } else {
      return null;
    }
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user != null ? user : null;
  }

  Future<void> signOut() async {
    _signIn.signOut();
    return _auth.signOut();
  }
}
