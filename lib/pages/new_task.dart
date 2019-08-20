import 'dart:math';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/task.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/ui/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewTaskPage extends StatefulWidget {
  NewTaskPage(
      {Key key,
      this.category,
      this.user,
      this.allTasks,
      this.content = '',
      this.task,
      this.isIncomTask = false,
      this.incomTask,
      this.isUpdate = false,
      this.isAllTasks = false})
      : super(key: key);

  final Category category;
  final User user;
  final String content;
  final Task task;
  final bool isUpdate;
  final bool isIncomTask;
  final bool isAllTasks;
  final IncompleteTask incomTask;
  final AllTasks allTasks;
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final _formkey = GlobalKey<FormState>();
  final Firestore _db = Firestore.instance;
  bool _autoValidate = false;
  String _task;

  @override
  Widget build(BuildContext context) {
    var _userDb = widget.user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
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
                              text: widget.isUpdate == true
                                  ? 'Update '
                                  : 'Add a task to ',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            TextSpan(
                              text: widget.isUpdate == true
                                  ? 'task'
                                  : '${widget.category.title}',
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
                    initialValue: widget.content,
                    keyboardType: TextInputType.text,
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
                    child: Center(
                      child: RoundedButton(
                        title: widget.isUpdate == false ? 'Create' : 'Update',
                        onClick: () {
                          _formkey.currentState.save();
                          var storyRef = _db
                              .collection('category')
                              .document(widget.category.id);
                          if (_formkey.currentState.validate()) {
                            if (widget.isUpdate) {
                              var data = {'done': true, 'content': _task};
                              if (widget.isIncomTask) {
                                storyRef
                                    .collection('tasks')
                                    .document(widget.incomTask.id)
                                    .updateData(data);
                              } else if (widget.isAllTasks) {
                                storyRef
                                    .collection('tasks')
                                    .document(widget.allTasks.id)
                                    .updateData(data);
                              } else {
                                storyRef
                                    .collection('tasks')
                                    .document(widget.task.id)
                                    .updateData(data);
                              }
                            } else {
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
                              storyRef.collection('tasks').add(data);
                            }
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              _autoValidate = true;
                            });
                          }
                        },
                      ),
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
