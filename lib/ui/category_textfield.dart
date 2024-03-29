import 'package:book_read/models/category.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryTextField extends StatefulWidget {
  CategoryTextField({Key key, this.doc, this.content = '', this.type})
      : super(key: key);
  final String type;
  final Category doc;
  final String content;
  @override
  State<StatefulWidget> createState() {
    return _TaskTextFieldState();
  }
}

class _TaskTextFieldState extends State<CategoryTextField> {
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
      autofocus: true,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      cursorColor: Colors.white,
      maxLines: 4,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: InputBorder.none,
          hasFloatingPlaceholder: false,
          hintText: 'Enter Text Here'),
      onSubmitted: (String value) {
        if (value == '') {
          db.collection(widget.type).document(widget.doc.id).delete();
        } else {
          var data = {'done': true, 'content': value};
          db.collection(widget.type).document(widget.doc.id).updateData(data);
        }
      },
    );
  }
}
