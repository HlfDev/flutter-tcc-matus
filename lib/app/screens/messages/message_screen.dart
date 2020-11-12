import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matus_app/app/models/message.dart';
import 'package:matus_app/app/models/user.dart';
import 'package:matus_app/app/themes/app_colors.dart';

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

                    filteredMessages = [];
                    for (final Message message in allMessages) {
                      if (message.userReceptor == widget.user.id) {
                        if (filteredMessages.isEmpty) {
                          filteredMessages.add(message);
                        } else {
                          for (final Message filtered in filteredMessages) {
                            if (!filtered.userSender
                                .contains(message.userSender)) {
                              filteredMessages.add(message);
                            }
                          }
                        }
                      }
                    }

                    if (filteredMessages.isNotEmpty) {
                      return ListView.builder(
                          itemCount: filteredMessages.length,
                          itemBuilder: (context, index) {
                            return MessageListTile(
                                message: filteredMessages[index]);
                          });
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/message_screen/message_not_found.svg',
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: Text(
                                'Você não possui mensagens',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.primaryColor,
                                    fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
