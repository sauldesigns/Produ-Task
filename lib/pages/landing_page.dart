import 'package:book_read/services/auth.dart';
import 'package:book_read/ui/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Firestore db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    return Scaffold(
      // backgroundColor: Color.fromRGBO(255, 218, 185, 1),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 170, bottom: 150),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Rea:bor',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                            'Share your favorite books and inspiration with your neighbors')),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: RoundedButton(
                icon: Icons.mail,
                title: 'Continue with email',
                onClick: () {
                  Navigator.of(context).pushNamed('/login');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: RoundedButton(
                icon: Icons.alternate_email,
                title: 'Continue with Facebook',
                onClick: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: RoundedButton(
                icon: Icons.account_box,
                title: 'Continue with Google',
                onClick: () async {
                  FirebaseUser user = await widget.auth.signInGoogle();
                  DocumentSnapshot snap =
                      await db.collection('users').document(user.uid).get();
                  if (snap.data == null) {
                    var data = {
                      'displayName': user.displayName.replaceAll(' ', ''),
                      'email': user.email,
                      'bio': '',
                      'fname': '',
                      'lname': '',
                      'provider': 'google',
                      'profile_pic': user.photoUrl,
                      'uid': user.uid
                    };
                    db.collection('users').document(user.uid).setData(data);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: Text('A new member? Sign Up')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
