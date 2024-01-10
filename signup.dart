import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:vchat/pages/home.dart';
import 'package:vchat/pages/login.dart';
import 'package:vchat/pages/verification.dart';
import "package:vchat/services/firebase_auth.dart";

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _p = TextEditingController();
  TextEditingController _cp = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _p.dispose();
    _cp.dispose();
  }

  final FirebaseAuthService _auth = FirebaseAuthService();

  // void signup() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  // const Center(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(19.0),
                  //     child: Text(
                  //       "V-Chat",
                  //       style: TextStyle(
                  //           fontFamily: "Poppins",
                  //           fontSize: 26.0,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  const Image(image: AssetImage("assets/images/signup.png")),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 112, 79, 230)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _email,
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          return "Email-ID enter pannunga!";
                        }
                        const pattern =
                            r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                        final regex = RegExp(pattern);
                        if (!regex.hasMatch(val)) {
                          return "Email-ID ya correct ah kudunga!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        border: OutlineInputBorder(
                            gapPadding: 4,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        labelText: "Email",
                        prefixIcon: Icon(Icons.group,
                            color: Color.fromARGB(255, 112, 79, 230)),
                        labelStyle: TextStyle(
                            fontFamily: "Poppins", fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: !_passwordVisible,
                      obscuringCharacter: "#",
                      controller: _p,
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          return "Password kudunga!";
                        }
                        if (val.length < 6) {
                          return "6 letters password kudunga";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: Color.fromARGB(255, 112, 79, 230),
                          padding: EdgeInsets.only(right: 10),
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        labelText: "Password",
                        prefixIcon: Icon(Icons.password,
                            color: Color.fromARGB(255, 112, 79, 230)),
                        labelStyle: TextStyle(
                            fontFamily: "Poppins", fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: !_passwordVisible,
                      obscuringCharacter: '#',
                      controller: _cp,
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          return "Password again kudunga!";
                        }
                        if (val.length < 6) {
                          return "6 letters password kudunga";
                        }
                        if (_p.text != _cp.text) {
                          return "Rendu Password-um match aahala";
                        }
                        return null;
                      },
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: Color.fromARGB(255, 112, 79, 230),
                          padding: EdgeInsets.only(right: 10),
                        ),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.password,
                            color: Color.fromARGB(255, 112, 79, 230)),
                        labelStyle: TextStyle(
                            fontFamily: "Poppins", fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _auth.SignUp(_email.text, _p.text)
                                .then((value) async {
                              if (value != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Verify()));
                              } else {}
                            });
                          } else {
                            return;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor:
                                const Color.fromARGB(255, 112, 79, 230)),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
