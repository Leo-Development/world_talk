import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_talk/providers/firebase_provider.dart';
import 'package:world_talk/providers/messages.dart';
import 'package:world_talk/widget/empty_widget.dart';
import 'package:world_talk/widget/messageBubble.dart';

class ChartMessages extends StatelessWidget {
  ChartMessages(this.receiverId);
  final String receiverId;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) => Consumer<FirebaseProvider>(
      builder: (context, value, child) => Column(children: [
            // value.allMessages.sort((a, b) => b.sentTime.compareTo(a.sentTime)),
            value.allMessages.isEmpty
                ? const Expanded(
                    child: EmptyWidget(
                        icon: Icons.waving_hand, text: 'Say Hello!'),
                  )
                : Expanded(
                    child: ListView.builder(
                      controller:
                          Provider.of<FirebaseProvider>(context, listen: false)
                              .scrollController,
                      shrinkWrap: true,
                      itemCount: value.allMessages.length,
                      itemBuilder: (context, i) {
                        // print('THis is are the messages ${value.messages.}');
                        value.allMessages
                            .sort((a, b) => a.sentTime.compareTo(b.sentTime));
                        final isMe =
                            currentUserId == value.allMessages[i].senderId;
                        final isTextMessage =
                            value.allMessages[i].messagetype ==
                                MessageType.text;
                        return isTextMessage
                            ? MessageBubble(value.allMessages[i], isMe, false)
                            : MessageBubble(value.allMessages[i], isMe, true);
                      },
                    ),
                  ),
          ]));
}
