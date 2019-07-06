import 'package:book_read/models/category.dart';
import 'package:flutter/material.dart';

class SharePage extends StatefulWidget {
  SharePage({Key key, this.category}) : super(key: key);
  final Category category;
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Share',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40, left: 40, right: 40),
              child: Text(
                'Add people to ${widget.category.title}',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, right: 60, left: 60,),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter username here'
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
