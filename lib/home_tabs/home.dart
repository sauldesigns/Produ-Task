import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/homescreen_elements/home_category_grid.dart';
import 'package:book_read/homescreen_elements/home_greeting.dart';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/default_top_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key, this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
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
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    // var userRepo = Provider.of<UserRepository>(context);
    // userRepo.signOut();
    return Scaffold(
      // this sets the height to maximum, based on
      // device
      body: Container(
        height: MediaQuery.of(context).size.height,
        // creates a scroll view to make sure data is not cut off
        // when dynamically growing.
        child: SingleChildScrollView(
          // makes it so that the scroll view can always be scrolled, even if data
          // does not go past height of device.
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DefaultTopAppBar(
                  connectionStatus: connectionStatus, userDb: _userDb, db: db),
              // this is used to display the greeting message,
              // this will also display offline message.
              GreetingHomeScreen(
                connectionStatus: connectionStatus,
                userDb: _userDb,
              ),
              // this displays the categories in a girdview in a card format.
              // user is able to long click to pop open menu
              // allows user to edit, delete, or change color of card.
              HomeCategoryGrid(
                  categoryList: _category,
                  useMobileLayout: useMobileLayout,
                  userDb: _userDb,
                  listColors: listColors,
                  hasVibration: hasVibration,
                  db: db),
            ],
          ),
        ),
      ),
    );
  }
}
