import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({this.id, this.name, this.photoUrl, this.loginType});

  String id;
  String name;
  String photoUrl;
  String loginType;

  DocumentReference get firestoreUserRef =>
      FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveData() async {
    await firestoreUserRef.set(toDocument());
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'loginType': loginType,
    };
  }

  User.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.get('name') as String;
    photoUrl = document.get('photoUrl') as String;
    loginType = document.get('loginType') as String;
  }
}
