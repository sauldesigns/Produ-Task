import 'package:book_read/models/category.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomShareDelegate extends SearchDelegate {
  CustomShareDelegate({Key key, this.category});
  Category category;
  final db = DatabaseService();
  Firestore _db = Firestore.instance;
  List<User> _listUsers = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget userData(User user, BuildContext context) {
    return ListTile(
      leading: ProfilePicture(
        imgUrl: user.profilePic,
      ),
      title: Text(user.username),
      onTap: () {
        _db.collection('category').document(category.id).updateData({
          'uids': FieldValue.arrayUnion([user.uid]),
        });
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _listUsers.length == 0
        ? Center(
            child: Text('Not sharing with anyone'),
          )
        : SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _listUsers.length,
              itemBuilder: (context, index) {
                User userData = _listUsers[index];
                return ListTile(
                  title: Text('${userData.username}'),
                  leading: ProfilePicture(
                    imgUrl: userData.profilePic,
                  ),
                );
              },
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: db.streamUsers(query),
      builder: (context, snapshot) {
        List data = snapshot.data;
        return ListView.builder(
          itemCount: data == null ? 0 : data.length > 10 ? 10 : data.length,
          itemBuilder: (context, index) {
            User user = data[index];
            return userData(user, context);
          },
        );
      },
    );
  }
}
