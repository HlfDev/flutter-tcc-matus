import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:matus_app/app/models/announcement_address.dart';
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

  String id;
  String title;
  String description;
  List<String> photos = [];
  String category;
  String price;
  String unity;
  String weigth;
  Timestamp announcementDate = Timestamp.now();
  bool deleted = false;
  List<dynamic> newPhotos;
  String user;
  AnnouncementAddress announcementAddress;

  Announcement(
      {this.id,
      this.title,
      this.description,
      this.category,
      this.price,
      this.unity,
      this.weigth,
      this.announcementDate,
      this.deleted = false,
      this.photos,
      this.user,
      this.announcementAddress}) {
    photos = photos ?? [];
    announcementAddress = announcementAddress ?? AnnouncementAddress();
  }

  Announcement.fromDocument(DocumentSnapshot document) {
    id = document.id;
    title = document['title'] as String ?? '';
    description = document['description'] as String ?? '';
    photos =
        List<String>.from(document.data()['photos'] as List<dynamic>) ?? [];
    category = document['category'] as String ?? '';
    price = document['price'] as String ?? '';
    unity = document['unity'] as String ?? '';
    weigth = document['weigth'] as String ?? '';
    announcementDate = document['announcementDate'] as Timestamp;
    deleted = document['deleted'] as bool ?? false;
    user = document['user'] as String ?? '';
    announcementAddress = AnnouncementAddress.fromMap(
        document['announcementAddress'] as Map<String, dynamic>);
  }

  Future<void> saveData() async {
    loading = true;

    final Map<String, dynamic> data = {
      'title': title ?? '',
      'description': description ?? '',
      'photos': photos ?? '',
      'category': category ?? '',
      'price': price ?? '',
      'unity': unity ?? '',
      'weigth': weigth,
      'announcementDate': announcementDate ?? Timestamp.now(),
      'user': _fauth.currentUser.uid ?? '',
      'deleted': deleted ?? false,
      'announcementAddress': announcementAddress.toMap(),
    };

    if (id == null) {
      final doc = await firestore.collection('announcements').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
    final List<String> updateImages = [];

    for (final newPhoto in newPhotos) {
      if (photos.contains(newPhoto)) {
        updateImages.add(newPhoto as String);
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newPhoto as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }

      // for (final photo in photos) {
      //   if (!(newPhotos.contains(photo)) && photo.contains('firebase')) {
      //     try {
      //       final ref = await storage.getReferenceFromUrl(photo);
      //       await ref.delete();
      //     } catch (e) {
      //       debugPrint('Falha ao deletar $photo');
      //     }
      //   }
      // }

      await firestoreRef.update({'photos': updateImages});

      photos = updateImages;
      loading = false;
    }
  }

  void delete() {
    firestoreRef.update({'deleted': true});
  }

  Announcement clone() {
    return Announcement(
      id: id,
      title: title,
      description: description,
      photos: List.from(photos),
      category: category,
      price: price,
      unity: unity,
      weigth: weigth,
      announcementDate: announcementDate ?? Timestamp.now(),
      deleted: deleted ?? false,
      user: user ?? _fauth.currentUser.uid,
      announcementAddress: announcementAddress.clone(),
    );
  }
}
