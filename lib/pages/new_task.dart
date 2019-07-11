import 'dart:math';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/ui/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewTaskPage extends StatefulWidget {
  NewTaskPage({Key key, this.category, this.user}) : super(key: key);

  final Category category;
  final User user;

  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final _formkey = GlobalKey<FormState>();
  final Firestore _db = Firestore.instance;
  bool _autoValidate = false;
  String _task;

  @override
  Widget build(BuildContext context) {
    // var _user = Provider.of<FirebaseUser>(context);
    var _userDb = widget.user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Add a task to ',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            TextSpan(
                              text: '${widget.category.title}',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter task here',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Must enter some text';
                      }
                      return null;
                    },
                    onSaved: (value) => _task = value,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: RoundedButton(
                      title: 'Submit',
                      onClick: () {
                        _formkey.currentState.save();
                        if (_formkey.currentState.validate()) {
                          var data = {
                            'complete': false,
                            'done': true,
                            'content': _task,
                            'createdat': DateTime.now(),
                            'uid': _userDb.uid,
                            'cat_uid': widget.category.id,
                            'createdby': _userDb.fname,
                            'color': Random().nextInt(7),
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
      ),
    );
  }
}
