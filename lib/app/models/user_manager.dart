import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:matus_app/app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    loadCurrentUser();
  }

  final firebase.FirebaseAuth _fauth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool get isLoggedIn => user != null;
  User user;

  void signOut() {
    _fauth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    final firebase.User currentUser = _fauth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await firestore.collection('users').doc(currentUser.uid).get();
      user = User.fromDocument(docUser);
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle({Function onFail, Function onSuccess}) async {
    if (_fauth.currentUser != null) return;
    try {
      // ignore: unused_local_variable
      firebase.UserCredential userCredential;

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final firebase.AuthCredential credential =
          firebase.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final firebase.UserCredential authResult =
          await _fauth.signInWithCredential(credential);

      if (authResult.user != null) {
        final firebase.User firebaseUser = authResult.user;

        user = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
          loginType: "Google",
        );

        await user.saveData();
      }
    } catch (e) {
      // ignore: avoid_print
    }
  }
}
