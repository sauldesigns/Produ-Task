import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key key}) : super(key: key);

  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 50.0),
      child: Center(
        child: StreamBuilder<User>(
            stream: db.streamHero(user.uid),
            builder: (context, snapshot) {
              var user = snapshot.data;
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ProfilePicture(
                            imgUrl: user.profilePic,
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
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  user.username,
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
                        subtitle: Text(user.email),
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
                        var snack = SnackBar(
                          content: Text('Password reset e-mail sent'),
                        );
                        Scaffold.of(context).showSnackBar(snack);
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
                      },
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
