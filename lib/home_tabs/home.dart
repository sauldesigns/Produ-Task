import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);

  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Home'),
      ),
    );
  }
}
