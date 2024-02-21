import 'package:flutter/material.dart';
import 'package:world_talk/providers/user_Model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:world_talk/screens/chat_screen.dart';

class UserItem extends StatefulWidget {
  const UserItem(this.user);
  final UserModel user;
  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChartScreen(widget.user.uid))),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(alignment: Alignment.bottomRight, children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.user.image),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              backgroundColor:
                  widget.user.isOnline ? Colors.green : Colors.grey,
              radius: 5,
            ),
          )
        ]),
        title: Text(
          widget.user.name,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Last Active: ${timeago.format(widget.user.lastActive)}',
          maxLines: 2,
          style: TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
