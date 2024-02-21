import 'package:flutter/material.dart';
//import 'package:world_talk/screens/animation_screen.dart';
//import 'package:world_talk/screens/camera_screen.dart';
import 'package:world_talk/screens/charts_home_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.black87, Colors.amber])),
        child: Column(
          children: [
            AppBar(
              title: Text('Welcome to world talk'),
              backgroundColor: const Color.fromARGB(255, 190, 147, 17),
            ),
            Divider(),
            SizedBox(
              height: 100,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'To explore extra oridinary features of World Talk visit www.WorldTalk.Com ',
                  style: TextStyle(fontSize: 22, color: Colors.amber),
                ),
              ),
            )
            // ListTile(
            //   leading: Icon(Icons.group),
            //   title: Text('CHART'),
            //   onTap: () {
            //     Navigator.of(context).pushNamed(ChartsScreen.routeName);
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.music_note),
            //   title: Text('MUSIC'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.animation),
            //   title: Text('ANIMATION'),
            //   onTap: () {
            //     Navigator.of(context).pushNamed(AnimationScreen.routeName);
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text('VIDEOS'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.phone),
            //   title: Text('CALLS'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.video_call),
            //   title: Text('VIDEO CALLS'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.business),
            //   title: Text('BUSSINESS'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.map),
            //   title: Text('WORLD MAP'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.church_rounded),
            //   title: Text('MY CHRUCH'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.emoji_emotions),
            //   title: Text('WORLD OF JOCKES'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.camera),
            //   title: Text('CAMERA'),
            //   onTap: () {
            //     Navigator.of(context).pushNamed(CameraScreen.routeName);
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
