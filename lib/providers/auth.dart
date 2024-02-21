import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:world_talk/main.dart';
import 'package:world_talk/screens/charts_home_screen.dart';

class Authen with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  Future<void> submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext context) async {
    UserCredential _usercredentials;
    try {
      if (isLogin) {
        _usercredentials = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        // Main();
        print('This is the creditions $_usercredentials');
      } else {
        _usercredentials = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_usercredentials.user!.uid)
            .set({
          'name': username,
          'email': email,
          'uid': _usercredentials.user!.uid,
          'lastActive': DateTime.now(),
          'isOnline': false,
          'image':
              'https://th.bing.com/th/id/OIG1.caoSPxO63jQvFK85Xz6r?pid=ImgGn',
          //https://th.bing.com/th/id/R.4ade69fbc3e3bc4773afcbb81f9dace3?rik=WMXSXNHtc0%2bkDw&pid=ImgRaw&r=0
        });
      }
      print('Outside of the if');
      Navigator.of(context).pushReplacementNamed(ChartsHomeScreen.routeName);
      Main();
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credintials';
      if (err.message != null) {
        message = err.message.toString();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
  }
}
