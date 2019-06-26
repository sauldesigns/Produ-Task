import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String title;
  final Timestamp createdAt;
  final String coverImg;
  final bool done;
  final int color;

  Category({ this.id, this.title, this.color, this.createdAt, this.coverImg, this.done});

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    
    return Category(
      id: doc.documentID,
      title: data['content'] ?? '',
      createdAt: data['createdat'],
      coverImg: data['cover_img'] ?? '',
      done: data['done'],
      color: data['color']
    );
  }

}