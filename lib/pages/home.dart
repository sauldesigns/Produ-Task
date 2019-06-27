import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/home_tabs/books.dart';
import 'package:book_read/home_tabs/home.dart';
import 'package:book_read/home_tabs/profile.dart';
import 'package:book_read/home_tabs/settings.dart';
import 'package:book_read/models/category.dart';
// import 'package:book_read/models/user.dart';
import 'package:book_read/services/auth.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/offline.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final db = DatabaseService();
  final List<Widget> _tabs = [
    HomeTab(),
    BooksTab(),
    ProfileTab(),
    SettingsTab(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    var user = Provider.of<FirebaseUser>(context);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    return Scaffold(
        
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Colors.black,
          textColor: Colors.black,
          inactiveIconColor: Colors.grey,
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: Icons.search, title: "Search"),
            TabData(iconData: Icons.person, title: "Profile"),
            TabData(iconData: Icons.settings, title: "Settings")
          ],
          onTabChangedListener: (position) {
            setState(() {
              _currentIndex = position;
            });
          },
        ),
        body: connectionStatus == ConnectivityStatus.Offline
            ? OfflineMessage()
            : StreamProvider<List<Category>>.value(
                value: db.streamWeapons(user),
                child: _tabs[_currentIndex],
              ));
  }
}
