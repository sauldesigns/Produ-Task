import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/home_tabs/settings.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/pages/edit_profile.dart';
import 'package:book_read/pages/home.dart';
import 'package:book_read/pages/landing_page.dart';
import 'package:book_read/pages/login.dart';
import 'package:book_read/pages/new_task.dart';
import 'package:book_read/pages/root_page.dart';
import 'package:book_read/pages/sign_up.dart';
import 'package:book_read/pages/tasks_page.dart';
import 'package:book_read/services/auth.dart';
import 'package:book_read/services/connectivity.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/services/user_repo.dart';
import 'package:book_read/ui/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final db = DatabaseService();
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        StreamProvider<ConnectivityStatus>.controller(
          builder: (context) =>
              ConnectivityService().connectionStatusController,
        ),
        StreamProvider<List<User>>.value(
          value: db.streamUsers(''),
        ),
        FutureProvider<dynamic>.value(value: Vibration.hasVibrator()),
        ChangeNotifierProvider(
          builder: (_) => UserRepository.instance(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Read',
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => RootPage(),
          '/splash': (context) => SplashScreen(),
          '/landingpage': (context) => LandingPage(
                auth: new Auth(),
              ),
          '/login': (context) => LoginPage(
                auth: new Auth(),
              ),
          '/signup': (context) => SignUpPage(auth: new Auth()),
          '/home': (context) => HomePage(
                auth: new Auth(),
              ),
          '/editprofile': (context) => EditProfilePage(),
          '/new_task': (context) => NewTaskPage(),
          '/tasks_page': (context) => TasksPage(),
          '/settings': (context) => SettingsTab(),
        },
      ),
    );
  }
}
