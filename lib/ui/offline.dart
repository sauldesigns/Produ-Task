import 'package:flutter/material.dart';

class OfflineMessage extends StatelessWidget {
  const OfflineMessage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('You are offline',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color.fromRGBO(0, 0, 0, 0.7),
              )),
          SizedBox(height: 15.0),
          Text(
            'It seems there is a problem with your connection. Please check your network status.',
            style: TextStyle(fontSize: 17, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
