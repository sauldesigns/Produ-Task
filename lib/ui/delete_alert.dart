import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteAlert extends StatelessWidget {
  final String docID;
  final String categoryID;
  final String collection;
  final bool isTask;
  DeleteAlert(
      {Key key,
      this.docID,
      this.categoryID,
      this.collection,
      this.isTask = false})
      : super(key: key);

  final Firestore db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete item'),
      content: Text('Are you sure you want to delete this item?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Delete'),
          onPressed: () {
            if (isTask) {
              db
                  .collection(collection)
                  .document(categoryID)
                  .collection('tasks')
                  .document(docID)
                  .delete();
            } else {
              db.collection(collection).document(categoryID).delete();
            }
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
