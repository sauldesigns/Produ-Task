import 'dart:math';
import 'package:book_read/ui/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTaskPage extends StatefulWidget {
  NewTaskPage({Key key, this.catUid}) : super(key: key);
  final String catUid;

  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final _formkey = GlobalKey<FormState>();
  final Firestore _db = Firestore.instance;
  bool _autoValidate = false;
  String _task;

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Form(
            key: _formkey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 40),
                  child: Text(
                    'Add new task',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextFormField(
                  autofocus: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Must enter some text';
                    }
                  },
                  onSaved: (value) => _task = value,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: RoundedButton(
                    title: 'Submit',
                    onClick: ()  {
                      _formkey.currentState.save();
                      if (_formkey.currentState.validate()) {
                        
                        var data = {
                          'content': _task,
                          'color': Random().nextInt(7),
                          'createdat': DateTime.now(),
                          'complete': false,
                          'cat_uid': widget.catUid,
                          'done': true,
                          'uid': _user.uid,
                        };
                        _db.collection('tasks').add(data);
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          _autoValidate = true;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
