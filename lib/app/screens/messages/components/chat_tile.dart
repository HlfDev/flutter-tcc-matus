import 'package:flutter/material.dart';
import 'package:matus_app/app/helpers/datetime_converter.dart';
import 'package:matus_app/app/models/message.dart';
import 'package:matus_app/app/models/user.dart';

class ChatMessage extends StatelessWidget {
  // ignore: avoid_positional_boolean_parameters
  const ChatMessage(
      // ignore: avoid_positional_boolean_parameters
      this.message,
      // ignore: avoid_positional_boolean_parameters
      this.mine,
      this.userReceptor,
      this.userSender);

  final Message message;
  final bool mine;
  final User userReceptor;
  final User userSender;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: <Widget>[
          if (!mine)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  userReceptor.photoUrl,
                ),
              ),
            )
          else
            Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                if (message.photoUrl != null)
                  Image.network(
                    message.photoUrl,
                    width: MediaQuery.of(context).size.width * 0.4,
                    fit: BoxFit.contain,
                  )
                else
                  Text(
                    message.text,
                    textAlign: mine ? TextAlign.end : TextAlign.start,
                    style: const TextStyle(fontSize: 16),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    convertStamptoTime(message.messageDate),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
          if (mine)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  userSender.photoUrl,
                ),
              ),
            )
          else
            Container(),
        ],
      ),
    );
  }
}
