import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String fname;
  final String lname;
  final String profilePic;
  final String bio;
  final String provider;

  User({
    this.bio,
    this.username,
    this.email,
    this.fname,
    this.lname,
    this.profilePic,
    this.uid,
    this.provider,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    if (data == null) {
      return User.initialData();
    } else {
      return User(
        uid: doc.documentID,
        username: data['displayName'] ?? '...',
        fname: data['fname'] ?? '...',
        lname: data['lname'] ?? '...',
        email: data['email'] ?? '...',
        provider: data['provider'] ?? 'email',
        profilePic: data['profile_pic'] ?? null,
        bio: data['bio'] ?? '...',
      );
    }
  }

  factory User.initialData() {
    return User(
        uid: null,
        username: 'Loading..',
        fname: 'Loading..',
        lname: 'Loading...',
        email: 'Loading..',
        provider: 'Loading..',
        profilePic: null,
        bio: 'Loading..');
  }
}
