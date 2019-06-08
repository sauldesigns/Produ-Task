import 'package:book_read/pages/landing_page.dart';
import 'package:book_read/pages/login.dart';
import 'package:book_read/pages/sign_up.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Read',
      // theme: ThemeData(
      //     textTheme: TextTheme(
      //   title: TextStyle(color: Colors.black),
      //   button: TextStyle(color: Colors.black),
      // )),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage()
      },
    );
  }
}
