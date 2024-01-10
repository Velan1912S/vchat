import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:vchat/pages/home.dart';
import 'package:vchat/services/firebase_auth.dart';
import 'signup.dart';
import "package:firebase_auth/firebase_auth.dart";
//check whether user loggedin or not

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  Color myColor = const Color(0x8a6bbe);
  bool _passwordVisible = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _p = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _p.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              children: [
                const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(19.0),
                      child: Text(
                        "V-Chat",
                        style: TextStyle(
                            color: Color.fromARGB(255, 112, 79, 230),
                            fontSize: 26,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const Image(
                  image: AssetImage("assets/images/login.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return "Email-ID kudunga";
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
                    decoration: const InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      prefixIcon: Icon(Icons.people,
                          color: Color.fromARGB(255, 112, 79, 230)),
                      labelText: "EMAIL",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _p,
                    obscureText: !_passwordVisible,
                    keyboardType: TextInputType.number,
                    validator: (String? val) {
                      return val!.isEmpty ? "Password enter pannunga" : null;
                    },
                    obscuringCharacter: "#",
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      prefixIcon: Icon(Icons.password,
                          color: Color.fromARGB(255, 112, 79, 230)),
                      // hintText: "PASSWORD",
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
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
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await FirebaseAuthService()
                            .SignIn(_email.text, _p.text)
                            .then((value) {
                          if (value != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => home()));
                          }
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
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: "Poppins"),
                    ),
                  ),
                ),
                const Row(children: <Widget>[
                  Expanded(
                      child: Divider(
                    indent: 25.0,
                    endIndent: 10.0,
                  )),
                  Text(
                    "or",
                    style: TextStyle(
                        fontFamily: "Poppins", fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: Divider(
                    indent: 10.0,
                    endIndent: 25.0,
                  )),
                ]),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SignInButton(Buttons.google,
                        text: "Sign in with Google", onPressed: () async {
                      await FirebaseAuthService()
                          .signInWithGoogle()
                          .then((value) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => home()));
                        final snackBar = SnackBar(
                          content: const Text('Signed-in Successfully'),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    children: [
                      Text(
                        "Don't have account?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            color: Color.fromARGB(255, 112, 79, 230)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const signup()));
                          },
                          child: Text("Sign up here!")),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
