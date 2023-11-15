import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_instagram_clone/resources/firebase_storage.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String userName,
    required String email,
    required String bio,
    required String password,
    required Uint8List file,
  }) async {
    try {
      //sign up user

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      String url = await StorageMethods().uploadImageToStorage("profilePics", file, false);
      //store bio file username in firestore database

      await _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
          'username': userName,
          'uid': userCredential.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': url,
        },
      );

      return 'Account created successfully';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Logged in successfully';
    } on FirebaseAuthException {
      return 'Invalid login credentials';
    } catch (e) {
      return e.toString();
    }
  }
}
