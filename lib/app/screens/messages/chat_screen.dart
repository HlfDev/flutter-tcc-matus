import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:matus_app/app/models/user.dart';
import 'package:matus_app/app/screens/messages/text_composer.dart';

import 'chat_message.dart';

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
    }

    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('App'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('userSender', isEqualTo: widget.userReceptor.id)
                  .where('userReceptor', isEqualTo: widget.userSender.id)
                  //.orderBy('messageDate')
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    final List<DocumentSnapshot> documents =
                        snapshot.data.docs.reversed.toList();

                    return ListView.builder(
                        itemCount: documents.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return ChatMessage(
                              documents[index].data(),
                              documents[index]['userSender'] ==
                                  widget.userSender.id);
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
