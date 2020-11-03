import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:matus_app/app/models/announcement.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/models/user.dart';
import 'package:matus_app/app/screens/messages/chat_screen.dart';
import 'package:provider/provider.dart';

class AnnouncementOpenScreen extends StatelessWidget {
  const AnnouncementOpenScreen(this.announcement);

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(announcement.title),
        centerTitle: true,
        actions: <Widget>[
          Consumer<UserController>(
            builder: (_, userManager, __) {
              if (userManager.isLoggedIn == true) {
                if (announcement.user == userManager.user.id) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/announcement_edit',
                          arguments: announcement);
                    },
                  );
                } else if (userManager.user.savedAnnouncements
                    .contains(announcement.id)) {
                  return IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      userManager.removeSavedAnnouncement(announcement.id);
                    },
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      userManager.addSavedAnnouncement(announcement.id);
                    },
                  );
                }
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Consumer<UserController>(builder: (_, userController, __) {
        final User user = userController.findUserById(announcement.user);
        return ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.5,
              child: Carousel(
                images: announcement.photos.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    announcement.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Valor',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ 19.99',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    announcement.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    userReceptor: user,
                                    userSender: userController.user,
                                  )),
                        );
                      },
                      child: const Text('Conversar com Anúnciante')),
                  Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(user.photoUrl)))),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
