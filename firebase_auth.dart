import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // User? user = FirebaseAuth.instance.currentUser;
  Future<User?> SignUp(String e, String p) async {
    try {
      // Timer.periodic(
      //     (Duration(seconds: 7)),
      //     (timer) => FirebaseAuth.instance.currentUser
      //         ?.sendEmailVerification()
      //         .then((value) => SnackBar(content: Text("Verified"))));
      // if (user != null && !user!.emailVerified) {
      // await user!.sendEmailVerification();
      // }
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(email: e, password: p);

      const Duration(seconds: 10);
      return credential.user;
    } catch (e) {}
    return null;
  }

  Future<User?> SignIn(String e, String p) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(email: e, password: p);
      return credential.user;
    } catch (e) {}
    return null;
  }

  void SignOut() {
    FirebaseAuth.instance.signOut();
  }

  Future VerifyLink() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
