import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_talk/providers/firebase_provider.dart';
import 'package:world_talk/widget/TextFormField.dart';
import 'package:world_talk/widget/chartMessages.dart';

class ChartScreen extends StatefulWidget {
  static const routeName = 'ChartScreen';
  const ChartScreen(this.userId);
  final String userId;

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.userId)
      ..getSendersMessages(widget.userId)
      ..getReciversMessages(widget.userId);
    print('This is the userID ${widget.userId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: ChartMessages(widget.userId)),
          TextFormmField(
            widget.userId,
            () {},
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      title: Consumer<FirebaseProvider>(
        builder: (context, value, child) => value.user != null
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(value.user!.image),
                    radius: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        value.user!.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        value.user!.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                            color: value.user!.isOnline
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 14),
                      )
                    ],
                  )
                ],
              )
            : SizedBox(),
      ));
}

// AppBar _buildAppBar() {AppBar()
// }
