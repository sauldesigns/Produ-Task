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
                            onTap: () {},
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        title: Text('Edit profile'),
                        leading: Icon(Icons.person_pin),
                        onTap: () {},
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
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
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        title: Text('Sign Out'),
                        leading: Icon(Icons.exit_to_app),
                        onTap: () {
                          auth.signOut();
                        },
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
