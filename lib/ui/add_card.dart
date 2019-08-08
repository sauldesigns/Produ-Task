// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCard extends StatelessWidget {
  const AddCard(
      {Key key,
      this.backgroundImage,
      this.onTap,
      this.borderRadius = 20,
      this.blurRadius = 10.0,
      this.title,
      this.date,
      this.numPages,
      this.content,
      this.height = 250,
      this.width = 200,
      this.icon,
      this.color = Colors.white})
      : super(key: key);
  final String backgroundImage;
  final Text title;
  final String content;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String date;
  final int numPages;
  final double blurRadius;
  final double borderRadius;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
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
                color: Colors.grey,
                offset: Offset(0, 5),
              )
            ]),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 60,
          ),
        ),
      ),
    );
  }
}
