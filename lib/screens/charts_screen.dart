import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_talk/providers/firebase_provider.dart';
import 'package:world_talk/providers/user_Model.dart';
import 'package:world_talk/screens/search_screen.dart';
import 'package:world_talk/widget/user_item.dart';

class AllChartsScreen extends StatelessWidget {
  const AllChartsScreen({super.key});
  static const routeName = 'ChartsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select friend'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const UsersSearchScreen(),
              ));
            },
            //search functionality

            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer<FirebaseProvider>(
        builder: (context, value, child) {
          return StreamBuilder<List<UserModel>>(
            stream: Provider.of<FirebaseProvider>(context).usersStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print('This is the snapshot data ${snapshot.data}');
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              print('SnapShot has de data');
              final users = snapshot.data;
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: users!.length,
                itemBuilder: (context, i) =>
                    users[i].uid != FirebaseAuth.instance.currentUser?.uid
                        ? UserItem(users[i])
                        : SizedBox(),
              );
            },
          );
        },
      ),
    );
  }
}
