import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //firebase sign in Anonymously
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      log("Error signing in anonymously: $e");
      return null;
    }
  }

  //firebase sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
