import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmfx/screens/home.dart';

final GoogleSignIn _signIn = GoogleSignIn();

abstract class BaseAuth {
  Future<User?> currentUser();
  Future<User?> signIn(BuildContext context);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences? prefs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> signIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _signIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }
      
      GoogleSignInAuthentication gsa = await googleSignInAccount.authentication;
      prefs = await SharedPreferences.getInstance();

      final credential = GoogleAuthProvider.credential(
        idToken: gsa.idToken,
        accessToken: gsa.accessToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      print("user: ${user.toString()}");

      if (user != null) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: user.uid)
            .get();

        final List<QueryDocumentSnapshot> documents = result.docs;

        if (documents.isEmpty) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            "nickname": user.displayName ?? '',
            "photoUrl": user.photoURL ?? '',
            "id": user.uid
          });

          await prefs?.setString('id', user.uid);
          await prefs?.setString('nickname', user.displayName ?? '');
          await prefs?.setString('photoUrl', user.photoURL ?? '');
        } else {
          final docData = documents[0].data() as Map<String, dynamic>;
          await prefs?.setString('id', docData['id']);
          await prefs?.setString('nickname', docData['nickname']);
          await prefs?.setString('photoUrl', docData['photoUrl']);
          if (docData.containsKey('aboutMe')) {
            await prefs?.setString('aboutMe', docData['aboutMe']);
          }
        }
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Error during sign in: $e");
      return null;
    }
  }

  Future<User?> currentUser() async {
    User? user = _auth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    await _signIn.signOut();
    return _auth.signOut();
  }
}
