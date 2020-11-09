import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:matus_app/app/models/message.dart';

import 'package:matus_app/app/models/user.dart';
import 'package:matus_app/app/screens/messages/components/text_composer.dart';

import 'components/chat_tile.dart';

class ChatScreen extends StatefulWidget {
  final User userReceptor;
  final User userSender;

  const ChatScreen({@required this.userReceptor, @required this.userSender});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  // ignore: avoid_void_async
  void _sendMessage({String text, File imgFile}) async {
    final Map<String, dynamic> data = {
      "userReceptor": widget.userReceptor.id,
      "userSender": widget.userSender.id,
      "messageDate": Timestamp.now(),
      "photoUrl": null,
      "text": null,
    };

    if (imgFile != null) {
      final StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child(widget.userSender.id +
              DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      setState(() {
        _isLoading = true;
      });

      final StorageTaskSnapshot taskSnapshot = await task.onComplete;
      final String url = await taskSnapshot.ref.getDownloadURL() as String;
      data['photoUrl'] = url;

      setState(() {
        _isLoading = false;
      });
    } else {}

    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  List<Message> filteredMessages = [];
  List<Message> allMessages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userReceptor.photoUrl),
              backgroundColor: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(widget.userReceptor.name),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('messageDate')
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    allMessages = snapshot.data.docs.reversed
                        .map((d) => Message.fromDocument(d))
                        .toList();

                    filteredMessages = [];
                    for (final Message message in allMessages) {
                      if ((message.userReceptor == widget.userReceptor.id ||
                              message.userReceptor == widget.userSender.id) &&
                          (message.userSender == widget.userSender.id ||
                              message.userSender == widget.userReceptor.id)) {
                        filteredMessages.add(message);
                      }
                    }

                    return ListView.builder(
                        itemCount: filteredMessages.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return ChatMessage(
                              filteredMessages[index],
                              filteredMessages[index].userSender ==
                                  widget.userSender?.id,
                              widget.userReceptor,
                              widget.userSender);
                        });
                }
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator() else Container(),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}
