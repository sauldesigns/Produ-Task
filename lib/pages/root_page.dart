import 'package:book_read/enums/auth.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/pages/home.dart';
import 'package:book_read/pages/landing_page.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/services/user_repo.dart';
import 'package:book_read/ui/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  _RootPageState createState() => _RootPageState();
}

// this helps define the state the app should be in depending if
// user was previously logged in, if no user is logged in, or if
// user is being authenthicated. 
class _RootPageState extends State<RootPage> {
  Firestore db = Firestore.instance;
  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<FirebaseUser>(context);
    var user = Provider.of<UserRepository>(context);
    switch (user.status) {
      case Status.Uninitialized:
        return SplashScreen();
      case Status.Unauthenticated:
        return LandingPage();
      case Status.Authenticating:
        return SplashScreen();
      case Status.Authenticated:
        return StreamProvider<User>.value(
            value: _db.streamHero(_user.uid),
            initialData: User.initialData(),
            child: HomePage());
    }

    return Container();

    //   bool loggedIn = user != null;
    //   if (loggedIn) {
    // return StreamProvider<User>.value(
    //     value: _db.streamHero(user.uid),
    //     initialData: User.initialData(),
    //     child: HomePage(
    //       auth: new Auth(),
    //     ));
    //   } else {
    //     return LandingPage(
    //       auth: new Auth(),
    //     );
    //   }
  }
}
