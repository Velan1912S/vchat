import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:vchat/pages/login.dart';
import 'package:vchat/services/firebase_auth.dart';
import 'signup.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  String? email;
  bool _isVerified = false;
  Timer? timer;
  final sn = SnackBar(
    content: const Text('Check Email Inbox to verfiy!'),
    action: SnackBarAction(
      label: 'Okay',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  final v = SnackBar(
    content: const Text('Verified Successfully!'),
    action: SnackBarAction(
      label: '',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = FirebaseAuth.instance.currentUser?.email;
    _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  }

  // check() async {
  //   // int i = 0;
  //   // await FirebaseAuth.instance.currentUser!.reload();
  //   setState(() {
  //     _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  //   });
  //   return _isVerified;
  //   // print(i);
  // }

  Future check() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (_isVerified) timer?.cancel();
  }

  Redirect() {
    if (_isVerified) {
      FirebaseAuthService().SignOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image(image: AssetImage("assets/images/verfiy.png")),
            SizedBox(
              height: 50.0,
            ),
            Text("Given Mail-ID : $email"),
            SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (!_isVerified) {
                    await FirebaseAuthService().VerifyLink();
                    ScaffoldMessenger.of(context).showSnackBar(sn);

                    timer = Timer.periodic(Duration(seconds: 3), (timer) async {
                      await check(); // Wait for the check to complete
                      if (_isVerified) {
                        timer.cancel();
                        ScaffoldMessenger.of(context).showSnackBar(v);
                        FirebaseAuthService()
                            .SignOut(); // Show verification Snackbar
                        Redirect(); // Redirect only when verified
                      }
                    });
                  } else {
                    Redirect(); // If already verified, redirect immediately
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: const Color.fromARGB(255, 112, 79, 230)),
                child: const Text(
                  "Send Verification Link",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
