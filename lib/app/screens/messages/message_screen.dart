import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matus_app/app/models/message.dart';
import 'package:matus_app/app/models/user.dart';

import 'components/message_list_tile.dart';

class MessageScreen extends StatefulWidget {
  final User user;

  const MessageScreen({Key key, this.user}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Message> filteredMessages = [];
  List<Message> allMessages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagens'),
        centerTitle: true,
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

                    // filteredMessages = [];
                    // for (final Message message in allMessages) {
                    //   if (message.userReceptor == widget.user.id) {
                    //     if (filteredMessages.isEmpty) {
                    //       filteredMessages.add(message);
                    //     } else {
                    //       for (final Message filtered in filteredMessages) {
                    //         if (!filtered.userSender
                    //             .contains(message.userSender)) {
                    //           filteredMessages.add(message);
                    //         }
                    //       }
                    //     }
                    //   }
                    // }

                    return ListView.builder(
                        itemCount: allMessages.length,
                        itemBuilder: (context, index) {
                          return MessageListTile(message: allMessages[index]);
                        });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
