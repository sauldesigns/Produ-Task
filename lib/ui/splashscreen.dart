import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ControlledAnimation(
                duration: Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.elasticInOut,
                builder: (context, animation) {
                  return Transform.scale(
                    scale: animation,
                    child: Text(
                      'Produ:Task',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  );
                }),
            SizedBox(
              height: 100.0,
            ),
            ControlledAnimation(
                duration: Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.elasticInOut,
                builder: (context, animation) {
                  return Transform.scale(
                    scale: animation,
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
