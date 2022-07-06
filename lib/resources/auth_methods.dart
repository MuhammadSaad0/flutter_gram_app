import 'dart:typed_data';
import '../models/user.dart' as Model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gram/resources/storage_methods.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String result = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl =
            await StorageMethods().uploadToStorage('profilePics', file, false);
        Model.User user = Model.User(
          bio: bio,
          email: email,
          followers: [],
          following: [],
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          username: username,
        );
        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        result = "Success";
      }
    } on FirebaseAuthException catch (err) {
      result = err.message.toString();
    } catch (err) {
      result = err.toString();
    }
    print(result);
    return result;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Email or Password cannot be empty";
      }
    } on FirebaseAuthException catch (err) {
      res = err.message.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future signOut() async {
    _auth.signOut();
  }
}
