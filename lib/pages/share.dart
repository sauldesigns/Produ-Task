import 'package:book_read/models/category.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/ui/custome_share_search.dart';

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class SharePage extends StatefulWidget {
  SharePage({Key key, this.category}) : super(key: key);
  final Category category;
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  List<User> usersadded = [];
  @override
  Widget build(BuildContext context) {
    // List<User> users = Provider.of<List<User>>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Share',
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
                delegate: CustomShareDelegate(category: widget.category),
              );
            },
          )
        ],
      ),
      body: Center(
        child:
            Text('Click search icon to add users', style: TextStyle(
              fontSize: 25
            ),),
      ),
    );
  }
}
