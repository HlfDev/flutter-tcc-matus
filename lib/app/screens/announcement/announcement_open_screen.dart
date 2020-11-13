import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';

import 'package:floating_action_bubble/floating_action_bubble.dart';

import 'package:flutter/material.dart';
import 'package:matus_app/app/controllers/announcement_controller.dart';
import 'package:matus_app/app/helpers/datetime_converter.dart';
import 'package:matus_app/app/models/announcement.dart';
import 'package:matus_app/app/controllers/user_controller.dart';
import 'package:matus_app/app/models/user.dart';
import 'package:matus_app/app/screens/messages/chat_screen.dart';
import 'package:matus_app/app/themes/app_colors.dart';

import 'package:provider/provider.dart';

class AnnouncementOpenScreen extends StatefulWidget {
  const AnnouncementOpenScreen(this.announcement);

  final Announcement announcement;

  @override
  _AnnouncementOpenScreenState createState() => _AnnouncementOpenScreenState();
}

class _AnnouncementOpenScreenState extends State<AnnouncementOpenScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (_, userController, __) {
      return Scaffold(
        floatingActionButton: userController.isLoggedIn == true
            ? userController.user.id != widget.announcement.user
                ? FloatingActionButton(
                    onPressed: () {
                      final User userReceptor = context
                          .read<UserController>()
                          .findUserById(widget.announcement.user);
                      final User userSender =
                          context.read<UserController>().user;

                      if (userSender.id == widget.announcement.id) {
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                userReceptor: userReceptor,
                                userSender: userSender)));
                      }
                    },
                    child: const Icon(Icons.chat),
                  )
                : FloatingActionBubble(
                    // Menu items
                    items: <Bubble>[
                      // Floating action menu item
                      Bubble(
                        title: "Desativar anúncio",
                        iconColor: Colors.white,
                        bubbleColor: AppColor.primaryColor,
                        icon: Icons.delete,
                        titleStyle:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        onPress: () {
                          context
                              .read<AnnouncementController>()
                              .delete(widget.announcement);
                          Navigator.of(context).pop();
                          _animationController.reverse();
                        },
                      ),
                      // Floating action menu item
                      Bubble(
                        title: "Editar anúncio",
                        iconColor: Colors.white,
                        bubbleColor: AppColor.primaryColor,
                        icon: Icons.edit,
                        titleStyle:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        onPress: () {
                          Navigator.of(context).pushReplacementNamed(
                              '/announcement_edit',
                              arguments: widget.announcement);
                          _animationController.reverse();
                        },
                      ),
                      //Floating action menu item
                    ],
                    animation: _animation,
                    // animation controller

                    // On pressed change animation state
                    onPress: () => _animationController.isCompleted
                        ? _animationController.reverse()
                        : _animationController.forward(),

                    // Floating Action button Icon color
                    iconColor: Colors.white,

                    // Flaoting Action button Icon
                    iconData: Icons.add,
                    backGroundColor: AppColor.primaryColor,
                  )
            : Container(),
        appBar: AppBar(
          title: Text(widget.announcement.title),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserController>(
              builder: (_, userController, __) {
                if (userController.isLoggedIn == true) {
                  if (widget.announcement.user == userController.user.id) {
                    return Container();
                  } else if (userController.user.savedAnnouncements
                      .contains(widget.announcement.id)) {
                    return IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        userController
                            .removeSavedAnnouncement(widget.announcement.id);
                      },
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        userController
                            .addSavedAnnouncement(widget.announcement.id);
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
                images: widget.announcement.photos.map((url) {
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
                    'R\$ ${widget.announcement.price}',
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    widget.announcement.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Anúnciado em ${convertStamp(widget.announcement.announcementDate)}',
                    style: const TextStyle(
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
                    widget.announcement.description,
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
                    'Categoria: ${widget.announcement.category}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Peso: ${widget.announcement.weigth} ${widget.announcement.unity}',
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
                    'CEP: ${widget.announcement.announcementAddress.cep}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Cidade/Estado: ${widget.announcement.announcementAddress.city} - ${widget.announcement.announcementAddress.state}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Bairro: ${widget.announcement.announcementAddress.neighbornhood}',
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
                    height: 16.0,
                  ),
                  Consumer<UserController>(builder: (_, userController, __) {
                    final User userReceptor = context
                        .read<UserController>()
                        .findUserById(widget.announcement.user);

                    return Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userReceptor.photoUrl),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(userReceptor.name),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
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
