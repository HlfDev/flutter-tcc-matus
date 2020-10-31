import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:uuid/uuid.dart';

class Announcement extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final firebase.FirebaseAuth _fauth = firebase.FirebaseAuth.instance;

  DocumentReference get firestoreRef => firestore.doc('announcements/$id');
  StorageReference get storageRef =>
      storage.ref().child('announcements').child(id);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Announcement(
      {this.id,
      this.name,
      this.description,
      this.category,
      this.cep,
      this.city,
      this.state,
      this.price,
      this.unity,
      this.amount,
      this.owner,
      this.date,
      this.excluded,
      this.images}) {
    images = images ?? [];
  }

  Announcement.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data()['images'] as List<dynamic>);
    category = document['category'] as String;
    cep = document['cep'] as String;
    city = document['city'] as String;
    state = document['state'] as String;
    price = document['price'] as num;
    unity = document['unity'] as String;
    amount = document['amount'] as int;
    owner = document['owner'] as String;
    date = document['date'] as Timestamp;
    excluded = document['excluded'] as bool;
  }

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'images': images,
      'category': category,
      'cep': cep,
      'city': 'Campinas',
      'state': 'São Paulo',
      'price': price,
      'unity': unity,
      'amount': amount,
      'date': date,
      'owner': _fauth.currentUser.uid,
      'excluded': excluded,
    };

    if (id == null) {
      final doc = await firestore.collection('announcements').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
    final List<String> updateImages = [];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }

      for (final image in images) {
        if (!newImages.contains(image)) {
          try {
            final ref = await storage.getReferenceFromUrl(image);
            await ref.delete();
          } catch (e) {
            debugPrint('Falha ao deletar $image');
          }
        }
      }

      await firestoreRef.update({'images': updateImages});

      images = updateImages;
      loading = false;
    }
  }

  Announcement clone() {
    return Announcement(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      category: category,
      cep: cep,
      city: city,
      state: state,
      price: price,
      unity: unity,
      amount: amount,
      owner: owner,
      date: date,
      excluded: excluded,
    );
  }

  String id;
  String name;
  String description;
  List<String> images;
  String category;
  String cep;
  String city;
  String state;
  num price;
  String unity;
  int amount;
  String owner;
  Timestamp date = Timestamp.now();
  bool excluded = false;
  List<dynamic> newImages;
}
