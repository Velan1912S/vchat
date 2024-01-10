import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:vchat/helper/helper.dart";
import 'package:vchat/pages/login.dart';
import 'package:vchat/services/firebase_auth.dart';
//if logged in: redirects to home

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool _isLoggedIn = false;
  String? _email;
  bool _gs = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      print('User is currently signed out!');
    } else {
      _isLoggedIn = true;
      _email = FirebaseAuth.instance.currentUser?.email;

      _gs = isGoogleSignIn(FirebaseAuth.instance.currentUser!);

      print('User is signed in!');
    }
  }

  bool isGoogleSignIn(User user) {
    return user.providerData.any(
        (userInfo) => userInfo.providerId == GoogleAuthProvider.PROVIDER_ID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 75,
          backgroundColor: Color.fromARGB(255, 134, 110, 220),
          title: Text(
            "  V-CHAT",
            style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
          ),
        ),
        body: _isLoggedIn
            ? Center(
                child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  _gs
                      ? CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              "${FirebaseAuth.instance.currentUser?.photoURL}"))
                      : SizedBox(),
                  Text("$_email"),
                  ElevatedButton(
                    onPressed: () {
                      _gs
                          ? FirebaseAuthService().signOutFromGoogle()
                          : FirebaseAuthService().SignOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => login()));
                      final snackBar = SnackBar(
                        content: const Text('Signed-Out Successfully!'),
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Text("Logout"),
                  ),
                ],
              ))
            : Text("Error"),
        floatingActionButton: TextButton(
          child: Text("Add User"),
          onPressed: () {},
        ),
      ),
    );
  }
}
