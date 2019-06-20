import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key key}) : super(key: key);

  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var _userDb = Provider.of<User>(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 50.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "profile_pic",
                    child: ProfilePicture(
                      imgUrl: _userDb.profilePic,
                      size: 60,
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  content: Text(
                                    'Uploading...',
                                    textAlign: TextAlign.center,
                                  ),
                                ));
                        await db.uploadProfilePicture(user.uid);
                        Navigator.of(context).pop();
                      },
                      isSettings: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _userDb.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text("My Account")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: ListTile(
                title: Text('My e-mail'),
                subtitle: Text(_userDb.email),
                leading: Icon(Icons.mail),
                onTap: () {},
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text('Edit profile'),
              leading: Icon(Icons.person_pin),
              onTap: () {
                Navigator.of(context).pushNamed('/editprofile');
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text('Reset password'),
              leading: Icon(Icons.lock),
              onTap: () {
                auth.sendPasswordResetEmail(email: user.email);
                Flushbar(
                  flushbarPosition: FlushbarPosition.TOP,
                  aroundPadding: EdgeInsets.all(8),
                  borderRadius: 10,
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  message:
                      'Password reset email will be sent. Check inbox or spam mail.',
                )..show(context);
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text('Sign Out'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                auth.signOut();
                if (_userDb.provider == 'google') {
                  _googleSignIn.signOut();
                }
              },
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Delete Account'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text('Delete account'),
                          content: Text(
                              'Are you sure you want to delete this account. All content will be deleted and cannot be retrieved once deleted.'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Delete'),
                              onPressed: () async {
                                db.deleteUser(user.uid);
                                FirebaseUser _user = await auth.currentUser();
                                _user.delete();
                                if (_userDb.provider == 'google') {
                                  _googleSignIn.signOut();
                                }
                              },
                            ),
                            FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
