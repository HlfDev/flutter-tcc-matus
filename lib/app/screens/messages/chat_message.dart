import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  // ignore: avoid_positional_boolean_parameters
  const ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;

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
                  data['photo'] as String,
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
                if (data['photo'] != null)
                  Image.network(
                    data['photo'] as String,
                    width: 250,
                  )
                else
                  Text(
                    data['text'] as String,
                    textAlign: mine ? TextAlign.end : TextAlign.start,
                    style: const TextStyle(fontSize: 16),
                  ),
                const Text(
                  'teste',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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
                  data['photo'] as String,
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
