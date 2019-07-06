import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  final db = DatabaseService();
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

  Widget userData(User user) {
    return ListTile(
      leading: ProfilePicture(
        imgUrl: user.profilePic,
      ),
      title: Text(user.username),
      onTap: () {},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: db.streamUsers(query),
      builder: (context, snapshot) {
        List data = snapshot.data;
        return ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (context, index) {
            User user = data[index];
            return userData(user);
          },
        );
      },
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
            return userData(user);
          },
        );
      },
    );
  }
}
