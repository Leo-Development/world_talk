import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:world_talk/providers/user_Model.dart';

class FirebaseFirestoreService {
  static Future<String> uploadImage(Uint8List file, String storagePath) async =>
      await FirebaseStorage.instance
          .ref()
          .child(storagePath)
          .putData(file)
          .then((task) => task.ref.getDownloadURL());

  static Future<void> updateUserData(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(data);
    // print('IT has been changed');
  }

  static Future<List<UserModel>> searchUser(String name) async {
    final snapShot = await FirebaseFirestore.instance
        .collection('Users')
        .where("name", isGreaterThanOrEqualTo: name)
        .get();
    return snapShot.docs.map((e) => UserModel.fromJson(e.data())).toList();
  }
}
