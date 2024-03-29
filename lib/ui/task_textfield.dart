import 'package:book_read/models/category.dart';
import 'package:book_read/models/task.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskTextField extends StatefulWidget {
  TaskTextField(
      {Key key,
      this.doc,
      this.incomTask,
      this.cat,
      this.content = '',
      this.isIncomTask = false,
      this.type})
      : super(key: key);
  final String type;
  final Task doc;
  final IncompleteTask incomTask;
  final bool isIncomTask;
  final Category cat;
  final String content;
  @override
  State<StatefulWidget> createState() {
    return _TaskTextFieldState();
  }
}

class _TaskTextFieldState extends State<TaskTextField> {
  Firestore db = Firestore.instance;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    if (widget.content != '') {
      _textEditingController.text = widget.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      autofocus: false,
      style: TextStyle(
        color: Colors.black,
      ),
      cursorColor: Colors.black,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: InputBorder.none,
          hasFloatingPlaceholder: true,
          labelText: 'Click to edit task',
          hintText: 'Enter Task Here'),
      onSubmitted: (String value) {
        if (value == '') {
          if (widget.isIncomTask) {
            db.collection(widget.type).document(widget.incomTask.id).delete();
          } else {
            db.collection(widget.type).document(widget.doc.id).delete();
          }
        } else {
          var data = {'done': true, 'content': value};
          if (widget.isIncomTask) {
            db
                .collection('category')
                .document(widget.cat.id)
                .collection('tasks')
                .document(widget.incomTask.id)
                .updateData(data);
          } else {
            db
                .collection('category')
                .document(widget.cat.id)
                .collection('tasks')
                .document(widget.doc.id)
                .updateData(data);
          }
        }
      },
    );
  }
}
