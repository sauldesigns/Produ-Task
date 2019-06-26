// import 'package:book_read/models/category.dart';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/task.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  TasksPage({Key key, this.category}) : super(key: key);
  final Category category;
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    // var _userDb = Provider.of<User>(context);
    var _user = Provider.of<FirebaseUser>(context);
    // var _category = Provider.of<List<Category>>(context);
    return Scaffold(
      body: StreamProvider<List<Task>>.value(
        value: db.categoryTasks(_user, widget.category),
        child: StreamBuilder<Object>(
            stream: db.streamHero(_user.uid),
            builder: (context, snapshot) {
              User _userDb = snapshot.data;
              List<Task> task = Provider.of<List<Task>>(context);
              return SingleChildScrollView(
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
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          ProfilePicture(
                            size: 25,
                            imgUrl: _userDb == null ? null : _userDb.profilePic,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 40.0, right: 40.0),
                      child: Text(
                        '${widget.category.title}',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 15.0, bottom: 0.0),
                      child: Text(
                        '${task == null ? 0 : task.length} tasks',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: ListView.builder(
                        itemCount: task == null ? 0 : task.length,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Task taskData = task[index];
                          return ListTile(
                            title: Text(taskData.title),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
