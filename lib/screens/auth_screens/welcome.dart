import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:world_talk/screens/auth_screens/sign_up.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = '/WelcomePage';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background3.jpg'),
                  fit: BoxFit.cover),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(
                    0), // This container must be present and it can be transparent.
              ),
            ),
          ),
          Container(
              width: double.infinity,
              // decoration: const BoxDecoration(
              //   color: Color(0xFF212121),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipPath(
                              clipper: WaveClipperTwo(),
                              child: Container(
                                  width: 400.0,
                                  height: 120.0,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFFf99321),
                                        Color(0xFFfc5a3b),
                                      ],
                                    ),
                                  ),
                                  child: Image(
                                    image:
                                        AssetImage('assets/WorldTalk_auth.jpg'),
                                    alignment: Alignment.bottomLeft,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35),
                          child: AnimatedOpacity(
                              opacity: 1,
                              duration: Duration(milliseconds: 1600),
                              child: Text(
                                'Join a community \nof world talkers',
                                style: TextStyle(
                                    color: Color(0xFFcccccf),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40),
                              )),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35),
                          child: AnimatedOpacity(
                              opacity: 1,
                              duration: Duration(milliseconds: 1600),
                              child: Text(
                                'A simple , fun , and creative way to \nshare photos , videos , messages\nwith friends and family ',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: AnimatedOpacity(
                              opacity: 1,
                              duration: const Duration(milliseconds: 1600),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.orange),
                                    splashFactory: InkSparkle.splashFactory,
                                    fixedSize:
                                        MaterialStatePropertyAll(Size(380, 50)
                                            // Size.fromWidth(380),
                                            ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(SignUp.routeName);
                                  },
                                  child: const Text(
                                    'Lets get you talking',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35),
                          child: AnimatedOpacity(
                              opacity: 1,
                              duration: Duration(milliseconds: 1600),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'To get and enjoy more features of the world talking app, Please visit ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                    TextSpan(
                                      text: 'this site',
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final url =
                                              'https://www.youtube.com/';
                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 35),
                        //   child: AnimatedOpacity(
                        //       opacity: 1,
                        //       duration: const Duration(milliseconds: 1600),
                        //       child: ClipRRect(
                        //         borderRadius: BorderRadius.circular(25),
                        //         child: ElevatedButton(
                        //           style: const ButtonStyle(
                        //             backgroundColor: MaterialStatePropertyAll(
                        //                 Color.fromARGB(255, 233, 144, 10)),
                        //             splashFactory: InkSparkle.splashFactory,
                        //             fixedSize:
                        //                 MaterialStatePropertyAll(Size(380, 50)
                        //                     // Size.fromWidth(380),
                        //                     ),
                        //           ),
                        //           onPressed: () {
                        //             Navigator.of(context)
                        //                 .pushNamed(SignIn.routeName);
                        //           },
                        //           child: const Text(
                        //             'Sign In',
                        //             style: TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 17),
                        //           ),
                        //         ),
                        //       )),
                        // ),
                        // const SizedBox(
                        //   height: 30,
                        // ),
                      ],
                    ),
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}
