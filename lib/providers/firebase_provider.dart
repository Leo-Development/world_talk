import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_talk/services/firebase_storage_services.dart';
import 'package:world_talk/providers/messages.dart';
import 'package:world_talk/providers/user_Model.dart';

class FirebaseProvider extends ChangeNotifier {
  UserModel? user;
  ScrollController scrollController = ScrollController();

  List<Messages> sentMessages = [];
  List<Messages> receivedMessages = [];
  List<Messages> allMessages = [];
  List<UserModel> search = [];
  List<String> uid = [];

  void combineMessages() {
    allMessages = [...sentMessages, ...receivedMessages];
  }

  Stream<List<UserModel>> usersStream() {
    return FirebaseFirestore.instance
        .collection('Users')
        .snapshots(includeMetadataChanges: true)
        .map((users) {
      try {
        // print('in the tryyyyyyyy');
        return users.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      } catch (e) {
        print('Error reading from Firestore or parsing data: $e');
        return [];
      }
    });
  }

  Stream<List<UserModel>> usersTalkedStream() {
    // Listen for changes in the 'PeopleTalked' collection

    // Return a stream of UserModel objects
    return FirebaseFirestore.instance
        .collection('Users')
        .where(FieldPath.documentId, whereIn: uid)
        .snapshots(includeMetadataChanges: true)
        .map((users) {
      try {
        return users.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      } catch (e) {
        print('Error reading from Firestore or parsing data: $e');
        return [];
      }
    });
  }

  static Future<void> addTextMessage(
      {required String context, required String receiverId}) async {
    final message = Messages(
        messagetype: MessageType.text,
        receiverId: receiverId,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        sentTime: DateTime.now(),
        content: context);
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> addImageMessage(Uint8List file, String receiverId) async {
    final image = await FirebaseFirestoreService.uploadImage(
        file, 'image/chat/${DateTime.now()}');
    // print('This is 2 $file');
    // final image = FirebaseStorage.instance
    //     .ref('uploads/file-to-upload.png')
    //     .putFile(file);

    // final path = 'files/${file}';
    // final ref = FirebaseStorage.instance.ref().child(path);
    //  print('THis is the image $image ;)');
    final message = Messages(
        messagetype: MessageType.image,
        receiverId: receiverId,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        sentTime: DateTime.now(),
        content: image);
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> addUser() async {
    final userCredential = FirebaseAuth.instance.currentUser;

    final credential = UserModel(
        uid: userCredential!.uid,
        email: userCredential.email.toString(),
        image: userCredential.photoURL.toString(),
        isOnline: false,
        lastActive: DateTime.now(),
        name: userCredential.displayName.toString());
    await _addUserToChat(credential);
  }

  static _addUserToChat(UserModel userModel) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set(userModel.toJson());
  }

  Future<void> textedUsers() async {
    try {
      final chatsSentSnapshot = await FirebaseFirestore.instance
          .collection('PeopleTalked')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('users')
          .get();

      print('Fetched ${chatsSentSnapshot.docs.length} documents');

      for (var doc in chatsSentSnapshot.docs) {
        print('printing doc below');
        uid.add(doc.id);
      }

      print('in textedUsers');
      for (var l in uid) {
        print('printing list below');
        print(l);
      }
    } catch (e) {
      print('Error in textedUsers: $e');
    }
  }

  static _addMessageToChat(String receiverId, Messages messages) async {
    await FirebaseFirestore.instance
        .collection('usersMessages')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chatsSent')
        .doc(receiverId)
        .collection('messages')
        .add(messages.toJson());

    await FirebaseFirestore.instance
        .collection('usersMessages')
        .doc(receiverId)
        .collection('chatsReceived')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(messages.toJson());

    await FirebaseFirestore.instance
        .collection('PeopleTalked')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('users')
        .doc(receiverId)
        .set({'receiverId': receiverId})
        .then((value) => print("ReceiverId added to new collection"))
        .catchError((error) => print("Failed to add receiverId: $error"));
  }

  UserModel? getUserById(String userId) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = UserModel.fromJson(user.data()!);
      notifyListeners();
    });
    //  print('This are the users $user');
    return user;
  }

  List<Messages> getSendersMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('usersMessages')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chatsSent')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.sentMessages =
          messages.docs.map((doc) => Messages.fromJson(doc.data())).toList();
      // print('Getting senders messages');
      combineMessages();
      notifyListeners();
      scrollDown();
    });
    // print('Getting senders messages');
    return sentMessages;
  }

  List<Messages> getReciversMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('usersMessages')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chatsReceived')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.receivedMessages =
          messages.docs.map((doc) => Messages.fromJson(doc.data())).toList();
      // print('getting receivers messages1');
      combineMessages();
      notifyListeners();
      scrollDown();
    });
    // print('getting receivers messages');
    return receivedMessages;
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });

  Future<void> searchUser(String name) async {
    search = await FirebaseFirestoreService.searchUser(name);
    notifyListeners();
  }
}
