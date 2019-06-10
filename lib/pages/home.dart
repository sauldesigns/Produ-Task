import 'package:book_read/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Rea:bor'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(user.uid),
            RaisedButton(
              child: Text('Signout'),
              onPressed: () {
                widget.auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
