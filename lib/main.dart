//import 'package:flutter/material.dart';
//
//import 'home_screen.dart';
//
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Chat App',
//      theme: ThemeData(
//        primaryColor: Colors.lime,
//        accentColor: Color(0xFFFEF9EB)
//      ),
//      home: HomeScreen(),
//    );
//  }
//}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/resources/firebase_repository.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/loginScreen.dart';
import 'package:flutter_app/screens/search_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseRepository _repository = FirebaseRepository();


  @override
  Widget build(BuildContext context) {
//    _repository.signOut();
    return  MaterialApp(
      title: "Chat App",
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/search_screen': (context) =>SearchScreen()
      },
      home: FutureBuilder(
        future: _repository.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
