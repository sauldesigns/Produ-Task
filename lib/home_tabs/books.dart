import 'package:book_read/ui/custom_search_delegate.dart';
import 'package:flutter/material.dart';

class BooksTab extends StatefulWidget {
  BooksTab({Key key}) : super(key: key);

  _BooksTabState createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Search',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          )
        ],
      ),
    );
  }
}
