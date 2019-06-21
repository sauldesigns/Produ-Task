import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final Timestamp createdAt;
  final String coverImg;

  Book({ this.id, this.title, this.createdAt, this.coverImg, });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    
    return Book(
      id: doc.documentID,
      title: data['title'] ?? '',
      createdAt: data['created_at'],
      coverImg: data['cover_img'] ?? ''
    );
  }

}