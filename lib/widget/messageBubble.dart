import 'package:flutter/material.dart';
import 'package:world_talk/providers/messages.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.messages, this.isMe, this.isImage);
  final Messages messages;
  final bool isMe;
  final bool isImage;
  @override
  Widget build(BuildContext context) => Align(
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: isMe ? Colors.amber : Colors.grey,
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              isImage
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: NetworkImage(messages.content))),
                    )
                  : Text(
                      messages.content,
                      style: TextStyle(color: Colors.white),
                    ),
              SizedBox(
                height: 5,
              ),
              Text(
                timeago.format(messages.sentTime),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              )
            ],
          ),
        ),
      );
}
