import 'package:flutter/material.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/models/message.dart';
import 'package:matus_app/app/models/user.dart';
import 'package:matus_app/app/themes/app_colors.dart';
import 'package:provider/provider.dart';

import '../chat_screen.dart';

class MessageListTile extends StatelessWidget {
  const MessageListTile({Key key, this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (_, userController, __) {
      final User userSender = userController.findUserById(message.userSender);
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatScreen(
                  userReceptor: userSender, userSender: userController.user)));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 70.0,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userSender.photoUrl),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(userSender.name),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.mark_chat_unread,
                          color: AppColor.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
