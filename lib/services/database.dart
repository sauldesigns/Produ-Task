import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  /// Get a stream of a single document
  Stream<User> streamHero(String uid) {
    var ref = _db.collection('users').document(uid);
    return ref.snapshots().map((doc) => User.fromFirestore(doc));
  }

  Future getBookData(String query) async {
    var response = await http.get(
        Uri.encodeFull('http://openlibrary.org/search.json?title=' + query),
        headers: {
          'Accept': 'application/json',
        });

    var localData = json.decode(response.body);

    var bookData = [];
    var newDat;

    for (int i = 0; i < localData['docs'].length; ++i) {
      if (localData['docs'][i] != null) {
        newDat = localData['docs'][i];
        print(newDat);
        bookData.add(newDat);
      }
      print(bookData);
    }

    return bookData;
  }

  Future<void> uploadProfilePicture(String uid) async {
    File _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);

    if (_image != null) {
      var imagePath = _image.path;

      String fileName = imagePath.split('/').last;

      StorageReference reference =
          _storage.ref().child('users/$uid/images/$fileName');

      StorageUploadTask uploadTask = reference.putFile(_image);

      String location =
          await (await uploadTask.onComplete).ref.getDownloadURL();

      var now = DateTime.now();
      var data = {'imgUrl': location, 'uid': uid, 'createdAt': now};
      _db
          .collection('users')
          .document(uid)
          .updateData({'profile_pic': location});
      _db.collection('photo_content').add(data);
    }
  }
}
