import 'package:book_read/models/book.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/custom_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);

  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final db = DatabaseService();
  final Firestore database = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    var _userDb = Provider.of<User>(context);
    var _books = Provider.of<List<Book>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Le Book',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 45),
        itemCount: _books == null ? 1 : _books.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: .77),
        itemBuilder: (context, index) {
          if (index == 0) {
            return CustomCard(
              blurRadius: 10,
              title: Text(
                '+',
                style: TextStyle(
                  fontSize: 100,
                  color: Colors.white,
                ),
              ),
              color: Color.fromRGBO(55, 55, 55, 1),
              onTap: () {
                var data = {
                  'title': 'Book',
                  'uid': _userDb.uid,
                  'created_at': DateTime.now(),
                  'cover_img': '',
                };

                database
                    .collection('users')
                    .document(_userDb.uid)
                    .collection('books')
                    .add(data);
              },
            );
          } else {
            return CustomCard(
              blurRadius: 10,
              date: DateFormat('dd MMMM, yyyy')
                  .format(_books[index - 1].createdAt.toDate()),
              numPages: 2,
              title: Text(
                'Song of Storms',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              onTap: () {},
            );
          }
        },
      ),

      // child: Column(
      //   children: <Widget>[
      //     Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: CustomCard(
      //           title: 'Song of Storms',
      //           onTap: () {},
      //         ))
      //   ],
      // ),
    );
  }
}
