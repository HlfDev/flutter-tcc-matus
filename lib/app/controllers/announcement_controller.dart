import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/announcement.dart';

class AnnouncementController extends ChangeNotifier {
  AnnouncementController() {
    loadAllAnnouncements();
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Announcement> allAnnouncements = [];

  String _search = '';
  String _category = '';
  String _location = '';

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

  String get location => _location;
  set location(String value) {
    _location = value;
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

  void delete(Announcement announcement) {
    announcement.delete();
    allAnnouncements.removeWhere((a) => a.id == announcement.id);
    notifyListeners();
  }

  Future<void> loadAllAnnouncements() async {
    final QuerySnapshot snapAnnouncements = await firestore
        .collection("announcements")
        .where('deleted', isEqualTo: false)
        .orderBy('announcementDate')
        .get();
    allAnnouncements = snapAnnouncements.docs
        .map((d) => Announcement.fromDocument(d))
        .toList();

    notifyListeners();
  }

  List<Announcement> findAnnouncementsCurrentUser(String user) {
    try {
      return allAnnouncements.where((a) => a.user == user).toList();
    } catch (e) {
      return null;
    }
  }

  List<Announcement> findSavedAnnouncementsCurrentUser(
      List<String> savedAnnouncements) {
    try {
      return allAnnouncements
          .where((a) => savedAnnouncements.contains(a.id))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
