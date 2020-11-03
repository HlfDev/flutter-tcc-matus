import 'package:flutter/material.dart';

import 'app/models/announcement.dart';

import 'app/screens/announcement/announcement_edit_screen.dart';
import 'app/screens/announcement/announcement_open_screen.dart';
import 'app/screens/base/main_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/announcement_edit':
        return MaterialPageRoute(
            builder: (_) => AnnouncementEditScreen(
                  settings.arguments as Announcement,
                ));
      case '/announcement_open':
        return MaterialPageRoute(
            builder: (_) => AnnouncementOpenScreen(
                  settings.arguments as Announcement,
                ));

      default:
        return MaterialPageRoute(
            builder: (_) => MainScreen(), settings: settings);
    }
  }
}
