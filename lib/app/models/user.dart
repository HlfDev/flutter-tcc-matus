import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User(
      {this.id,
      this.name,
      this.photoUrl,
      this.loginType,
      this.accountDate,
      this.savedAnnouncements});

  String id;
  String name;
  String photoUrl;
  String loginType;
  Timestamp accountDate;
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
      'accountDate': accountDate ?? Timestamp.now(),
      'savedAnnouncements': savedAnnouncements ?? [],
    };
  }

  User.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.get('name') as String;
    photoUrl = document.get('photoUrl') as String;
    loginType = document.get('loginType') as String;
    accountDate = document['accountDate'] as Timestamp;
    savedAnnouncements =
        List<String>.from(document['savedAnnouncements'] as List<dynamic>);
  }
}
