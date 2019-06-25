import 'package:book_read/models/book.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/add_card.dart';
import 'package:book_read/ui/custom_card.dart';
import 'package:book_read/ui/profile_picture.dart';
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
      // appBar: AppBar(

      //   title: Text(
      //     'Le Book',
      //     style: TextStyle(
      //       color: Colors.black,
      //     ),
      //   ),
      //   actions: <Widget>[
      //     ProfilePicture(
      //       imgUrl: _userDb.profilePic,
      //       size: 25,
      //     )
      //   ],
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 65,
                bottom: 0,
                left: 20,
                right: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  ProfilePicture(
                    size: 25,
                    imgUrl: _userDb.profilePic,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'Hey ${_userDb.fname},\nthis is your to-do list.',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 45),
              itemCount: _books == null ? 1 : _books.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                  childAspectRatio: 1),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return AddCard(
                    blurRadius: 10,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).pushNamed('/new_task');
                      // var data = {
                      //   'title': 'Book',
                      //   'uid': _userDb.uid,
                      //   'created_at': DateTime.now(),
                      //   'cover_img': '',
                      // };

                      // database
                      //     .collection('users')
                      //     .document(_userDb.uid)
                      //     .collection('books')
                      //     .add(data);
                    },
                  );
                } else {
                  return CustomCard(
                    blurRadius: 10,
                    date: DateFormat('dd MMMM, yyyy')
                        .format(_books[index - 1].createdAt.toDate()),
                    numPages: 2,
                    title: Text(
                      _books[index - 1].title,
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
          ],
        ),
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
