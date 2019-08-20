import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final Timestamp createdAt;
  final String coverImg;
  final String catUid;
  final bool complete;
  final bool done;
  final int color;
  final String createdBy;

  Task(
      {this.id,
      this.title,
      this.catUid,
      this.complete,
      this.color,
      this.createdAt,
      this.coverImg,
      this.createdBy,
      this.done});

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Task(
        id: doc.documentID,
        title: data['content'] ?? '...',
        createdAt: data['createdat'],
        coverImg: data['cover_img'] ?? '',
        done: data['done'],
        createdBy: data['createdby'] ?? '...',
        complete: data['complete'] ?? false,
        catUid: data['cat_uid'],
        color: data['color']);
  }
}

class IncompleteTask {
  final String id;
  final String title;
  final Timestamp createdAt;
  final String coverImg;
  final String catUid;
  final bool complete;
  final bool done;
  final int color;
  final String createdBy;

  IncompleteTask(
      {this.id,
      this.title,
      this.catUid,
      this.complete,
      this.color,
      this.createdAt,
      this.coverImg,
      this.createdBy,
      this.done});

  factory IncompleteTask.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return IncompleteTask(
        id: doc.documentID,
        title: data['content'] ?? '...',
        createdAt: data['createdat'],
        coverImg: data['cover_img'] ?? '',
        done: data['done'],
        createdBy: data['createdby'] ?? '...',
        complete: data['complete'] ?? false,
        catUid: data['cat_uid'],
        color: data['color']);
  }
}

class AllTasks {
  final String id;
  final String title;
  final Timestamp createdAt;
  final String coverImg;
  final String catUid;
  final bool complete;
  final bool done;
  final int color;
  final String createdBy;

  AllTasks(
      {this.id,
      this.title,
      this.catUid,
      this.complete,
      this.color,
      this.createdAt,
      this.coverImg,
      this.createdBy,
      this.done});

  factory AllTasks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return AllTasks(
        id: doc.documentID,
        title: data['content'] ?? '...',
        createdAt: data['createdat'],
        coverImg: data['cover_img'] ?? '',
        done: data['done'],
        createdBy: data['createdby'] ?? '...',
        complete: data['complete'] ?? false,
        catUid: data['cat_uid'],
        color: data['color']);
  }
}

class IncompleteTaskCounter {
  final String id;
  final String title;
  final String catUid;
  final bool complete;
  final int badge;

  IncompleteTaskCounter({
    this.id,
    this.title,
    this.catUid,
    this.badge,
    this.complete,
  });

  factory IncompleteTaskCounter.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return IncompleteTaskCounter(
      id: doc.documentID,
      title: data['content'] ?? '...',
      complete: data['complete'] ?? false,
      badge: data['badge'] ?? 0,
      catUid: data['cat_uid'],
    );
  }

  factory IncompleteTaskCounter.initialData() {
    return IncompleteTaskCounter(
      id: '',
      title: '...',
      complete: false,
      badge: 0,
      catUid: '',
    );
   
  }
}
