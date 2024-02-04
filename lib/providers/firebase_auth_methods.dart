import 'package:cryptocoin/custom_widgets/showCustomFlushBar.dart';
import 'package:cryptocoin/pages/auth_pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:sizer/sizer.dart';

import '../main.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  // STATE PERSISTENCE
  Stream<User?> get authState => _auth.authStateChanges();

// EMAIL & PASSWORD SIGN UP
  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(username);
      await userCredential.user
          ?.updatePhotoURL('https://imgur.com/sfTdXmg.png');
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid);
      final newUser = {
        "name": username,
        "idetifier": email,
        "accountCreatedAt": DateTime.now(),
        "profilepicture": 'https://imgur.com/sfTdXmg.png',
        "currency": 'eur'
      };
      await docUser.set(newUser);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            maintainState: false, builder: (context) => const AuthWrapper()),
      );
    } on FirebaseAuthException catch (e) {
      showCustomFlushBar(
          context,
          e.toString().replaceFirst(new RegExp(r'[.]'), ""),
          Icons.warning_rounded);
    }
  }

  // EMAIL & PASSWORD LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            maintainState: false, builder: (context) => const AuthWrapper()),
      );
    } on FirebaseException catch (e) {
      showCustomFlushBar(
          context,
          e.toString().replaceFirst(new RegExp(r'[.]'), ""),
          Icons.warning_rounded);
    }
  }

//Singout
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      Flushbar(
        icon: const Icon(
          Icons.email_outlined,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: const Color(0xFF0277BD),
        duration: const Duration(seconds: 4),
        message: "This email is already registered.",
        messageSize: 18,
        titleText: const Text("Flushbar with Icon.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ).show(context);
    }
  }
}
