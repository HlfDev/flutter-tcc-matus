import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({this.id, this.name, this.photoUrl, this.loginType, this.date});

  String id;
  String name;
  String photoUrl;
  String loginType;
  Timestamp date = Timestamp.now();
  List<String> savedAnnouncements;

  DocumentReference get firestoreUserRef =>
      FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveData() async {
    await firestoreUserRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'loginType': loginType,
      'date': date,
      'savedAnnouncements': savedAnnouncements,
    };
  }

  User.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.get('name') as String;
    photoUrl = document.get('photoUrl') as String;
    loginType = document.get('loginType') as String;
    date = document['date'] as Timestamp;
    savedAnnouncements = List<String>.from(
        document.data()['savedAnnouncements'] as List<dynamic> ?? []);
  }
}
