import 'package:flutter/material.dart';

class BooksTab extends StatefulWidget {
  BooksTab({Key key}) : super(key: key);

  _BooksTabState createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Books'),
      ),
    );
  }
}
