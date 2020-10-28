import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  Announcement.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data()['images'] as List<dynamic>);
    category = document['category'] as String;
  }

  String id;
  String name;
  String description;
  List<String> images;
  String category;
}
