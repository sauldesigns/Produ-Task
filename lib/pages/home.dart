import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/home_tabs/books.dart';
import 'package:book_read/home_tabs/home.dart';
import 'package:book_read/home_tabs/profile.dart';
import 'package:book_read/home_tabs/settings.dart';
// import 'package:book_read/models/user.dart';
import 'package:book_read/services/auth.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/offline.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';

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
    // var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      // appBar: AppBar(
      //   // elevation: 0.0,
      //   centerTitle: true,
      //   title: Text(
      //     'Rea:bor',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      // drawer: StreamBuilder<User>(
      //     stream: db.streamHero(user.uid),
      //     builder: (context, snapshot) {
      //       var userData = snapshot.data;
      //       return Drawer(
      //         child: Column(
      //           children: <Widget>[
      //             UserAccountsDrawerHeader(
      //               accountEmail: Text(userData.email),
      //               accountName: Text(userData.username),
      //               currentAccountPicture: CircleAvatar(
      //                 backgroundImage: NetworkImage(userData.profilePic),
      //               ),
      //             ),
      //             ListView(
      //               shrinkWrap: true,
      //               padding: EdgeInsets.all(0),
      //               children: <Widget>[
      //                 ListTile(
      //                   leading: Icon(Icons.home),
      //                   title: Text('Home'),
      //                   onTap: () {},
      //                 ),
      //               ],
      //             )
      //           ],
      //         ),
      //       );
      //     }),
      bottomNavigationBar: FancyBottomNavigation(
        circleColor: Colors.black,
        inactiveIconColor: Colors.grey,
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.book, title: "Books"),
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
          : _tabs[_currentIndex],
    );
  }
}
