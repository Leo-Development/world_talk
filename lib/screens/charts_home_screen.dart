import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_talk/providers/firebase_provider.dart';
import 'package:world_talk/providers/google_sign_in.dart';
import 'package:world_talk/providers/user_Model.dart';
import 'package:world_talk/screens/auth_screens/welcome.dart';
import 'package:world_talk/screens/charts_screen.dart';
import 'package:world_talk/screens/search_screen.dart';
import 'package:world_talk/services/firebase_storage_services.dart';
import 'package:world_talk/services/notification_service.dart';

import 'package:world_talk/widget/app_drawer.dart';
import 'package:world_talk/widget/empty_widget.dart';
import 'package:world_talk/widget/user_item.dart';

class ChartsHomeScreen extends StatefulWidget {
  const ChartsHomeScreen({super.key});
  static const routeName = 'ChartsHomeScreen';

  @override
  State<ChartsHomeScreen> createState() => _ChartsHomeScreenState();
}

class _ChartsHomeScreenState extends State<ChartsHomeScreen>
    with WidgetsBindingObserver {
  final notificationsService = NotificationsService();

  List? _uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationsService.firebaseNotification(context);
    //Provider.of<FirebaseProvider>(context, listen: false).textedUsers();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreService.updateUserData(
            {'lastActive': DateTime.now(), 'isOnline': true});
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        FirebaseFirestoreService.updateUserData({'isOnline': false});
        break;
    }
  }

  void shapshot() {
    FirebaseFirestore.instance
        .collection('PeopleTalked')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('users')
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
      print('something hads changed in charts');
      // Update _uid list when a new receiverId is added
      _uid = snapshot.docs.map((doc) => doc.id).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _uid = Provider.of<FirebaseProvider>(context, listen: false).uid;
    // Provider.of<FirebaseProvider>(context);

    // final userData = [
    //   UserModel(
    //       uid: '1',
    //       email: 'test@gmail.com',
    //       image:
    //           'https://th.bing.com/th/id/OIP.TajDJ1QTm3GLYemS_tj41gAAAA?rs=1&pid=ImgDetMain',
    //       isOnline: false,
    //       lastActive: DateTime.now(),
    //       name: 'Sondra'),
    //   UserModel(
    //       uid: '1',
    //       email: 'test@gmail.com',
    //       image:
    //           'https://th.bing.com/th/id/OIP.nAULAHriju3jss_wAoxqZwHaJQ?rs=1&pid=ImgDetMain',
    //       isOnline: true,
    //       lastActive: DateTime.now(),
    //       name: 'Gloria'),
    //   UserModel(
    //       uid: '1',
    //       email: 'test@gmail.com',
    //       image:
    //           'https://i.pinimg.com/736x/84/5c/f1/845cf121f5081e65aa09a978e7452b0a.jpg',
    //       isOnline: false,
    //       lastActive: DateTime.now(),
    //       name: 'Max'),
    //   UserModel(
    //       uid: '1',
    //       email: 'test@gmail.com',
    //       image:
    //           'https://th.bing.com/th/id/R.dbb1f5955618f633ea0f3af8e853d0cf?rik=ZWlK9QtEDtNoww&pid=ImgRaw&r=0',
    //       isOnline: true,
    //       lastActive: DateTime.now(),
    //       name: 'Collin')
    // ];
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     //picture functionality
          //   },
          //   icon: Icon(Icons.camera_alt_outlined),
          // ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const UsersSearchScreen(),
              ));
            },
            //search functionality

            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              Provider.of<GoogleSignInPRovider>(context, listen: false)
                  .googleSignOut();
              Navigator.of(context).pushReplacementNamed(WelcomePage.routeName);

              // loging out functionality
              // await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<FirebaseProvider>(context).textedUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _uid!.isEmpty
                ? EmptyWidget(
                    icon: Icons.wordpress_outlined,
                    text: 'Welcome to WorldTalk ')
                : Consumer<FirebaseProvider>(
                    builder: (context, value, child) {
                      return StreamBuilder<List<UserModel>>(
                        stream: Provider.of<FirebaseProvider>(context)
                            .usersTalkedStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (!snapshot.hasData) {
                            print('This is the snapshot data ${snapshot.data}');
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          print('SnapShot has de data');
                          final users = snapshot.data;
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: users!.length,
                            itemBuilder: (context, i) => users[i].uid !=
                                    FirebaseAuth.instance.currentUser?.uid
                                ? UserItem(users[i])
                                : SizedBox(),
                          );
                        },
                      );
                    },
                  );
          }
          return SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 188, 148, 29),
        onPressed: () {
          Navigator.of(context).pushNamed(AllChartsScreen.routeName);
          //setState(() {});
        },
        child: Icon(Icons.chat_rounded),
      ),
    );
  }
}
