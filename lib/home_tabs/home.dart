import 'dart:math';
import 'package:book_read/home_tabs/settings.dart';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/task.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/pages/new_category.dart';
import 'package:book_read/pages/share.dart';
import 'package:book_read/pages/tasks_page.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/add_card.dart';
// import 'package:book_read/ui/category_textfield.dart';
import 'package:book_read/ui/custom_card.dart';
import 'package:book_read/ui/delete_alert.dart';
import 'package:book_read/ui/profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);

  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final db = DatabaseService();
  final Firestore database = Firestore.instance;
  bool hasVibration;
  List<Color> listColors = [
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.blueGrey,
    Colors.amber,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    hasVibration = Provider.of<dynamic>(context);
    var _userDb = Provider.of<User>(context);
    var _category = Provider.of<List<Category>>(context);
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
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
                    Expanded(
                      child: Container(),
                    ),
                    Hero(
                      tag: 'hero',
                      child: Material(
                        child: ProfilePicture(
                          size: 25,
                          imgUrl: _userDb.profilePic,
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
                padding: const EdgeInsets.all(40.0),
                child: RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Hello ${_userDb.fname},',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '\nthis is your task list.',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ]),
                ),
                // child: Text(
                //   'Hey ${_userDb.fname},\nthis is your to-do list.',
                //   style: TextStyle(
                //     fontSize: 25,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 45),
                  itemCount: _category == null ? 1 : _category.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: useMobileLayout == true ? 2 : 4,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AddCard(
                        blurRadius: 10,
                        color: Colors.blue,
                        onTap: () {
                          if (hasVibration) {
                            Vibration.vibrate(duration: 200);
                          }
                          int index = Random().nextInt(7);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NewCategory(
                                user: _userDb,
                                initialText: '',
                                listColors: listColors,
                                colorIndex: index,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      Category category = _category[index - 1];
                      return Hero(
                        tag: category.id,
                        child: Material(
                          child: CustomCard(
                            blurRadius: 10,
                            color: listColors[category.color],
                            date: DateFormat('dd MMMM, yyyy').format(
                                _category[index - 1].createdAt.toDate()),
                            numPages: 2,
                            // title: category.done == false
                            //     ? CategoryTextField(
                            //         doc: category,
                            //         type: 'category',
                            //         content: category.title,
                            //       )
                            title: Text(
                              _category[index - 1].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              // Navigator.of(context).pushNamed('/tasks_page');
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StreamProvider<List<Task>>.value(
                                    value: db.categoryTasks(
                                        _userDb, category.uid, category),
                                    child: TasksPage(
                                      category: category,
                                      user: _userDb,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              if (hasVibration) {
                                Vibration.vibrate(duration: 200);
                              }
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
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 5),
                                          child: Text('Change Color'),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Container(
                                            height: 40,
                                            child: ListView.builder(
                                              itemCount: listColors.length,
                                              scrollDirection: Axis.horizontal,
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    // if (hasVibration) {
                                                    //   Vibration.vibrate(
                                                    //       duration: 200);
                                                    // }
                                                    db.updateDocument(
                                                        collection: 'category',
                                                        docID: category.id,
                                                        data: {'color': index});
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 15),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          listColors[index],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.share),
                                          title: Text('Share'),
                                          onTap: () {
                                            // if (hasVibration) {
                                            //   Vibration.vibrate(duration: 200);
                                            // }
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => SharePage(
                                                  category: category,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.create),
                                          title: Text('Edit'),
                                          onTap: () {
                                            // if (hasVibration) {
                                            //   Vibration.vibrate(duration: 200);
                                            // }
                                            Navigator.pop(context);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewCategory(
                                                        catID: category.id,
                                                        initialText:
                                                            category.title,
                                                        user: _userDb,
                                                        update: true,
                                                        listColors: listColors,
                                                        colorIndex:
                                                            category.color),
                                              ),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text('Delete'),
                                          onTap: () {
                                            if (hasVibration) {
                                              Vibration.vibrate(duration: 200);
                                            }

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return DeleteAlert(
                                                    categoryID: category.id,
                                                    collection: 'category',
                                                  );
                                                });

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
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
