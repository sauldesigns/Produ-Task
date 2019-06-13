import 'package:book_read/pages/book.dart';
import 'package:book_read/services/database.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);

  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('get book'),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: Text(
                      'Loading...',
                      textAlign: TextAlign.center,
                    ),
                  ));
          var _bookData = await db.getBookData('Lord of The Rings');
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BookDataPage(
                    bookData: _bookData,
                  ),
            ),
          );
        },
      ),
    );
  }
}
