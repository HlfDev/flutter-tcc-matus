import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  Announcement.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data()['images'] as List<dynamic>);
    cep = document['cep'] as String;
    city = document['city'] as String;
    state = document['state'] as String;
    price = document['price'] as double;
    unity = document['unity'] as String;
    amount = document['amount'] as int;
    owner = document['owner'] as String;
    usersFavorited =
        List<String>.from(document.data()['usersFavorited'] as List<dynamic>);
    date = document['date'] as Timestamp;
  }

  String id;
  String name;
  String description;
  List<String> images;
  String category;
  String cep;
  String city;
  String state;
  double price;
  String unity;
  int amount;
  String owner;
  List<String> usersFavorited;
  Timestamp date;
}
