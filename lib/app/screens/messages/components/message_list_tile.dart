import 'package:flutter/material.dart';
import 'package:matus_app/app/models/message.dart';

class MessageListTile extends StatelessWidget {
  const MessageListTile({Key key, this.message}) : super(key: key);

  final Message message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 100.0,
        color: Colors.blue,
        child: Column(
          children: [
            Text(message.text),
          ],
        ),
      ),
    );
  }
}
