import 'package:book_read/pages/home.dart';
import 'package:book_read/pages/landing_page.dart';
import 'package:book_read/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  Firestore db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));

    if (loggedIn) {
      return HomePage(
        auth: new Auth(),
      );
    } else {
      return LandingPage(
        auth: new Auth(),
      );
    }
  }
}
