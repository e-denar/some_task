import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:some_task/models/user.dart';

class FirestoreService {
  Future createUser(UserModel user) async {
    final _firestore = FirebaseFirestore.instance;
    return await _firestore
        .doc('/users/${user.uid}')
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future updateUser(UserModel user) async {
    final _firestore = FirebaseFirestore.instance;
    return await _firestore
        .doc('/users/${user.uid}')
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future<List<UserModel>> fetchUsers() async {
    return await FirebaseFirestore.instance
        .collection('/users')
        .get()
        .then((value) {
      List<UserModel> _data = [];
      value.docs.forEach((e) {
        _data.add(UserModel.fromJson(e.data()));
      });
      return _data;
    });
  }

  Future deleteUser(String uid) async {
    return await FirebaseFirestore.instance.doc('/users/$uid').delete();
  }

  Future uploadFile(String imagePath, String userId) async {
    return await FirebaseStorage.instance
        .ref()
        .child('/photos/$userId.jpg')
        .putFile(File(imagePath));
  }

  Future getDownloadUrl(String userId) async {
    return await FirebaseStorage.instance
        .ref()
        .child('/photos/$userId.jpg')
        .getDownloadURL();
  }
}
