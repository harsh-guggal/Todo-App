import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth/authscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Guggal Todo",
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
      theme: ThemeData(
        primaryColor: Colors.purple,
        primaryColorLight: Colors.lightBlueAccent,
      ),
    );
  }
}
