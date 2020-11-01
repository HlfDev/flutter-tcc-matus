import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'announcement.dart';

class AnnouncementManager extends ChangeNotifier {
  AnnouncementManager() {
    _loadAnnouncement();
    _loadOwnerAnnouncement();
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Announcement> allAnnouncements = [];
  List<Announcement> myAnnouncements = [];
  final firebase.FirebaseAuth _fauth = firebase.FirebaseAuth.instance;

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

  Future<void> _loadOwnerAnnouncement() async {
    if (_fauth.currentUser != null) {
      final QuerySnapshot snapAnnouncements = await firestore
          .collection("announcements")
          .where('owner', isEqualTo: _fauth.currentUser.uid)
          .get();

      myAnnouncements = snapAnnouncements.docs
          .map((d) => Announcement.fromDocument(d))
          .toList();
    }

    notifyListeners();
  }
}
