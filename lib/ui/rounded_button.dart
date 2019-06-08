import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key key, this.icon, this.title, this.link, this.onClick})
      : super(key: key);
  final IconData icon;
  final String title;
  final String link;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      child: Container(
        width: 300,
        child: ListTile(
          leading: this.icon == null
              ? null
              : Icon(
                  this.icon,
                  color: Colors.white,
                ),
          title: Text(this.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
          trailing: this.icon == null ? null : SizedBox(),
        ),
      ),
      onPressed: onClick,
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    );
  }
}
