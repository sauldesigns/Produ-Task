import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(
      {Key key, this.onTap, this.size, this.imgUrl, this.isSettings = false})
      : super(key: key);
  final VoidCallback onTap;
  final double size;
  final String imgUrl;
  final bool isSettings;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(
                blurRadius: 10.0, color: Colors.black54, offset: Offset(0, 5)),
          ],
        ),
        child: CircleAvatar(
          radius: size,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imgUrl),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: isSettings == true
                ? Container(
                    height: 20,
                    child: Text('Edit', style: TextStyle(color: Colors.white70)),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
