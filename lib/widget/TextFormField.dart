import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_talk/providers/firebase_provider.dart';
import 'package:world_talk/screens/charts_home_screen.dart';
import 'package:world_talk/services/media_services.dart';
import 'package:world_talk/services/notification_service.dart';
import 'package:world_talk/widget/custom_text_form_field.dart';

class TextFormmField extends StatefulWidget {
  final String _userid;
  final VoidCallback onButtonPressed;
  TextFormmField(this._userid, this.onButtonPressed);

  @override
  State<TextFormmField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<TextFormmField> {
  final TextEditingController _controller = TextEditingController();
  final notificationsService = NotificationsService();
  Uint8List? image;

  @override
  void initState() {
    // TODO: implement initState
    notificationsService.getReceiverToken(widget._userid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: CustomTextFormField(
              controller: _controller,
              hintText: 'Type your message here',
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () => _sendImage(),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            _sendText(context);
            widget.onButtonPressed();
          },
        ),
      ],
    );
  }

  Future<void> _sendText(BuildContext context) async {
    if (_controller.text.isNotEmpty) {
      await FirebaseProvider.addTextMessage(
          context: _controller.text, receiverId: widget._userid);
      await notificationsService.sendNotification(
        body: '${_controller.text}',
        senderId: FirebaseAuth.instance.currentUser!.uid,
      );
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _sendImage() async {
    final pickedImgae = await MediaService.pickImage();

    print('this is the image $image');
    setState(() => image = pickedImgae);
    if (image != null) {
      await FirebaseProvider.addImageMessage(image!, widget._userid);
      await notificationsService.sendNotification(
        body: 'image ${Icon(Icons.camera)}',
        senderId: FirebaseAuth.instance.currentUser!.uid,
      );
    }
  }
}
