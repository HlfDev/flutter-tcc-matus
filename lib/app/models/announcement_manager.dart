import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'announcement.dart';

class AnnouncementManager extends ChangeNotifier {
  AnnouncementManager() {
    _loadAnnouncement();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Announcement> allAnnouncements = [];
  String _search = '';
  String _category = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  String get category => _category;
  set category(String value) {
    _category = value;
    notifyListeners();
  }

  List<Announcement> get filteredAnnouncements {
    final List<Announcement> filteredAnnouncements = [];

    if (search.isEmpty) {
      filteredAnnouncements.addAll(allAnnouncements);
    } else {
      filteredAnnouncements.addAll(allAnnouncements
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }

    if (category.isNotEmpty) {
      final List<Announcement> categoryFilter = [];
      categoryFilter.addAll(filteredAnnouncements.where(
          (p) => p.category.toLowerCase().contains(category.toLowerCase())));

      filteredAnnouncements.clear();
      filteredAnnouncements.addAll(categoryFilter);
      return filteredAnnouncements;
    }

    return filteredAnnouncements;
  }

  Future<void> _loadAnnouncement() async {
    final QuerySnapshot snapAnnouncements =
        await firestore.collection("announcements").get();

    allAnnouncements = snapAnnouncements.docs
        .map((d) => Announcement.fromDocument(d))
        .toList();

    notifyListeners();
  }
}
