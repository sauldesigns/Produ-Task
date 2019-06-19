import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/pages/edit_profile.dart';
import 'package:book_read/pages/home.dart';
import 'package:book_read/pages/landing_page.dart';
import 'package:book_read/pages/login.dart';
import 'package:book_read/pages/root_page.dart';
import 'package:book_read/pages/sign_up.dart';
import 'package:book_read/services/auth.dart';
import 'package:book_read/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        StreamProvider<ConnectivityStatus>.controller(
          builder: (context) =>
              ConnectivityService().connectionStatusController,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Read',

        // theme: ThemeData(
        //     textTheme: TextTheme(
        //   title: TextStyle(color: Colors.black),
        //   button: TextStyle(color: Colors.black),
        // )),
        initialRoute: '/',
        routes: {
          '/': (context) => RootPage(),
          '/landingpage': (context) => LandingPage(
                auth: new Auth(),
              ),
          '/login': (context) => LoginPage(
                auth: new Auth(),
              ),
          '/signup': (context) => SignUpPage(auth: new Auth()),
          '/home': (context) => HomePage(
                auth: new Auth(),
              ),
          '/editprofile': (context) => EditProfilePage()
        },
      ),
    );
  }
}
