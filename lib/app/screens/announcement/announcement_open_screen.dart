import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:matus_app/app/controllers/announcement_controller.dart';
import 'package:matus_app/app/models/announcement.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/models/user.dart';
import 'package:matus_app/app/screens/messages/chat_screen.dart';
import 'package:matus_app/app/themes/app_colors.dart';

import 'package:provider/provider.dart';

class AnnouncementOpenScreen extends StatelessWidget {
  const AnnouncementOpenScreen(this.announcement);

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (_, userController, __) {
      return Scaffold(
        floatingActionButton: userController.isLoggedIn == true
            ? userController.user.id != announcement.user
                ? FloatingActionButton(
                    onPressed: () {
                      final User userReceptor = context
                          .read<UserController>()
                          .findUserById(announcement.user);
                      final User userSender =
                          context.read<UserController>().user;

                      if (userSender.id == announcement.id) {
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                userReceptor: userReceptor,
                                userSender: userSender)));
                      }
                    },
                    child: const Icon(Icons.chat),
                  )
                : FloatingActionButton(
                    onPressed: () {
                      context
                          .read<AnnouncementController>()
                          .delete(announcement);
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.delete),
                  )
            : Container(),
        appBar: AppBar(
          title: Text(announcement.title),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserController>(
              builder: (_, userController, __) {
                if (userController.isLoggedIn == true) {
                  if (announcement.user == userController.user.id) {
                    return IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            '/announcement_edit',
                            arguments: announcement);
                      },
                    );
                  } else if (userController.user.savedAnnouncements
                      .contains(announcement.id)) {
                    return IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        userController.removeSavedAnnouncement(announcement.id);
                      },
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        userController.addSavedAnnouncement(announcement.id);
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
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.5,
              child: Carousel(
                images: announcement.photos.map((url) {
                  return CachedNetworkImage(
                    imageUrl: url,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                }).toList(),
                dotSize: 6,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: AppColor.primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'R\$ ${announcement.price}',
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    announcement.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    'Anúnciado em 03/03/20 as 22:00',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(
                    height: 40.0,
                    thickness: 1.0,
                  ),
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    announcement.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Divider(
                    height: 40.0,
                    thickness: 1.0,
                  ),
                  const Text(
                    'Detalhes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Categoria: ${announcement.category}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Peso: ${announcement.weigth} ${announcement.unity}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Divider(
                    height: 40.0,
                    thickness: 1.0,
                  ),
                  const Text(
                    'Localização',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'CEP: ${announcement.announcementAddress.cep}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Cidade/Estado: ${announcement.announcementAddress.city} - ${announcement.announcementAddress.state}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Bairro: ${announcement.announcementAddress.neighbornhood}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Divider(
                    height: 40.0,
                    thickness: 1.0,
                  ),
                  const Text(
                    'Anunciante',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'CEP: ${announcement.announcementAddress.cep}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
