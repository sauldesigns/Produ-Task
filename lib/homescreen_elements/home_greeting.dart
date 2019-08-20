import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/models/user.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

class GreetingHomeScreen extends StatelessWidget {
  final User userDb;
  final dynamic connectionStatus;
  const GreetingHomeScreen({Key key, this.userDb, this.connectionStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ControlledAnimation(
                duration: Duration(milliseconds: 600),
                delay: Duration(milliseconds: 300),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOutQuint,
                builder: (context, animation) {
                  return Transform.scale(
                    scale: animation,
                    child: RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'Hello ${userDb.fname == '' ? userDb.username : userDb.fname},',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '\nthis is your task list.',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ]),
                    ),
                  );
                }),
          ),
          // lets the user know that device is offline, and data may not be up-to-date
          connectionStatus == ConnectivityStatus.Offline
              ? Padding(
                  padding: const EdgeInsets.only(left: 40.0, bottom: 15.0),
                  child: Text(
                    'Device is offline, data may not be up-to-date.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                )
              : Container()
        ]);
  }
}
