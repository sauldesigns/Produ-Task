import 'package:book_read/models/user.dart';
import 'package:book_read/pages/home.dart';
import 'package:book_read/pages/landing_page.dart';
import 'package:book_read/services/auth.dart';
import 'package:book_read/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  Firestore db = Firestore.instance;
  final _db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    if (loggedIn) {
      return StreamProvider<User>.value(
          value: _db.streamHero(user.uid),
          initialData: User.initialData(),
          child: HomePage(
            auth: new Auth(),
          ));
    } else {
      return LandingPage(
        auth: new Auth(),
      );
    }
  }
}
