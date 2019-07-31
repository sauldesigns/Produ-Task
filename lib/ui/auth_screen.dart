import 'package:flutter/material.dart';

class LoadingScreeen extends StatelessWidget {
  const LoadingScreeen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
