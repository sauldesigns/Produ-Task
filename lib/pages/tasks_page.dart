// import 'package:book_read/models/category.dart';
import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/home_tabs/settings.dart';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/task.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/pages/new_task.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/delete_alert.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  PageController pageController = new PageController();
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var category = widget.category;
    List<IncompleteTask> _incompleteTask =
        Provider.of<List<IncompleteTask>>(context);
    _userDb = widget.user;
    List<Task> task = Provider.of<List<Task>>(context);
    List<AllTasks> allTasks = Provider.of<List<AllTasks>>(context);
    bool hasVibration = Provider.of<dynamic>(context);
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
      bottomNavigationBar: BubbledNavigationBar(
          initialIndex: 0,
          itemMargin: EdgeInsets.symmetric(horizontal: 45),
          backgroundColor: Colors.transparent,
          defaultBubbleColor: Colors.blue,
          onTap: (index) {
            pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutQuart,
            );
          },
          items: [
            BubbledNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calendarDay),
              activeIcon: Icon(
                FontAwesomeIcons.calendarDay,
                color: Colors.white,
              ),
              bubbleColor: Colors.blue,
              title: Text(
                'Today',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            BubbledNavigationBarItem(
                icon: Icon(FontAwesomeIcons.tasks),
                activeIcon: Icon(
                  FontAwesomeIcons.tasks,
                  color: Colors.white,
                ),
                bubbleColor: Colors.orange,
                title: Text(
                  'All Tasks',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          ]),
      // BottomNavigationDotBar(
      //   items: <BottomNavigationDotBarItem>[
      //     BottomNavigationDotBarItem(
      //         icon: FontAwesomeIcons.calendarDay,
      //         onTap: () {
      //           pageController.animateToPage(
      //             0,
      //             duration: Duration(milliseconds: 500),
      //             curve: Curves.easeInOutQuart,
      //           );
      //         }),
      //     BottomNavigationDotBarItem(
      //         icon: FontAwesomeIcons.tasks,
      //         onTap: () {
      //           pageController.animateToPage(
      //             1,
      //             duration: Duration(milliseconds: 500),
      //             curve: Curves.easeInOutQuart,
      //           );
      //         }),
      //   ],
      // ),

      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            Container(
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
                            icon: Icon(FontAwesomeIcons.chevronLeft),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          connectionStatus == ConnectivityStatus.Offline
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Offline Mode',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : Container(),
                          Expanded(
                            child: Container(),
                          ),
                          Hero(
                            tag: 'hero',
                            child: Material(
                              color: Colors.transparent,
                              child: ProfilePicture(
                                size: 25,
                                imgUrl:
                                    _userDb == null ? null : _userDb.profilePic,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StreamProvider<User>.value(
                                        value: db.streamHero(_userDb.uid),
                                        initialData: User.initialData(),
                                        child: SettingsTab(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 40.0, right: 40.0),
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
                        '${task == null ? _incompleteTask == null ? 0 : _incompleteTask.length : _incompleteTask == null ? task.length : task.length + _incompleteTask.length} tasks',
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
                              padding: const EdgeInsets.only(
                                  right: 20.0, left: 20.0),
                              child: Hero(
                                tag: taskData.id,
                                child: Material(
                                  color: Colors.transparent,
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
                                            .updateData({
                                          'complete': !taskData.complete
                                        });
                                      },
                                    ),
                                    title: Text(
                                      taskData.title,
                                      style: TextStyle(
                                          decoration: taskData.complete == false
                                              ? null
                                              : TextDecoration.lineThrough),
                                    ),
                                    // subtitle: taskData.done == false
                                    //     ? null
                                    //     : Text('Created by ${taskData.createdBy}'),
                                  ),
                                ),
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NewTaskPage(
                                      category: category,
                                      task: taskData,
                                      isUpdate: true,
                                      user: _userDb,
                                      content: taskData.title,
                                    ),
                                  ),
                                );
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
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DeleteAlert(
                                        collection: 'category',
                                        categoryID: category.id,
                                        isTask: true,
                                        docID: taskData.id,
                                      );
                                    });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 20.0, top: 10.0, bottom: 0.0),
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
                    ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        itemCount: _incompleteTask == null
                            ? 0
                            : _incompleteTask.length,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          IncompleteTask taskData = _incompleteTask[index];

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
                                  title: Text(
                                    taskData.title,
                                    style: TextStyle(
                                        decoration: taskData.complete == false
                                            ? null
                                            : TextDecoration.lineThrough),
                                  ),
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NewTaskPage(
                                        category: category,
                                        incomTask: taskData,
                                        isUpdate: true,
                                        isIncomTask: true,
                                        user: _userDb,
                                        content: taskData.title,
                                      ),
                                    ),
                                  );
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
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DeleteAlert(
                                          collection: 'category',
                                          categoryID: category.id,
                                          isTask: true,
                                          docID: taskData.id,
                                        );
                                      });
                                },
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
            //
            // This shows all tasks
            //
            Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
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
                            icon: Icon(FontAwesomeIcons.chevronLeft),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          connectionStatus == ConnectivityStatus.Offline
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Offline Mode',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : Container(),
                          Expanded(
                            child: Container(),
                          ),
                          Hero(
                            tag: 'hero',
                            child: Material(
                              color: Colors.transparent,
                              child: ProfilePicture(
                                size: 25,
                                imgUrl:
                                    _userDb == null ? null : _userDb.profilePic,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StreamProvider<User>.value(
                                        value: db.streamHero(_userDb.uid),
                                        initialData: User.initialData(),
                                        child: SettingsTab(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 40.0, right: 40.0),
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
                        '${allTasks == null ? 0 : allTasks.length} tasks',
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
                            'All Tasks Created',
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
                      itemCount: allTasks == null ? 0 : allTasks.length,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        AllTasks taskData = allTasks[index];
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: new Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, left: 20.0),
                              child: Hero(
                                tag: taskData.id,
                                child: Material(
                                  color: Colors.transparent,
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
                                            .updateData({
                                          'complete': !taskData.complete
                                        });
                                      },
                                    ),
                                    title: Text(
                                      taskData.title,
                                      style: TextStyle(
                                          decoration: taskData.complete == false
                                              ? null
                                              : TextDecoration.lineThrough),
                                    ),
                                    // subtitle: taskData.done == false
                                    //     ? null
                                    //     : Text('Created by ${taskData.createdBy}'),
                                  ),
                                ),
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NewTaskPage(
                                      category: category,
                                      allTasks: taskData,
                                      isUpdate: true,
                                      isAllTasks: true,
                                      user: _userDb,
                                      content: taskData.title,
                                    ),
                                  ),
                                );
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
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DeleteAlert(
                                        collection: 'category',
                                        categoryID: category.id,
                                        isTask: true,
                                        docID: taskData.id,
                                      );
                                    });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ])),
            )
          ]),
    );
  }
}
