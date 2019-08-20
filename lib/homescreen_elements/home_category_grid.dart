import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/task.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/pages/new_category.dart';
import 'package:book_read/pages/tasks_page.dart';
import 'package:book_read/ui/add_card.dart';
import 'package:book_read/ui/custom_card.dart';
import 'package:book_read/ui/delete_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:vibration/vibration.dart';

class HomeCategoryGrid extends StatelessWidget {
  final List<Category> categoryList;
  final useMobileLayout;
  final User userDb;
  final List<Color> listColors;
  final db;
  final bool hasVibration;
  const HomeCategoryGrid(
      {Key key,
      this.categoryList,
      this.useMobileLayout,
      this.db,
      this.userDb,
      this.listColors,
      this.hasVibration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 45),
        itemCount: categoryList == null ? 1 : categoryList.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: useMobileLayout == true ? 2 : 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1),
        itemBuilder: (context, index) {
          // this is used to create the add button by default.
          if (index == 0) {
            return ControlledAnimation(
                duration: Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOutQuint,
                builder: (context, animation) {
                  return Transform.scale(
                    scale: animation,
                    child: AddCard(
                      blurRadius: 10,
                      color: Colors.blue,
                      onTap: () {
                        // this checks to see if device can vibrate,
                        if (hasVibration) {
                          Vibration.vibrate(duration: 200);
                        }
                        // generates a random number that defines the color of the category
                        // the data is then pushed to the New Category page which is what navigates over
                        // to new page to create a category.
                        //
                        int index = Random().nextInt(7);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewCategory(
                              user: userDb,
                              initialText: '',
                              listColors: listColors,
                              colorIndex: index,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                });
          } else {
            // this creates the category cards.
            // this grows dynamically based on user input.
            Category category = categoryList[index - 1];
            return Hero(
              tag: category.id,
              child: Material(
                color: Colors.transparent,
                // handles the animation showed when app is first loaded.
                child: ControlledAnimation(
                    duration: Duration(milliseconds: 1000),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOutQuint,
                    builder: (context, animation) {
                      return Transform.scale(
                        scale: animation,
                        child:
                            StreamProvider<List<IncompleteTaskCounter>>.value(
                          value: db.incompleteTaskCounter(
                              userDb, userDb.uid, category),
                          child: Consumer<List<IncompleteTaskCounter>>(
                              builder: (context, badge, badgechild) {
                            return Badge(
                              showBadge: badge == null
                                  ? false
                                  : badge.length == 0 ? false : true,
                              badgeContent: Text(
                                badge == null ? '0' : badge.length.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              child: CustomCard(
                                blurRadius: 10,
                                color: listColors[category.color],
                                title: AutoSizeText(
                                  categoryList[index - 1].title,
                                  textAlign: TextAlign.center,
                                  wrapWords: false,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  // this navigates to the task page, so that user can see
                                  // what tasks have been created under that category.
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StreamProvider<List<Task>>.value(
                                        value: db.categoryTasks(
                                            userDb, category.uid, category),
                                        child: StreamProvider<
                                            List<IncompleteTask>>.value(
                                          value: db.incompleteTasks(
                                              userDb, category.uid, category),
                                          child: StreamProvider<
                                              List<AllTasks>>.value(
                                            value: db.allTasks(
                                                userDb, category.uid, category),
                                            child: TasksPage(
                                              category: category,
                                              user: userDb,
                                            ),
                                          ),
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
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
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
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
                                                            collection:
                                                                'category',
                                                            docID: category.id,
                                                            data: {
                                                              'color': index
                                                            });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                            // ListTile(
                                            //   leading: Icon(Icons.share),
                                            //   title: Text('Share'),
                                            //   onTap: () {
                                            //     // if (hasVibration) {
                                            //     //   Vibration.vibrate(duration: 200);
                                            //     // }
                                            //     Navigator.of(context).pop();
                                            //     Navigator.of(context).push(
                                            //       MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             SharePage(
                                            //           category: category,
                                            //         ),
                                            //       ),
                                            //     );
                                            //   },
                                            // ),
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
                                                            user: userDb,
                                                            update: true,
                                                            listColors:
                                                                listColors,
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
                                                  Vibration.vibrate(
                                                      duration: 200);
                                                }

                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return DeleteAlert(
                                                        categoryID: category.id,
                                                        collection: 'category',
                                                      );
                                                    }).then(
                                                  (val) => Navigator.of(context)
                                                      .pop(),
                                                );
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
                            );
                          }),
                        ),
                      );
                    }),
              ),
            );
          }
        },
      ),
    );
  }
}
