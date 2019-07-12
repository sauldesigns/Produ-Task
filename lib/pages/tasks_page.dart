// import 'package:book_read/models/category.dart';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/task.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/pages/new_task.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:book_read/ui/task_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class TasksPage extends StatefulWidget {
  TasksPage({Key key, this.category, this.user}) : super(key: key);
  final Category category;
  final User user;
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final db = DatabaseService();
  final Firestore _db = Firestore.instance;
  User _userDb;

  @override
  Widget build(BuildContext context) {
    var _user = widget.user;
    var category = widget.category;
    _userDb = widget.user;
    List<Task> task = Provider.of<List<Task>>(context);
    bool hasVibration = Provider.of<dynamic>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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
                padding:
                    const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
                child: Text(
                  '${category.title}',
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
                    left: 40.0, right: 20.0, top: 50.0, bottom: 0.0),
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
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (hasVibration) {
                          Vibration.vibrate(duration: 200);
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewTaskPage(
                              user: _userDb,
                              category: category,
                            ),
                          ),
                        );
                        // var data = {
                        //   'complete': false,
                        //   'done': false,
                        //   'content': '',
                        //   'createdat': DateTime.now(),
                        //   'uid': _userDb.uid,
                        //   'cat_uid': widget.category.id,
                        //   'createdby': _userDb.fname,
                        //   'color': Random().nextInt(7),
                        // };
                        // _db.collection('tasks').add(data);
                      },
                    ),
                  ],
                ),
              ),
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                itemCount: task == null ? 0 : task.length,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Task taskData = task[index];
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: new Container(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              taskData.complete == true
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              if (hasVibration) {
                                Vibration.vibrate(duration: 200);
                              }
                              _db
                                  .collection('category')
                                  .document(category.id)
                                  .collection('tasks')
                                  .document(taskData.id)
                                  .updateData({'complete': !taskData.complete});
                            },
                          ),
                          title: taskData.done == false
                              ? TaskTextField(
                                  doc: taskData,
                                  type: 'tasks',
                                  content: taskData.title,
                                  cat: category,
                                )
                              : Text(
                                  taskData.title,
                                  style: TextStyle(
                                      decoration: taskData.complete == false
                                          ? null
                                          : TextDecoration.lineThrough),
                                ),
                          subtitle: taskData.done == false
                              ? null
                              : Text('Created by ${taskData.createdBy}'),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      new IconSlideAction(
                        caption: 'Edit',
                        color: Colors.blue,
                        icon: Icons.edit,
                        onTap: () {
                          if (hasVibration) {
                            Vibration.vibrate(duration: 200);
                          }
                          _db
                              .collection('category')
                              .document(category.id)
                              .collection('tasks')
                              .document(taskData.id)
                              .updateData({'done': !taskData.done});
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      new IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          if (hasVibration) {
                            Vibration.vibrate(duration: 200);
                          }
                          _db
                              .collection('category')
                              .document(category.id)
                              .collection('tasks')
                              .document(taskData.id)
                              .delete();
                        },
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 50.0, bottom: 0.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Incomplete',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<Task>>(
                  stream: db.incompleteTasks(_user, category.uid, category),
                  builder: (context, snapshot) {
                    List data = snapshot.data;

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      itemCount: data == null ? 0 : data.length,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Task taskData = data[index];

                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: new Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, left: 20.0),
                              child: ListTile(
                                leading: IconButton(
                                  icon: Icon(
                                    taskData.complete == true
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    if (hasVibration) {
                                      Vibration.vibrate(duration: 200);
                                    }
                                    _db
                                        .collection('category')
                                        .document(category.id)
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
                                        cat: category,
                                      )
                                    : Text(
                                        taskData.title,
                                        style: TextStyle(
                                            decoration: taskData.complete ==
                                                    false
                                                ? null
                                                : TextDecoration.lineThrough),
                                      ),
                                subtitle: taskData.done == false
                                    ? null
                                    : Text('Created by ${taskData.createdBy}'),
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            new IconSlideAction(
                              caption: 'Edit',
                              color: Colors.blue,
                              icon: Icons.edit,
                              onTap: () {
                                if (hasVibration) {
                                  Vibration.vibrate(duration: 200);
                                }
                                _db
                                    .collection('category')
                                    .document(category.id)
                                    .collection('tasks')
                                    .document(taskData.id)
                                    .updateData({'done': !taskData.done});
                              },
                            ),
                          ],
                          secondaryActions: <Widget>[
                            new IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                if (hasVibration) {
                                  Vibration.vibrate(duration: 200);
                                }
                                _db
                                    .collection('category')
                                    .document(category.id)
                                    .collection('tasks')
                                    .document(taskData.id)
                                    .delete();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
