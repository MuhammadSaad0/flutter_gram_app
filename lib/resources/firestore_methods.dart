import 'dart:typed_data';
import 'package:uuid/uuid.dart';

import '../models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gram/resources/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error occurred";
    try {
      String postId = const Uuid().v1();
      String photoUrl =
          await StorageMethods().uploadToStorage('posts', file, true);
      Post post = Post(
        datePublished: DateTime.now(),
        description: description,
        likes: [],
        postId: postId,
        postUrl: photoUrl,
        profImage: profImage,
        uid: uid,
        username: username,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
