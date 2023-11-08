import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String userName,
    required String email,
    required String bio,
    required String password,
    required Uint8List file,
  }) async {
    try {
      return '';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    } catch (e) {
      return e.toString();
    }
  }
}
