import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/models/auth_model.dart';
import 'package:govimithura/models/error_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login(AuthModel authModel) async {
    try {
      UserCredential userCred = await _auth
          .signInWithEmailAndPassword(
              email: authModel.email, password: authModel.password)
          .then((value) => value);

      return userCred.user?.uid != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ErrorModel.errorMessage = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        ErrorModel.errorMessage = 'Wrong password provided for this user.';
      } else {
        ErrorModel.errorMessage = e.message ?? '';
      }
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }

  Future<AuthModel?> register(AuthModel authModel) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: authModel.email, password: authModel.password)
          .then((value) => {
                debugPrint("User registered ${value.user!.uid}"),
                authModel.uid = value.user!.uid,
              });
      return authModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ErrorModel.errorMessage = 'The account already exists for this email.';
      } else if (e.code == 'invalid-email') {
        ErrorModel.errorMessage = 'Invalid email address.';
      } else {
        ErrorModel.errorMessage = e.message ?? '';
      }
      return null;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
      return null;
    }
  }

  bool isLoggedIn() {
    _auth.userChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });
    return _auth.currentUser != null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
