import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {Key key,
      this.backgroundImage,
      this.onTap,
      this.borderRadius = 60,
      this.blurRadius = 10.0,
      this.title,
      this.content,
      this.height = 300,
      this.icon,
      this.color = Colors.white})
      : super(key: key);
  final String backgroundImage;
  final String title;
  final String content;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double blurRadius;
  final double borderRadius;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: color,
          image: backgroundImage == null
              ? null
              : DecorationImage(image: NetworkImage(backgroundImage)),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              blurRadius: blurRadius,
              color: Colors.grey,
              offset: Offset(0, 5),
            )
          ]),
    );
  }
}
