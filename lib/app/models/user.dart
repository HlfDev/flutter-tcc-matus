import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({this.id, this.nickName, this.photoUrl, this.loginType});

  String id;
  String nickName;
  String photoUrl;
  String loginType;

  DocumentReference get firestoreUserRef =>
      FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveData() async {
    await firestoreUserRef.set(toDocument());
  }

  Map<String, dynamic> toDocument() {
    return {
      'nickName': nickName,
      'photoUrl': photoUrl,
      'loginType': loginType,
    };
  }

  User.fromDocument(DocumentSnapshot document) {
    id = document.id;
    nickName = document.get('nickName') as String;
    photoUrl = document.get('photoUrl') as String;
    loginType = document.get('loginType') as String;
  }
}
