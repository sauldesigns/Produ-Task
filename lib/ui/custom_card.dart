// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {Key key,
      this.backgroundImage,
      this.onTap,
      this.borderRadius = 20,
      this.blurRadius = 10.0,
      this.title,
      this.date,
      this.numPages,
      this.onLongPress,
      this.content,
      this.height = 250,
      this.width = 200,
      this.icon,
      this.color = Colors.white})
      : super(key: key);
  final String backgroundImage;
  final Widget title;
  final String content;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String date;
  final int numPages;
  final double blurRadius;
  final double borderRadius;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: color,
            image: backgroundImage == null
                ? null
                : DecorationImage(
                    image: NetworkImage(backgroundImage),
                    fit: BoxFit.cover,
                  ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                blurRadius: blurRadius,
                color: Colors.grey[300],
                offset: Offset(0, 5),
              )
            ]),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: title,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
