import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:matus_app/app/models/announcement.dart';
import 'package:matus_app/app/models/user_manager.dart';
import 'package:provider/provider.dart';

class AnnouncementOpenScreen extends StatelessWidget {
  const AnnouncementOpenScreen(this.announcement);

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(announcement.name),
        centerTitle: true,
        actions: <Widget>[
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.isLoggedIn == true) {
                if (announcement.owner == userManager.user.id) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/announcement_edit',
                          arguments: announcement);
                    },
                  );
                } else if (userManager.user.favoritedAnnouncements
                    .contains(announcement.id)) {
                  return IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      userManager.removeFavoritedAnnouncement(announcement.id);
                    },
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      userManager.saveFavoritedAnnouncement(announcement.id);
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
              images: announcement.images.map((url) {
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
                  announcement.name,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  announcement.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
