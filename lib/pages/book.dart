import 'package:flutter/material.dart';

class BookDataPage extends StatefulWidget {
  BookDataPage({Key key, this.bookData}) : super(key: key);
  final List bookData;
  _BookDataPageState createState() => _BookDataPageState();
}

class _BookDataPageState extends State<BookDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.bookData.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: widget.bookData[index]['isbn'] == null
                ? CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text('N/A'),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                        'http://covers.openlibrary.org/b/isbn/' +
                            widget.bookData[index]['isbn'].last +
                            '-M.jpg'),
                  ),
            title: Text(widget.bookData[index]['title']),
            subtitle: widget.bookData[index]['author_name'] == null
                ? Text('Author data not available')
                : Text(widget.bookData[index]['author_name'][0]),
          );
        },
      ),
    );
  }
}
