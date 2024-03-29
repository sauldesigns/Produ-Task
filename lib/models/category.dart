import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String title;
  final Timestamp createdAt;
  final String coverImg;
  final bool done;
  final String uid;
  final int badge;
  final List<dynamic> shareList;
  // final List<dynamic> shareUsers;
  final int color;

  Category(
      {this.id,
      this.uid,
      this.badge,
      this.shareList,
      this.title,
      this.color,
      this.createdAt,
      this.coverImg,
      this.done});

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Category(
      id: doc.documentID,
      uid: data['uid'],
      title: data['content'] ?? '',
      createdAt: data['createdat'],
      coverImg: data['cover_img'] ?? '',
      done: data['done'] ?? false,
      color: data['color'] ?? 0,
      badge: data['badge'] ?? 0,
      shareList: data['uids'],
      // shareUsers: data['users']
    );
  }
}
