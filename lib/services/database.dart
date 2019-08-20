import 'dart:io';
import 'package:book_read/models/category.dart';
import 'package:book_read/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:convert';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  /// Get's user data passed in by uid of user logged in
  Stream<User> streamHero(String uid) {
    var ref = _db.collection('users').document(uid);
    return ref.snapshots().map((doc) => User.fromFirestore(doc));
  }

  // This gets the tasks created by user logged in and category they are in
  Stream<List<Task>> categoryTasks(User user, String origuser, Category cat) {
    DateTime date = new DateTime.now();
    var ref = _db
        .collection('category')
        .document(cat.id)
        .collection('tasks')
        .where('cat_uid', isEqualTo: cat.id)
        .where('createdat',
            isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day))
        .orderBy('createdat', descending: true);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Task.fromFirestore(doc)).toList());
  }

  // This gets the incomplete tasks  created by user logged in and category they are in
  Stream<List<IncompleteTask>> incompleteTasks(
      User user, String origuser, Category cat) {
    DateTime date = new DateTime.now();
    var ref = _db
        .collection('category')
        .document(cat.id)
        .collection('tasks')
        .where('cat_uid', isEqualTo: cat.id)
        .where('complete', isEqualTo: false)
        .where('createdat',
            isLessThan: DateTime(date.year, date.month, date.day))
        .orderBy('createdat', descending: true);

    return ref.snapshots().map((list) => list.documents
        .map((doc) => IncompleteTask.fromFirestore(doc))
        .toList());
  }

  // this gets all the tasks created by user in a specific category
  Stream<List<AllTasks>> allTasks(User user, String origuser, Category cat) {
    var ref = _db
        .collection('category')
        .document(cat.id)
        .collection('tasks')
        .where('cat_uid', isEqualTo: cat.id)
        .orderBy('createdat', descending: true);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => AllTasks.fromFirestore(doc)).toList());
  }

  Stream<List<IncompleteTaskCounter>> incompleteTaskCounter(
      User user, String origuser, Category cat) {
    var ref = _db
        .collection('category')
        .document(cat.id)
        .collection('tasks')
        .where('cat_uid', isEqualTo: cat.id)
        .where('complete', isEqualTo: false);

    return ref.snapshots().map((list) => list.documents
        .map((doc) => IncompleteTaskCounter.fromFirestore(doc))
        .toList());
  }

  // this gets all users data in data base
  Stream<List<User>> streamUsers(String query) {
    var ref = _db
        .collection('users')
        .orderBy('displayName', descending: false)
        .startAt([query]).limit(20);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => User.fromFirestore(doc)).toList());
  }

  //  this gets categories created by the user logged in
  Stream<List<Category>> streamWeapons(FirebaseUser user) {
    var ref = _db
        .collection('category')
        .where('uids', arrayContains: user.uid)
        .orderBy('createdat', descending: true);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Category.fromFirestore(doc)).toList());
  }

  void updateDocument(
      {String collection, String docID, Map<String, dynamic> data}) {
    _db.collection(collection).document(docID).updateData(data);
  }

  // Future getBookData(String query) async {
  //   var response = await http.get(
  //       Uri.encodeFull('http://openlibrary.org/search.json?title=' + query),
  //       headers: {
  //         'Accept': 'application/json',
  //       });

  //   var localData = json.decode(response.body);

  //   var bookData = [];
  //   var newDat;

  //   for (int i = 0; i < localData['docs'].length; ++i) {
  //     if (localData['docs'][i] != null) {
  //       newDat = localData['docs'][i];
  //       print(newDat);
  //       bookData.add(newDat);
  //     }
  //     print(bookData);
  //   }

  //   return bookData;
  // }

  // this deletes the database document of user
  Future<void> deleteUser(String uid) {
    return _db.collection('users').document(uid).delete();
  }

  // this opens up image picker on device, and allows user to
  // upload to the firebase database.

  Future<void> uploadProfilePicture(FirebaseUser user) async {
    UserUpdateInfo userUpdateData = new UserUpdateInfo();

    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      var imagePath = _image.path;

      String fileName = imagePath.split('/').last;

      StorageReference reference =
          _storage.ref().child('users/${user.uid}/images/$fileName');

      StorageUploadTask uploadTask = reference.putFile(_image);

      String location =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      userUpdateData.photoUrl = location;
      userUpdateData.displayName = user.displayName;
      user.updateProfile(userUpdateData);
      var now = DateTime.now();
      var data = {'imgUrl': location, 'uid': user.uid, 'createdAt': now};
      _db
          .collection('users')
          .document(user.uid)
          .updateData({'profile_pic': location});
      _db.collection('photo_content').add(data);
    }
  }
}
