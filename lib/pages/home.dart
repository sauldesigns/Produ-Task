// import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/home_tabs/home.dart';
import 'package:book_read/models/category.dart';
import 'package:book_read/services/auth.dart';
import 'package:book_read/services/database.dart';
// import 'package:book_read/ui/offline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  _HomePageState createState() => _HomePageState();
}

// this gets the database data such as data of user logged in,
// as well as returning data from database of what categories that user has created.
class _HomePageState extends State<HomePage> {
  final db = DatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: StreamProvider<List<Category>>.value(
        value: db.streamWeapons(user),
        child: HomeTab(scaffoldKey: _scaffoldKey),
      ),
    );
  }
}
