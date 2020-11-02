import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'announcement.dart';

class AnnouncementController extends ChangeNotifier {
  AnnouncementController() {
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
          .where((p) => p.title.toLowerCase().contains(search.toLowerCase())));
    }

    if (category.isNotEmpty) {
      return filteredAnnouncements
          .where(
              (l) => l.category.toLowerCase().contains(category.toLowerCase()))
          .toList();
    }

    return filteredAnnouncements;
  }

  void update(Announcement announcement) {
    allAnnouncements.removeWhere((a) => a.id == announcement.id);
    allAnnouncements.add(announcement);
    notifyListeners();
  }

  Future<void> _loadAnnouncement() async {
    final QuerySnapshot snapAnnouncements =
        await firestore.collection("announcements").get();
    allAnnouncements = snapAnnouncements.docs
        .map((d) => Announcement.fromDocument(d))
        .toList();

    notifyListeners();
  }

  List<Announcement> findAnnouncementsCurrentUser(String id) {
    try {
      return allAnnouncements.where((l) => l.user == id).toList();
    } catch (e) {
      return null;
    }
  }

  List<Announcement> findSavedAnnouncementsCurrentUser(
      List<String> savedAnnouncements) {
    try {
      return allAnnouncements
          .where((l) => savedAnnouncements.contains(l.id))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
