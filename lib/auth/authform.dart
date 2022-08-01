import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytodo/main.dart';

import '../models/usermodel.dart';
import '../screens/home.dart';

// ignore: camel_case_types
class authform extends StatefulWidget {
  const authform({Key? key}) : super(key: key);

  @override
  State<authform> createState() => _authformState();
}

class _authformState extends State<authform> {
  final _formkey = GlobalKey<FormState>();
  bool isLogin = false;

  final usernamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();

    final auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    if (user != null) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()));
      });
    }
  }

  startAuthentication() async {
    if (_formkey.currentState?.validate() ?? true) {
      if (isLogin) {
        auth
            .signInWithEmailAndPassword(
                email: emailcontroller.text, password: passwordcontroller.text)
            .then((value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                ));
      } else {
        await auth
            .createUserWithEmailAndPassword(
                email: emailcontroller.text, password: passwordcontroller.text)
            .then((value) => saveUsertoFirestore());
      }
    } else {
      Fluttertoast.showToast(msg: "Form is not validated");
    }
  }

  saveUsertoFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.password = passwordcontroller.text;
    userModel.username = usernamecontroller.text;

    await firestore
        .collection("Users")
        .doc(user.uid)
        .set(userModel.toMap())
        .then((value) => Future.delayed(Duration.zero, () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home()));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          SizedBox(
            height: 200,
            child: Image.asset("assets/todo.png"),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Form(
              child: Column(
                children: [
                  if (!isLogin)
                    TextFormField(
                      controller: usernamecontroller,
                      keyboardType: TextInputType.text,
                      key: const ValueKey("username"),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Incorrect Username';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.purple, width: 3),
                              borderRadius: BorderRadius.circular(15)),
                          labelText: "Enter Username",
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.purple, width: 3),
                              borderRadius: BorderRadius.circular(15)),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          )),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey("email"),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.purple, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Enter Email",
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.purple, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordcontroller,
                    keyboardType: TextInputType.visiblePassword,
                    key: const ValueKey("password"),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Incorrect password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.purple, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Enter Password",
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.purple, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: startAuthentication,
                      child: isLogin
                          ? const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            )
                          : const Text(
                              "SignUp",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: isLogin
                        ? const Text(
                            "Not a member?",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        : const Text(
                            "Already a member?",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
