import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/services/user_repo.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:book_read/ui/splashscreen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:vibration/vibration.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key key}) : super(key: key);

  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserUpdateInfo userUpdateData;
  // Firestore _db = Firestore.instance;
  final db = DatabaseService();
  bool isDeleting = false;
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    User _userDb = Provider.of<User>(context);
    var userRepo = Provider.of<UserRepository>(context);
    bool hasVibration = Provider.of<dynamic>(context);

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: isDeleting == true
          ? SplashScreen()
          : Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
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
                              tag: 'hero',
                              child: Material(
                                color: Colors.transparent,
                                child: ProfilePicture(
                                  imgUrl: _userDb.profilePic,
                                  size: 60,
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (_) => SpinKitChasingDots(
                                        color: Colors.white,
                                        size: 50.0,
                                      ),
                                    );
                                    await db.uploadProfilePicture(user);

                                    Navigator.of(context).pop();
                                  },
                                  isSettings: true,
                                ),
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
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 50.0),
                      //   child: Divider(
                      //     color: Colors.black,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
                        child: ListTile(
                          title: Text('My e-mail'),
                          subtitle: Text(_userDb.email),
                          leading: Icon(Icons.mail),
                          onTap: () {
                            // if (hasVibration) {
                            //   Vibration.vibrate(duration: 200);
                            // }
                          },
                        ),
                      ),
                      // Divider(
                      //   color: Colors.black,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ListTile(
                          title: Text('Edit profile'),
                          leading: Icon(Icons.person_pin),
                          onTap: () async {
                            // if (hasVibration) {
                            //   Vibration.vibrate(duration: 200);
                            // }
                            Navigator.of(context).pushNamed('/editprofile');
                          },
                        ),
                      ),
                      // Divider(
                      //   color: Colors.black,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ListTile(
                          title: Text('Reset password'),
                          leading: Icon(Icons.lock),
                          onTap: () {
                            if (hasVibration) {
                              Vibration.vibrate(duration: 200);
                            }
                            userRepo.resetPassword(user.email);
                            Flushbar(
                              flushbarPosition: FlushbarPosition.BOTTOM,
                              margin: EdgeInsets.all(8.0),
                              borderRadius: 10,
                              duration: Duration(seconds: 3),
                              icon:
                                  Icon(Icons.check_circle, color: Colors.green),
                              message:
                                  'Password reset email will be sent. Check inbox or spam mail.',
                            )..show(context);
                          },
                        ),
                      ),
                      // Divider(
                      //   color: Colors.black,
                      // ),
                      ListTile(
                        title: Text('Sign Out'),
                        leading: Icon(Icons.exit_to_app),
                        onTap: () {
                          if (hasVibration) {
                            Vibration.vibrate(duration: 200);
                          }

                          // auth.signOut();
                          if (_userDb.provider == 'google') {
                            userRepo.signOutGoogle();
                          } else {
                            userRepo.signOut();
                          }
                          Navigator.of(context).popUntil(
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
                      // Divider(
                      //   color: Colors.black,
                      // ),
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
                            if (hasVibration) {
                              Vibration.vibrate(duration: 200);
                            }
                            setState(() {
                              isDeleting = true;
                            });
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
                                          if (hasVibration) {
                                            Vibration.vibrate(duration: 200);
                                          }

                                          Navigator.of(context).popUntil(
                                              ModalRoute.withName('/'));

                                          await user.delete();
                                        },
                                      ),
                                      FlatButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            if (hasVibration) {
                                              Vibration.vibrate(duration: 200);
                                            }
                                            setState(() {
                                              isDeleting = false;
                                            });
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
              ),
            ),
    );
  }
}
