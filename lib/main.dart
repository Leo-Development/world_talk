import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_talk/firebase_options.dart';
import 'package:world_talk/providers/auth.dart';
import 'package:world_talk/providers/firebase_provider.dart';
import 'package:world_talk/providers/google_sign_in.dart';

import 'package:world_talk/screens/auth_screens/sign_up.dart';
import 'package:world_talk/screens/auth_screens/welcome.dart';

import 'package:world_talk/screens/charts_home_screen.dart';
import 'package:world_talk/screens/charts_screen.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  print('am in the main');
  await FirebaseAppCheck.instance.activate(
      // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),

      androidProvider: AndroidProvider.debug

      // appleProvider: AppleProvider.appAttest,
      );
  // await FirebaseAppCheck.instance.activate();
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => GoogleSignInPRovider()),
            ChangeNotifierProvider(
              create: (context) => FirebaseProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => Authen(),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: //WelcomePage(),
                StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                print('Snappshot: $snapshot');
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  print('Snapshot has data');
                  // Future.delayed(Duration.zero, () {
                  //   print('User data: ${snapshot.data}');
                  //   Navigator.of(context)
                  //       .pushReplacementNamed(ChartsHomeScreen.routeName);
                  // });
                  return ChartsHomeScreen();
                }

                return WelcomePage();
              },
            ),
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    color: Color.fromARGB(255, 178, 162, 17))),
            routes: {
              ChartsHomeScreen.routeName: (context) => const ChartsHomeScreen(),
              SignUp.routeName: (context) => SignUp(),
              WelcomePage.routeName: (context) => WelcomePage(),
              AllChartsScreen.routeName: (context) => AllChartsScreen(),
            },
          ));
}
