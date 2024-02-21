import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:world_talk/providers/firebase_provider.dart';
import 'package:world_talk/screens/charts_home_screen.dart';
import 'package:world_talk/services/firebase_storage_services.dart';
import 'package:world_talk/services/notification_service.dart';

class GoogleSignInPRovider extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  static final notifications = NotificationsService();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;
  //This is what will keep the data of the user that has signed in

  Future googleSignUp(BuildContext context) async {
    final googleUser = await _googleSignIn.signIn();
    //we are now storing the information of the signed in user
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential.additionalUserInfo!.isNewUser) {
      FirebaseProvider.addUser();
      await FirebaseFirestoreService.updateUserData(
          {'lastActive': DateTime.now()});
    }
    // Navigator.pushNamed(context, ChartScreen.routeName);
    await notifications.requestPermission();
    await notifications.getToken();
    Navigator.of(context).pushReplacementNamed(ChartsHomeScreen.routeName);

    // print(userCredential);
    notifyListeners();
  }

  Future googleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();

    notifyListeners();
  }

  Future faceBookSignIn() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final OAuthCredential oAuthCredential =
          FacebookAuthProvider.credential(accessToken.token);
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      final user = userCredential.user;
      print('Signed in as ${user?.displayName}');
      print('Access token: ${accessToken.token}');
    } else {
      print('Login failed');
    }
    notifyListeners();
  }
}
