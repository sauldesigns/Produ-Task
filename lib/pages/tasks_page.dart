// import 'package:book_read/models/category.dart';
import 'dart:math';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/task.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:book_read/ui/task_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final date = DateTime.now();
  var newDate;
  final Firestore _db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    newDate = DateTime.utc(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    // var _userDb = Provider.of<User>(context);
    var _user = Provider.of<FirebaseUser>(context);
    // var _category = Provider.of<List<Category>>(context);
    return Scaffold(
      body: StreamProvider<List<Task>>.value(
        value: db.categoryTasks(_user,widget.category.uid, widget.category, newDate),
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
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 50.0, bottom: 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                var data = {
                                  'complete': false,
                                  'done': false,
                                  'content': '',
                                  'createdat': DateTime.now(),
                                  'uid': _userDb.uid,
                                  'cat_uid': widget.category.id,
                                  'color': Random().nextInt(7),
                                };
                                _db.collection('tasks').add(data);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        itemCount: task == null ? 0 : task.length,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Task taskData = task[index];
                          return ListTile(
                            leading: IconButton(
                              icon: Icon(
                                taskData.complete == true
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                _db
                                    .collection('tasks')
                                    .document(taskData.id)
                                    .updateData(
                                        {'complete': !taskData.complete});
                              },
                            ),
                            title: taskData.done == false
                                ? TaskTextField(
                                    doc: taskData,
                                    type: 'tasks',
                                    content: taskData.title,
                                  )
                                : Text(
                                    taskData.title,
                                    style: TextStyle(
                                        decoration: taskData.complete == false
                                            ? null
                                            : TextDecoration.lineThrough),
                                  ),
                            onLongPress: () {
                              showBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.create),
                                          title: Text('Edit'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _db
                                                .collection('tasks')
                                                .document(taskData.id)
                                                .updateData(
                                                    {'done': !taskData.done});
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text('Delete'),
                                          onTap: () {
                                            _db
                                                .collection('tasks')
                                                .document(taskData.id)
                                                .delete();
                                            Navigator.pop(context);
                                          },
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
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
