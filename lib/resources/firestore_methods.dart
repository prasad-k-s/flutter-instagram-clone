import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/post.dart';
import 'package:flutter_instagram_clone/resources/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required Uint8List file,
    required String description,
    required String uid,
    required String username,
    required String profileImage,
  }) async {
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toMap(),
          );
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> likePost(String postID, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postID).update(
          {
            'likes': FieldValue.arrayRemove([uid]),
          },
        );
      } else {
        _firestore.collection('posts').doc(postID).update(
          {
            'likes': FieldValue.arrayUnion([uid]),
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
