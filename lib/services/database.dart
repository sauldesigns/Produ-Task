import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/user.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  /// Get a stream of a single document
  Stream<User> streamHero(String uid) {
    var ref = _db.collection('users').document(uid);
    return ref.snapshots().map((doc) => User.fromFirestore(doc));
  }

  /// Write data
  Future<void> createHero(String heroId) {
    return _db.collection('heroes').document(heroId).setData({'poop': 0});
  }
}
