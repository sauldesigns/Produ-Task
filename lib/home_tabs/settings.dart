import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
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
  void initState() {
    super.initState();
  }

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
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: InkWell(
                              enableFeedback: true,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/1024px-Circle-icons-profile.svg.png'),
                              ),
                            ),
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(user.bio),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        title: Text('Placeholder'),
                        leading: Icon(Icons.check_box),
                        onTap: () {},
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        title: Text('Placeholder'),
                        leading: Icon(Icons.check_box),
                        onTap: () {},
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
