import 'dart:async';

import 'package:book_read/enums/auth.dart';
import 'package:book_read/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;
  String _userData;
  Firestore db = Firestore.instance;
  final _db = DatabaseService();
  Status _status = Status.Uninitialized;

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
     Timer(Duration(seconds: 3), () =>  _auth.onAuthStateChanged.listen(_onAuthStateChanged));
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  String get userUid => _userData;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      FirebaseUser result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _userData = result.uid;
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();

      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      FirebaseUser user = await _auth.signInWithCredential(credential);
      DocumentSnapshot snap =
          await db.collection('users').document(user.uid).get();
      if (snap.data == null) {
        var data = {
          'displayName': user.displayName.replaceAll(' ', ''),
          'email': user.email,
          'bio': '',
          'fname': '',
          'lname': '',
          'provider': 'google',
          'profile_pic': user.photoUrl,
          'uid': user.uid
        };
        db.collection('users').document(user.uid).setData(data);
      }
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();

      return false;
    }
  }

  Future deleteUser() async {
    print(_user.uid);
    await _db.deleteUser(_user.uid);
    await _user.delete();
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      FirebaseUser user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _userData = user.uid;
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;

      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future signOutGoogle() async {
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
