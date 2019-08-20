import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/home_tabs/settings.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

class DefaultTopAppBar extends StatelessWidget {
  final dynamic connectionStatus;
  final User userDb;
  final db;
  const DefaultTopAppBar({Key key, this.connectionStatus, this.userDb, this.db})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 65,
        bottom: 0,
        left: 20,
        right: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // this will display offline mode, if connectivity is offline,
          // to let user know if data is current, or outdated.
          connectionStatus == ConnectivityStatus.Offline
              ? Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Offline Mode',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: Container(),
          ),
          // this is user's profile picture located at the
          // top right, which functions as the way to go to settings page.
          Hero(
            tag: 'hero',
            child: Material(
              color: Colors.transparent,
              // this adds the bounce animation, when page is first loaded, or restored
              // from previous page.
              child: ControlledAnimation(
                  duration: Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.elasticOut,
                  builder: (context, animation) {
                    return Transform.scale(
                      scale: animation,
                      child: ProfilePicture(
                        size: 25,
                        imgUrl: userDb.profilePic,
                        onTap: () {
                          // navigates to settings page, and puses the user data
                          // stream over to the new page.
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StreamProvider<User>.value(
                                value: db.streamHero(userDb.uid),
                                initialData: userDb,
                                child: SettingsTab(),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
