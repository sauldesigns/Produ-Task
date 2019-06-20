import 'package:flutter/material.dart';

class DrawerIcon extends StatelessWidget {
  const DrawerIcon({Key key, this.onTap}) : super(key: key);
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(60),
              ),
              width: 35,
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(60),
                ),
                width: 25,
                height: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(60),
                ),
                width: 30,
                height: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
