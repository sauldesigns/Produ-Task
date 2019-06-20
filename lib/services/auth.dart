import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<FirebaseUser> signInGoogle();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> resetPassword(String email);
}

class Auth implements BaseAuth {
  Firestore db = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signIn(String email, String password) async {
    // var user = Provider.of<FirebaseUser>(context);
    var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<FirebaseUser> signInGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication auth = await googleSignInAccount.authentication;

    FirebaseUser user = await _firebaseAuth.signInWithCredential(
      GoogleAuthProvider.getCredential(
          accessToken: auth.accessToken, idToken: auth.idToken),
    );

    return user;
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> resetPassword(String email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
